let flavor = {
\ '01': 'guava'
\ '02': 'mangosteen'
\ '03': 'mango'
\ '04': 'banana'
\ '05': 'coconut'
\ '06': 'passionfruit'
\ '07': 'watermelon'
\ '08': 'papya'
}


let seen = {}	" Haven't seen anything yet
let daytonum = {'Sun':0, 'Mon':1, 'Tue':2, 'Wed':3, 'Thu':4, 'Fri':5, 'Sat':6 }
let diagnosis = {
\	'Perl'	: 'Tourettes',
\	'Python'	: 'OCD',
\	'Lisp'	: 'Megalomania',
\	'PHP'	: 'Idiot-Savant',
\	'C++'	: 'Savant-Idiot',
\	'C#'	: 'Sociopathy',
\	'Java'	: 'Delusional',
\}


let lang = input("Patient's name? ")

let Dx = diagnosis[lang]

let keylist = keys(dict)
let valuelist = values(dict)
let pairlist = items(dict)


"Remove any entry whose key starts with C... 
call filter(diagnosis, 'v:key[0] != "C"') 

"Remove any entry whose value doesn't contain 'Savant'... 
call filter(diagnosis, 'v:val =~ "Savant"') 

"Remove any entry whose value is the same as its key... 
call filter(diagnosis, 'v:key != v:val') 


let is_empty =	empty(dict)	" True if no entries at all
let entry_count = len(dict)	" How many entries?	
let occurrences = count(dict, str)	" How many values are	equal to str?
let greatest = max(dict)	" Find largest value of any entry
let least	= min(dict)	" Find smallest value	of any entry
call map(dict, value_transform_str)	" Transform values by	eval'ing string
echo string(dict)	" Print dictionary as	key/value pairs

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

