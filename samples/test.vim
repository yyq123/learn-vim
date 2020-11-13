func! MyHandler (channel, msg)
    echomsg a:msg
endfunc

func! CloseHandler (channel)
    while ch_status (a:channel, {"part":"out"}) == "buffered"
        echomsg ch_read (a:channel)
    endwhile
endfunc

func! GetDate ()
"    call job_start (["/bin/bash", "-c", "date; sleep 3s; date "],
    call job_start (["/bin/bash", "-c", "ls -alh"],
                   \{"callback": "MyHandler", "close_cb": "CloseHandler"})
endfunc

nnoremap <f3> :call GetDate()<cr>


function! s:on_find(chan, msg)
  lgetexpr split(a:msg, '')
endfunction

call job_start('find . -print0', {
      \ 'out_mode': 'raw',
      \ 'callback': function('<SID>on_find')
      \ })

function! s:on_line(chan, msg)
  if empty(a:msg)
    let body = "Hello from Vim!"
    call ch_sendraw(a:chan, join([
          \ "HTTP/1.1 200 OK",
          \ "Content-Length: " . len(body),
          \ "Content-Type: text/plain",
          \ "",
          \ body
          \ ], "\n"))
  endif
endfunction

" Save reference to long-running job or it will be garbage collected
let server = call job_start('nc -lp 3000', {
      \ 'callback': function('<SID>on_line'),
      \ 'in_mode': 'raw',
      \ 'out_mode': 'nl'
      \ })
