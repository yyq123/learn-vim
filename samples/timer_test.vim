func MyHandler(timer)
  echo 'Handler called'
endfunc

let timer = timer_start(10000, 'MyHandler', {'repeat': -1})

let s:id = timer_start(500, function({ l ->
\   execute("let l.value += 1 | echo l.value", "")
\}, [{"value" : 0}]), { "repeat" : 5 })

" Timer ID を指定することもできる
" この時にも戻り値は配列なので注意
echo timer_info(s:id)
" => [{'id': 16, 'repeat': 5, 'remaining': 499, 'time': 500, 'callback': function('<lambda>7', [{'value': 0}])}]

" ちょっと待機
sleep 1
" 残りの repeat 回数が減ってる
echo timer_info(s:id)
" => [{'id': 16, 'repeat': 3, 'remaining': 498, 'time': 500, 'callback': function('<lambda>7', [{'value': 2}])}]

