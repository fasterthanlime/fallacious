import bencoding, io/FileReader

torrent := BDecoder read(FileReader new("samples/War2BNE.torrent"))

info := torrent["info"]

"Trackers: " println()
i := 0
torrent["announce-list"] each(|group|
    "  Group %d" printfln(i += 1)
    group each(|tracker|
	"    %s" printfln(tracker _)
    )
)

"Created by: %s" printfln(torrent["created by"] _)
"Name: %s" printfln(info["name"] _)

