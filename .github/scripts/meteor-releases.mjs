#!/usr/bin/env node
import { appendFileSync } from 'node:fs'

const REPO = 'meteor/meteor'
const TAG_PREFIX = 'release/METEOR@'

// Meteor's GitHub releases only go back to 3.0; older LTS lines are declared here.
const LEGACY_RELEASES = ['2.16']

// First release with linux/arm64 bootstrap tarballs.
const MULTIARCH_MIN = { major: 3, minor: 1 }

const api = (page) =>
  `https://api.github.com/repos/${REPO}/releases?per_page=100&page=${page}`

async function fetchReleases() {
  const headers = { accept: 'application/vnd.github+json' }
  if (process.env.GITHUB_TOKEN) {
    headers.authorization = `Bearer ${process.env.GITHUB_TOKEN}`
  }

  const releases = []
  for (let page = 1; ; page++) {
    const res = await fetch(api(page), { headers })
    if (!res.ok) throw new Error(`GitHub API ${res.status}: ${await res.text()}`)
    const batch = await res.json()
    releases.push(...batch)
    if (batch.length < 100) break
  }
  return releases
}

const parse = (version) => {
  const m = /^(\d+)\.(\d+)(?:\.(\d+))?$/.exec(version)
  return m ? { tag: version, major: +m[1], minor: +m[2], patch: m[3] ? +m[3] : null } : null
}

const isMultiarch = ({ major, minor }) =>
  major > MULTIARCH_MIN.major ||
  (major === MULTIARCH_MIN.major && minor >= MULTIARCH_MIN.minor)

// Selection policy, derived dynamically (no hardcoded 3.x list):
//   - every minor track of the newest major line (3.0, 3.1, ... 3.5)
//   - every patch of the newest minor within that line (3.5.1, 3.5.2)
//   - the newest minor track of the previous major line, plus LEGACY_RELEASES
function buildMatrix(releases) {
  const entries = releases
    .filter((r) => !r.draft && !r.prerelease && r.tag_name.startsWith(TAG_PREFIX))
    .map((r) => parse(r.tag_name.slice(TAG_PREFIX.length)))
    .filter(Boolean)

  const tracks = entries.filter((e) => e.patch === null)
  const patches = entries.filter((e) => e.patch !== null)

  const majors = [...new Set(tracks.map((e) => e.major))].sort((a, b) => b - a)
  const newestMajor = majors[0]
  const previousMajor = majors[1]

  const newestTracks = tracks
    .filter((e) => e.major === newestMajor)
    .sort((a, b) => b.minor - a.minor)
  const highestMinor = newestTracks[0].minor

  const newestPatches = patches
    .filter((e) => e.major === newestMajor && e.minor === highestMinor)
    .sort((a, b) => b.patch - a.patch)

  const previousTracks = tracks.filter((e) => e.major === previousMajor)
  const previousTrack = previousTracks.length
    ? previousTracks.reduce((a, b) => (b.minor > a.minor ? b : a))
    : null

  const ordered = [
    ...newestPatches,
    newestTracks[0],
    ...newestTracks.slice(1),
    ...(previousTrack ? [previousTrack] : []),
    ...LEGACY_RELEASES.map(parse).filter(Boolean),
  ]

  const seen = new Set()
  const unique = ordered.filter((e) => !seen.has(e.tag) && seen.add(e.tag))

  const latest = newestTracks[0].tag

  return {
    include: unique.map((e) => ({
      release: e.tag,
      multiarch: isMultiarch(e),
      latest: e.tag === latest,
    })),
  }
}

const setOutput = (name, value) => {
  if (process.env.GITHUB_OUTPUT) {
    appendFileSync(process.env.GITHUB_OUTPUT, `${name}<<EOF\n${value}\nEOF\n`)
  } else {
    console.log(`${name}=${value}`)
  }
}

const matrix = buildMatrix(await fetchReleases())
const latest = matrix.include.find((e) => e.latest)?.release ?? ''

setOutput('matrix', JSON.stringify(matrix))
setOutput('latest', latest)
