/* Copyright (C) 1986-2001 by Digital Mars. $Revision: 1.1.1.2 $ */
#if __SC__ || __RCC__
#pragma once
#endif

#ifndef __STDIO_H
#define __STDIO_H 1

#if __cplusplus
extern "C" {
#endif

/* Define _CRTAPI1 (for compatibility with the NT SDK) */
#ifndef _CRTAPI1
#define _CRTAPI1 __cdecl
#endif


/* Define _CRTAPI2 (for compatibility with the NT SDK) */
#ifndef _CRTAPI2
#define _CRTAPI2 __cdecl
#endif

/* Define CRTIMP */
#ifndef _CRTIMP
#if defined(_WIN32) && defined(_DLL)
#define _CRTIMP  __declspec(dllimport)
#else
#define _CRTIMP
#endif
#endif

#if __OS2__ && __INTSIZE == 4
#define __CLIB	__stdcall
#else
#define __CLIB	__cdecl
#endif

#if M_UNIX || M_XENIX || __NT__
#define _NFILE	60
#else
#define _NFILE	40
#endif


#define SEEK_SET	0
#define SEEK_CUR	1
#define SEEK_END	2

#ifndef NULL
#ifdef __cplusplus
#define NULL 0
#else
#define NULL ((void *)0)
#endif
#endif

#if __cplusplus
#define __RESTRICT
#else
#define __RESTRICT restrict
#endif

#if M_UNIX || M_XENIX
#define BUFSIZ		4096
extern char * __cdecl _bufendtab[];
#elif __INTSIZE == 4
#define BUFSIZ		0x4000
#else
#define BUFSIZ		1024
#endif

#if __INTSIZE == 2 && (__SMALL__ || __MEDIUM__)
#define BIGBUF		(20 * 1024)
#endif

#if _M_AMD64
typedef unsigned long long size_t;
#else
typedef unsigned size_t;
#endif

#ifndef __STDC__

#if !defined(_WCHAR_T_DEFINED)
typedef unsigned short wchar_t;
#define _WCHAR_T_DEFINED 1
#endif

typedef wchar_t wint_t;
typedef wchar_t wctype_t;
#endif

#define EOF (-1)

#ifndef __STDC__
#define WEOF (wint_t) (0xFFFF)
#endif

#ifndef __FILE_DEFINED
#pragma pack(1)
#define __FILE_DEFINED 1
typedef struct _iobuf
{
#if M_UNIX || M_XENIX
	int	_cnt;
	char	*_ptr;
	char	*_base;
	char	_flag;
	char	_file;
#define _bufsize(f) (_bufendtab[(f)->_file] - (f)->_base)
#elif __OS2__ && __INTSIZE == 4
	char	*_ptr;
	int	_cnt;
	char	*_base;
	int	_flag;
	int	_file;
	int	_charbuf;
	int	_bufsiz;
	int	__tmpnum;
#define _bufsize(f) ((f)->_bufsiz)
#elif __NT__
	char	*_ptr;
	int	_cnt;
	char	*_base;
	int	_flag;
	int	_file;
	int	_charbuf;
	int	_bufsiz;
	int	__tmpnum;
#define _bufsize(f) ((f)->_bufsiz)
#else
	char	*_ptr;
	int	_cnt;
	char	*_base;
	int	_flag;
	int	_file;
	unsigned _bufsiz;
#ifdef	BIGBUF
	int	_seg;
#endif
#define _bufsize(f) ((f)->_bufsiz)
#endif
} FILE;
#pragma pack()
#endif

#define _F_RDWR 0x0003
#define _F_READ 0x0001
#define _F_WRIT 0x0002
#define _F_BUF  0x0004
#define _F_LBUF 0x0008
#define _F_ERR  0x0010
#define _F_EOF  0x0020
#define _F_BIN  0x0040
#define _F_IN   0x0080
#define _F_OUT  0x0100
#define _F_TERM 0x0200

#ifdef M_ELF
#define _iob __iob
#endif

#if defined (_DLL)

#define _iob ( _p_iob() )
extern FILE * _p_iob(void);

#else

extern	FILE __cdecl _iob[_NFILE];

#endif

#define _IOREAD		1
#define _IOWRT		2
#define _IONBF		4
#define _IOMYBUF	8
#define _IOEOF		0x10
#define _IOERR		0x20
#define _IOLBF		0x40
#define _IOSTRG         0x40
#define _IORW		0x80
#define _IOFBF		0
#define _IOAPP		0x200
#if M_UNIX || M_XENIX
#define _IOTRAN		0
#else
#define _IOTRAN		0x100
#ifdef	BIGBUF
#define _IOBIGBUF	0x400
#endif
#endif

#define stdin	(&_iob[0])
#define stdout	(&_iob[1])
#define stderr	(&_iob[2])

#if M_UNIX || M_XENIX
#define FOPEN_MAX	60
#define FILENAME_MAX	255

#if !__STDC__ || defined(_POSIX_SOURCE) || defined(_XOPEN_SOURCE)
char * __cdecl ctermid(char *);
#define L_ctermid 9
#endif

#else
#ifndef __STDC__
#ifndef __NT__
#define stdaux	(&_iob[3])
#define stdprn	(&_iob[4])
#define _stdaux stdaux
#define _stdprn stdprn
#endif
#endif
#define FOPEN_MAX	20
#if defined(_WIN32)
#define FILENAME_MAX 256  /* 255 plus NULL */
#else
#define FILENAME_MAX	128
#endif
#endif

#if M_UNIX || M_XENIX
#define _P_tmpdir	"/usr/tmp/"
#define _wP_tmpdir	L"/usr/tmp/"
#else
#define _P_tmpdir	"\\"
#define _wP_tmpdir	L"\\"
#endif
#define P_tmpdir	_P_tmpdir
#define wP_tmpdir	_wP_tmpdir
#if !defined(_WIN32)
#define L_tmpnam	sizeof(_P_tmpdir)+8
#else
#define L_tmpnam    sizeof(_P_tmpdir)+12
#endif
#define TMP_MAX		32767
#define _SYS_OPEN       20
#define SYS_OPEN        _SYS_OPEN

typedef long fpos_t;

typedef char *va_list;

int	__CLIB fwide(FILE *stream, int mode);
char *	__CLIB tmpnam(char *);
FILE *	__CLIB fopen(const char *,const char *);
FILE *	__CLIB _fsopen(const char *,const char *,int );
FILE *	__CLIB freopen(const char *,const char *,FILE *);
int	__CLIB fseek(FILE *,long,int);
long	__CLIB ftell(FILE *);
char *	__CLIB fgets(char *,int,FILE *);
int	__CLIB fgetc(FILE *);
int   __CLIB _fgetchar(void);
int	__CLIB fflush(FILE *);
int	__CLIB fclose(FILE *);
int	__CLIB fputs(const char *,FILE *);
int	__CLIB getc(FILE *);
int	__CLIB getchar(void);
char *	__CLIB gets(char *);
int	__CLIB fputc(int,FILE *);
int   __CLIB _fputchar(int);
int	__CLIB putc(int,FILE *);
int	__CLIB putchar(int);
int	__CLIB puts(const char *);
int	__CLIB ungetc(int,FILE *);
size_t	__CLIB fread(void *,size_t,size_t,FILE *);
size_t	__CLIB fwrite(const void *,size_t,size_t,FILE *);
int	__cdecl printf(const char *,...);
int	__cdecl fprintf(FILE *,const char *,...);
int	__CLIB  vfprintf(FILE *,const char *,va_list);
int	__CLIB  vprintf(const char *,va_list);
int	__cdecl sprintf(char *,const char *,...);
int	__CLIB  vsprintf(char *,const char *,va_list);
int	__cdecl scanf(const char *,...);
int	__cdecl fscanf(FILE *,const char *,...);
int	__cdecl sscanf(const char *,const char *,...);
int	__CLIB vsnprintf(char * __RESTRICT,size_t,const char * __RESTRICT,va_list);
int	__CLIB vscanf(const char * __RESTRICT, va_list);
int	__CLIB vfscanf(FILE * __RESTRICT, const char * __RESTRICT, va_list);
int	__CLIB vsscanf(const char * __RESTRICT, const char * __RESTRICT, va_list);
void	__CLIB setbuf(FILE *,char *);
int	__CLIB setvbuf(FILE *,char *,int,size_t);
int	__CLIB remove(const char *);
int	__CLIB rename(const char *,const char *);
void	__CLIB rewind(FILE *);
void	__CLIB clearerr(FILE *);
int	__CLIB feof(FILE *);
int	__CLIB ferror(FILE *);
void	__CLIB perror(const char *);
int	__CLIB fgetpos(FILE *,fpos_t *);
int	__CLIB fsetpos(FILE *,const fpos_t *);
FILE *	__CLIB tmpfile(void);
int	__CLIB _rmtmp(void);
int     __CLIB _fillbuf(FILE *);
int     __CLIB _flushbu(int, FILE *);
/*#define _filbuf _fillbuf*/
/*#define _flsbuf _flushbu*/

int __CLIB getw(FILE *FHdl);
#define _getw  getw
int __CLIB putw(int Word, FILE *FilePtr);
#define _putw putw

#if __cplusplus
inline int __CLIB getchar()		{ return getc(stdin);		}
inline int __CLIB putchar(int c)	{ return putc(c,stdout);	}
inline int __CLIB getc(FILE *fp)	{ return fgetc(fp);		}
inline int __CLIB putc(int c,FILE *fp)	{ return fputc(c,fp);		}
inline int __CLIB ferror(FILE *fp)	{ return fp->_flag&_IOERR;	}
inline int __CLIB feof(FILE *fp)	{ return fp->_flag&_IOEOF;	}
inline void __CLIB clearerr(FILE *fp)	{ fp->_flag &= ~(_IOERR|_IOEOF); }
inline void __CLIB rewind(FILE *fp)	{ fseek(fp,0L,SEEK_SET); fp->_flag&=~_IOERR; }
#else
#define getchar()	getc(stdin)
#define putchar(c)      putc(c,stdout)

#if !defined(_WINDOWS)
int __cdecl putch(int);
#define _putch          putch
#endif

#define getc(fp)	fgetc(fp)
#define putc(c,fp)	fputc((c),(fp))
#define ferror(fp)	((fp)->_flag&_IOERR)
#define feof(fp)	((fp)->_flag&_IOEOF)
#define clearerr(fp)	((void)((fp)->_flag&=~(_IOERR|_IOEOF)))
#define rewind(fp)	((void)(fseek(fp,0L,SEEK_SET),((fp)->_flag&=~_IOERR)))
#endif

#ifndef __STDC__
#define fileno(fp)	((fp)->_file)
#define _fileno(fp)     ((fp)->_file)

#if M_UNIX || M_XENIX
int	__cdecl pclose(FILE *fp);
FILE *	__cdecl popen(const char *command,const char *t);
#endif

int     __CLIB unlink(const char *);
#define _unlink unlink

FILE *	__CLIB fdopen(int, const char *);
int   __CLIB fgetchar(void);
int   __CLIB fputchar(int);
int	__CLIB fcloseall(void);
long	__CLIB filesize(const char *);
int	__CLIB flushall(void);
int	__CLIB getch(void);
int	__CLIB getche(void);
int     __CLIB kbhit(void);
char *  __CLIB tempnam (char *dir, char *pfx);
int     __CLIB _snprintf(char *,size_t,const char *,...);
int	__CLIB _vsnprintf(char *,size_t,const char *,va_list);
#define _flushall flushall
#define _fcloseall fcloseall
#define _fdopen fdopen
#define _tempnam tempnam
#define _getche getche
#define _getch getch
#endif

#ifdef __NT__
#ifndef __STDC__
wchar_t * __CLIB _wtmpnam(wchar_t *);
FILE * __CLIB _wfopen(const wchar_t *, const wchar_t *);
FILE * __CLIB _wfsopen(const wchar_t *, const wchar_t *, int);
FILE * __CLIB _wfreopen(const wchar_t *, const wchar_t *, FILE *);
wchar_t * __CLIB fgetws(wchar_t *, int, FILE *);
int __CLIB fputws(const wchar_t *, FILE *);
wchar_t * __CLIB _getws(wchar_t *);
int __CLIB _putws(const wchar_t *);
int __CLIB wprintf(const wchar_t * __RESTRICT format, ...);
int __CLIB fwprintf(FILE * __RESTRICT stream, const wchar_t * __RESTRICT format, ...);
int __CLIB vwprintf(const wchar_t * __RESTRICT format, va_list arg);
int __CLIB vfwprintf(FILE * __RESTRICT stream, const wchar_t * __RESTRICT format, va_list arg);
int __CLIB swprintf(wchar_t * __RESTRICT s, size_t n, const wchar_t * __RESTRICT format, ...);
int __CLIB _swprintf(wchar_t * __RESTRICT s, const wchar_t * __RESTRICT format, ...);
int __CLIB _snwprintf(wchar_t *, size_t, const wchar_t *, ...);
int __CLIB vswprintf(wchar_t * __RESTRICT s, size_t n, const wchar_t * __RESTRICT format, va_list arg);
int __CLIB _vswprintf(wchar_t * __RESTRICT s, const wchar_t * __RESTRICT format, va_list arg);
int __CLIB _vsnwprintf(wchar_t *, size_t, const wchar_t *, va_list);
int __CLIB wscanf(const wchar_t * __RESTRICT format, ...);
int __CLIB fwscanf(FILE * __RESTRICT stream, const wchar_t * __RESTRICT format, ...);
int __CLIB swscanf(const wchar_t * __RESTRICT s, const wchar_t * __RESTRICT format, ...);
int __CLIB _wremove(const wchar_t *);
void __CLIB _wperror(const wchar_t *);
FILE * __CLIB _wfdopen(int, const wchar_t *);
wchar_t * __CLIB _wtempnam(wchar_t *, wchar_t *);
#if M_UNIX || M_XENIX
FILE * __CLIB _wpopen(const wchar_t *, const wchar_t *);
#endif
wint_t __CLIB fgetwc(FILE *);
wint_t __CLIB _fgetwchar(void);
wint_t __CLIB fputwc(wint_t, FILE *);
wint_t __CLIB _fputwchar(wint_t);
wint_t __CLIB getwc(FILE *);
wint_t __CLIB getwchar(void);
wint_t __CLIB putwc(wint_t, FILE *);
wint_t __CLIB putwchar(wint_t);
wint_t __CLIB ungetwc(wint_t, FILE *);
#define getwchar()	fgetwc(stdin)
#define putwchar(_c)	fputwc((_c),stdout)
#define getwc(_stm)	fgetwc(_stm)
#define putwc(_c,_stm)	fputwc(_c,_stm)
#endif
#endif

#if __cplusplus
}
#endif

#endif
