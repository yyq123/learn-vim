func! MyHandler (channel, msg)
    echomsg 'From the handler:' . a:msg
endfunc

func! CloseHandler (channel)
    while ch_status (a:channel, {"part":"out"}) == "buffered"
        echomsg ch_read (a:channel)
        echomsg 'Finished'
    endwhile
endfunc

func! GetDate ()
    call job_start (["/bin/bash", "-c", "date; sleep 3s; date "], {"callback":"MyHandler"})
endfunc

nnoremap <f3> :call GetDate()<cr>
