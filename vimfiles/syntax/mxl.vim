" Essbase MaxL Script Syntax
" Language: MaxL script
" Maintainer: Anthony Yuan <yyq123@gmail.com> <http://yyq123.blogspot.com/>
" Last change: 2011 Jan 15	

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

sy	keyword	mxlTodo contained TODO FIXME XXX

" CommentGroup allows adding matches for special things in comments
sy	cluster mxlCommentGroup contains=mxlTodo

"substitution variable
sy	region	mxlSubVar	start="&" end="\>"he=s-1
sy	region	mxlEnvVar	start="\$" end="\>"he=s-1

" Strings in quotes
sy	match	mxlError	'"'
"sy	match	mxlString	'"[^"]*"'
"sy	match	mxlStringD	"'[^']*'"
sy	region	mxlString	start=+'+  end=+'+
sy	region	mxlStringD	start=+"+  end=+"+ contains=mxlString,mxlEnvVar

"when wanted, highlight trailing white space
if exists("mxl_space_errors")
	if !exists("mxl_no_trail_space_error")
		sy	match	mxlSpaceE	"\s\+$"
	endif
	if !exists("mxl_no_tab_space_error")
		sy	match	mxlSpaceE	" \+\t"me=e-1
	endif
endif

"catch errors caused by wrong parenthesis and brackets
sy	cluster	mxlParenGroup	contains=mxlParenE,@mxlCommentGroup,mxlUserCont,mxlBitField,mxlFormat,mxlNumber,mxlFloat,mxlOctal,mxlNumbers,mxlIfError,mxlComW,mxlCom,mxlFormula,mxlBPMacro
sy	region	mxlParen	transparent start='(' end=')' contains=ALLBUT,@mxlParenGroup
sy	match	mxlParenE	")"

"integer number, or floating point number without a dot and with "f".
sy	case	ignore
sy	match	mxlNumbers	transparent "\<\d\|\.\d" contains=mxlNumber,mxlFloat,mxlOctal
sy	match	mxlNumber	contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
sy	match	mxlNumber	contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
sy	match	mxlOctal	contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>"
sy	match	mxlFloat	contained "\d\+f"
	"floating point number, with dot, optional exponent
sy	match	mxlFloat	contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
sy	match	mxlFloat	contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
sy	match	mxlFloat	contained "\d\+e[-+]\=\d\+[fl]\=\>"

sy	region	mxlComment	start="/\*" end="\*/" contains=@mxlCommentGroup,mxlSpaceE fold
sy	match	mxlCommentE	"\*/"


"cross-dimension operator
sy	match	mxlCrossDimen	"->"

sy	keyword	mxlCondition	IF ELSE ENDIF ELSEIF
sy	keyword	mxlCondition	contained IF ELSE ENDIF ELSEIF
 

sy	keyword	mxlStatement	abort about absolute_value account_type active add advanced after aggregate_assume_equal aggregate_missing aggregate_storage aggregate_sum aggregate_view aggregate_use_last algorithm alias alias_names alias_table all all_users_groups alloc_rule allow allow_merge alter alternate_rollups amountcontext amounttimespan and any append application application_access_type apply archive archive_file are area attribute attribute_calc attribute_info attribute_spec attribute_to_base_member_association as aso_level_info associated at auto_password autostartup
sy	keyword	mxlStatement	backup_file basistimespan basistimespanoptions before begin bitmap blocks buffer_id buffered build but by
sy	keyword	mxlStatement	cache_pinning cache_size calc_formula calculation calc_script calc_string calculation cascade cell_status change_file clear cnt_sempaphore column_width columns combinebasis commands comment commitblock committed_mode compression connect connects consolidation constituent copy copy_subvar copy_useraccess create create_application create_blocks create_user creditmember created cube_size_info currency currency_category currency_conversion currency_database currency_member currency_rate current custom
sy	keyword	mxlStatement	data data_block data_cache_size data_file data_file_cache_size data_storage database days dbstats default definition definition_only definitions delete designer dimension dimensions direct direction directories directory disable disallow disk display division drop
sy	keyword	mxlStatement	echo elsewhere enable end error example, excel execute exit export export_directory external
sy	keyword	mxlStatement	file file_size file_type filter filter_access for force freespace from full function
sy	keyword	mxlStatement	gave gb get grant group groups
sy	keyword	mxlStatement	ha_trace hostname
sy	keyword	mxlStatement	identified if immediate implicit_commit import in inactive_user_days index index_cache_size index_data index_page_size indicated information input invalid_block_headers invalid_login_limit io_access_mode it its
sy	keyword	mxlStatement	kb key kill
sy	keyword	mxlStatement	level0 linked linked-reporting load local location location-alias lock lock_timeout logfile login logout lotus_2 lotus_3 lotus_4 lro
sy	keyword	mxlStatement	macro mapped max_lro_file_size mb member member_calculation member_info member_property minimum mining minutes mmbers model move multiplication
sy	keyword	mxlStatement	name never no_access none nonunicode_mode note nothing number
sy	keyword	mxlStatement	object of off on only optional optional_group or outline
sy	keyword	mxlStatement	particular partition partition_size password password_reset_days path performance permission phrase ports pre_image_access preserve private privilege property protocol purge query
sy	keyword	mxlStatement	read recover refresh remote remove rename repair replace replicated report_file request request_history reset restructure retrieve_buffer_size retrieve_sort retrieve_sort_buffer_size reverse rle row rows rules_file runtime
sy	keyword	mxlStatement	scope seconds security security_backup server session session, session_idle_limit session_idle_poll sessionforce sessions set settings shell shutdown single singlecell software spec specified spool startup stop supervisor sync system system-wide
sy	keyword	mxlStatement	task tb template text that the to transactions trigger two_pass_calc type
sy	keyword	mxlStatement	uda unicode unicode_mode unlimited unload unlock update updated updates user users using
sy	keyword	mxlStatement	validate variable vector version volume
sy	keyword	mxlStatement	where with write
sy	keyword	mxlStatement	you
sy	keyword	mxlStatement	zlib


" when wanted, highlighting lhs members or erros in asignments (may lag the editing)
if version >= 600 && exists("mxl_asignment")
	sy	match	mxlEqError	'\("[^"]*"\s*\|[^][\t !%()*+,--/:;<=>{}~]\+\s*\|->\s*\)*=\([^=]\@=\|$\)'
	sy	region	nxlFormula	transparent matchgroup=mxlVarName start='\("[^"]*"\|[^][\t !%()*+,--/:;<=>{}~]\+\)\s*=\([^=]\@=\|\n\)' skip='"[^"]*"' end=';' contains=ALLBUT,mxlFormula,mxlFormulaIn,mxlBPMacro,mxlCondition
	sy	region	mxlFormulaIn	matchgroup=mxlVarName transparent start='\("[^"]*"\|[^][\t !%()*+,--/:;<=>{}~]\+\)\(->\("[^"]*"\|[^][\t !%()*+,--/:;<=>{}~]\+\)\)*\s*=\([^=]\@=\|$\)' skip='"[^"]*"' end=';' contains=ALLBUT,mxlFormula,mxlFormulaIn,mxlBPMacro,mxlCondition contained
	sy	match	mxlEq	"=="
endif

if !exists("mxl_minlines")
	let mxl_minlines = 50	" mostly for () constructs
endif
exec "sy sync ccomment mxlComment minlines=" . mxl_minlines

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_mxl_syntax_inits")
	if version < 508
		let did_mxl_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	hi mxlVarName term=bold ctermfg=9 gui=bold guifg=blue
	hi mxlCondition ctermfg=lightcyan guifg=#E0FFFF

	HiLink	mxlNumber	Number
	HiLink	mxlOctal	Number
	HiLink	mxlFloat	Float
	HiLink	mxlParenE	Error
	HiLink	mxlCommentE	Error
	HiLink	mxlSpaceE	Error
	HiLink	mxlError	Error
	HiLink	mxlString	String
	HiLink	mxlStringD	String
	HiLink	mxlComment	Comment
	HiLink	mxlTodo		Todo
	HiLink	mxlStatement	Statement
	HiLink	mxlIfError	Error
	HiLink	mxlEqError	Error
	HiLink	mxlFunction	Statement
	HiLink	mxlWarn		WarningMsg

	HiLink	mxlComE	Error
	HiLink	mxlCom	Statement
	HiLink	mxlComW	WarningMsg

	HiLink	mxlBPMacro	Identifier
	HiLink	mxlBPW		WarningMsg

	HiLink	mxlLocal	Comment	
	HiLink	mxlSubVar	Identifier
	HiLink	mxlEnvVar	Special
	HiLink	mxlCrossDimen	Special

	delcommand HiLink
endif

" Set syntax name
let b:current_syntax = "mxl"

" vim: ts=8
