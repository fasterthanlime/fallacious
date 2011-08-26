import TorrentDecoder, io/FileReader

td := TorrentDecoder new(FileReader new("samples/Adventureland.torrent"))
td read() _ println()

"Hash = " print()
for(i in 0..20) {
    "%02x" printf(td infoHash[i]) 
}
println()

