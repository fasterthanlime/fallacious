import bencoding, io/FileReader

torrent := BDecoder read(FileReader new("samples/War2BNE.torrent"))

info := torrent["info"]

"Trackers: " println()
i := 0
torrent["announce-list"] each(|group|
    "\t - Tracker group #%d" printfln(i)
    i += 1
    /*
    group each(|tracker|
	"\t\t - %s" printfln(tracker _)
    )
    */
)

"Created by\t %s" printfln(torrent["created by"] _)
"Name\t\t %s" printfln(info["name"] _)

