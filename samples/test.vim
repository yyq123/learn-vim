func! MyHandler (channel, msg)
    "deal with msg
    echomsg 'From the handler:' . a:msg
endfunc

func! CloseHandler (channel)
while ch_status (a:channel, {"part":"out"}) == "buffered"
    echomsg ch_read (a:channel)
endwhile
endfunc
