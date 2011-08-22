# fallacious

## The Name

Fall is water-related, so is torrent, so that's that.

## Every torrent application ever sucks

Yes, there's libtorrent.

Yes, there are dozens of remotes for Vuze, uTorrent, Deluge and whatnot.

But they're all missing the point :)

## What fallacious is all about

Fallacious intends to make it as easy as possible to search for torrents,
queue theme, manage priorities, and stream them from the confort of your
web browser.

## But how?

Fallacious is composed of separate parts:

  * A torrent daemon - pretty much like libtorrent or uTorrent-server, except
    it's got a nice REST API so you can just throw requests at it and manage
    your list of torrents.
  * A web application that connects to that torrent daemon and has a nice
    HTML+CSS+JS (or dare I say, HTML5?) interface to it.

## Requirements

### fallacious-daemon

The daemon should:

  * Support multi-files torrents (doh!)
  * Support seeding (duh.)
  * Support prioritizing files in torrents
  * Support pause/play
  * Support bandwidth caps
  * Support intra-block prioritizing to allow streaming
  * Support serving files via a built-in HTTP server

### fallacious-app

The app should:

  * Support torrent search from multiple providers (Torrentz, but also fallbacks)
    and present them in a unified, nice way
  * Interface with fallacious-daemon nicely, with a 'File list' view but also why
    not a 'TV Shows' list and a 'Movies' list.. maybe even music? Although that isn't
    the primary goal, it would be interesting.
  * Allow access to the HTTP streaming URLs that fallacious-daemon exposes, so that
    they can be opened either in external players (mplayer, vlc, etc.) or in the web
    app (e.g. jPlayer)
