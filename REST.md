# A few notes about the REST API

## Endpoints

RESTful urls, e.g.:

    * GET    /torrents (R02)
    * GET    /torrents/<sha1_hash> (R01)
    * POST   /torrents/<sha1_hash>
    * DELETE /torrents/<sha1_hash>
    * GET    /torrents/<sha1_hash>/pieces (R05)
    * GET    /torrents/<sha1_hash>/peers  (R03)
    * GET    /torrents/<sha1_hash>/seeds
    * GET    /torrents/<sha1_hash>/leeches
    * GET    /torrents/<sha1_hash>/files

## Responses

### R01 - Torrent (e.g.: GET /torrents/<sha1_hash>)

Example:

    {
	result: 'success',
	value: {
	    title: '...',
	    author: '...',
	    comment: '...',
	    hash: '...',
	    bytes: 0,
	    files: [
		'<path>': {
		    size: 0,
		    priority: 1.0,
		    stream: '...'
		}
	    ]
	}
    }

Files is a flat array (ie not nested), as in the BitTorrent standard.

Folders don't exist, they're just paths necessary for a file to exist. So
for example we might have a list of files like this:

    SomeTorrent/README
    SomeTorrent/4thelulz.url
    SomeTorrent/Season 1/Steal this TV Show! - Episode 1.mkv
    SomeTorrent/Season 1/Steal this TV Show! - Episode 2.mkv
    SomeTorrent/Season 1/Steal this TV Show! - Episode 3.mkv

...and thus 'Season 1' would exist, without it being in the list

File priority is a floating number between 0.0 and 1.0. Initial value is 0.01
It's relative priority so a number < 1.0 doesn't mean it'll go slower!

Stream is an HTTP url allowing the file to be streamed, in the form:

    http://app:port/<torrent_sha1_hash>/<zero_based_file_index>

So for example, one could stream the second episode of 'Steal this TV Show' by doing

    http://myserver.ath.cx:6942/

Where port is definitely something higher than 1024 ;)

### R02 - List of torrents

    {
	result: 'success',
	value: [
	    <array of values from R01>
	]
    }

### R03 - Peer

    {
	result: 'success',
	value: {
	    peerId: '...',
	    ip: '...', /* might be IPv4 or IPv6 */,
	    completion: 0,
	}
    }

### R04 - List of peers

    {
	result: 'success',
	value: [
	    <array of values from R03>
	]
    }

### R05 - Piece

    {
	result: 'succes',
	value: {
	    index: 0,
	    start: 0,
	    length: 0,
	    hash: '...',
	}
    }



