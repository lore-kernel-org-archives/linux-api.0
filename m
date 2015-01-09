From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Fri, 09 Jan 2015 16:47:31 +0100
Message-ID: <54AFF813.7050604@gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com> <1416830039-21952-6-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416830039-21952-6-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: mtk.manpages@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/24/2014 12:53 PM, David Drysdale wrote:
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>  create mode 100644 man2/execveat.2

David,

Thanks for the very nicely prepared man page. I've done 
a few very light edits, and will release the version below 
with the next man-pages release.

I have one question. In the message accompanying
commit 51f39a1f0cea1cacf8c787f652f26dfee9611874 you wrote:

  The filename fed to the executed program as argv[0] (or the name of the
  script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
  (for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
  reflecting how the executable was found.  This does however mean that
  execution of a script in a /proc-less environment won't work; also, script
  execution via an O_CLOEXEC file descriptor fails (as the file will not be
  accessible after exec).

How does one produce this situation where the execed program sees 
argv[0] as a /dev/fd path? (i.e., what would the execveat()
call look like?) I tried to produce this scenario, but could not.

Cheers,

Michael

.\" Copyright (c) 2014 Google, Inc.
.\"
.\" %%%LICENSE_START(VERBATIM)
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\" %%%LICENSE_END
.\"
.TH EXECVEAT 2 2015-01-09 "Linux" "Linux Programmer's Manual"
.SH NAME
execveat \- execute program relative to a directory file descriptor
.SH SYNOPSIS
.B #include <unistd.h>
.sp
.BI "int execveat(int " dirfd ", const char *" pathname ","
.br
.BI "             char *const " argv "[], char *const " envp "[],"
.br
.BI "             int " flags );
.SH DESCRIPTION
.\" commit 51f39a1f0cea1cacf8c787f652f26dfee9611874
The
.BR execveat ()
system call executes the program referred to by the combination of
.I dirfd
and
.IR pathname .
It operates in exactly the same way as
.BR execve (2),
except for the differences described in this manual page.

If the pathname given in
.I pathname
is relative, then it is interpreted relative to the directory
referred to by the file descriptor
.I dirfd
(rather than relative to the current working directory of
the calling process, as is done by
.BR execve (2)
for a relative pathname).

If
.I pathname
is relative and
.I dirfd
is the special value
.BR AT_FDCWD ,
then
.I pathname
is interpreted relative to the current working
directory of the calling process (like
.BR execve (2)).

If
.I pathname
is absolute, then
.I dirfd
is ignored.

If
.I pathname
is an empty string and the
.BR AT_EMPTY_PATH
flag is specified, then the file descriptor
.I dirfd
specifies the file to be executed (i.e.,
.IR dirfd
refers to an executable file, rather than a directory).

The
.I flags
argument is a bit mask that can include zero or more of the following flags:
.TP
.BR AT_EMPTY_PATH
If
.I pathname
is an empty string, operate on the file referred to by
.IR dirfd
(which may have been obtained using the
.BR open (2)
.B O_PATH
flag).
.TP
.B AT_SYMLINK_NOFOLLOW
If the file identified by
.I dirfd
and a non-NULL
.I pathname
is a symbolic link, then the call fails with the error
.BR EINVAL .
.SH "RETURN VALUE"
On success,
.BR execveat ()
does not return. On error \-1 is returned, and
.I errno
is set appropriately.
.SH ERRORS
The same errors that occur for
.BR execve (2)
can also occur for
.BR execveat ().
The following additional errors can occur for
.BR execveat ():
.TP
.B EBADF
.I dirfd
is not a valid file descriptor.
.TP
.B EINVAL
.I flags
includes
.BR AT_SYMLINK_NOFOLLOW
and the file identified by
.I dirfd
and a non-NULL
.I pathname
is a symbolic link.
.TP
.B EINVAL
Invalid flag specified in
.IR flags .
.TP
.B ENOENT
The program identified by
.I dirfd
and
.I pathname
requires the use of an interpreter program
(such as a script starting with "#!"), but the file descriptor
.I dirfd
was opened with the
.B O_CLOEXEC
flag, with the result that
the program file is inaccessible to the launched interpreter.
.TP
.B ENOTDIR
.I pathname
is relative and
.I dirfd
is a file descriptor referring to a file other than a directory.
.SH VERSIONS
.BR execveat ()
was added to Linux in kernel 3.19.
GNU C library support is pending.
.\" FIXME . check for glibc support in a future release
.SH CONFORMING TO
The
.BR execveat ()
system call is Linux-specific.
.SH NOTES
In addition to the reasons explained in
.BR openat (2),
the
.BR execveat ()
system call is also needed to allow
.BR fexecve (3)
to be implemented on systems that do not have the
.I /proc
filesystem mounted.
.SH SEE ALSO
.BR execve (2),
.BR openat (2),
.BR fexecve (3)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
