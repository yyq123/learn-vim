function! Uniq () range
    let have_already_seen = {}
    let unique_lines = []
    "Walk through the lines, remembering only the hitherto-unseen ones...
    for original_line in getline(a:firstline, a:lastline)
        let normalized_line = '>' . original_line
        if !has_key(have_already_seen, normalized_line)
            call add(unique_lines, original_line)
            let have_already_seen[normalized_line] = 1
        endif
    endfor
    "Replace the range of original lines with just the unique lines...
    exec a:firstline . ',' . a:lastline . 'delete'
    call append(a:firstline-1, unique_lines)
endfunction
