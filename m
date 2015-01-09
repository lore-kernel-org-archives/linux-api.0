From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
Date: Fri, 9 Jan 2015 18:02:58 +0000
Message-ID: <CAHse=S9kRj00eRbB+7DQd39Cso1O2LcmZpBVCbuUa9EwRQKv_w@mail.gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com> <54AFF813.7050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <54AFF813.7050604@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 9, 2015 at 3:47 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 11/24/2014 12:53 PM, David Drysdale wrote:
>> Signed-off-by: David Drysdale <drysdale@google.com>
>> ---
>>  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 153 insertions(+)
>>  create mode 100644 man2/execveat.2
>
> David,
>
> Thanks for the very nicely prepared man page. I've done
> a few very light edits, and will release the version below
> with the next man-pages release.

Many thanks, one error (of mine) in 2 places pointed out below.


> .TH EXECVEAT 2 2015-01-09 "Linux" "Linux Programmer's Manual"
> .SH NAME
> execveat \- execute program relative to a directory file descriptor
> .SH SYNOPSIS
> .B #include <unistd.h>
> .sp
> .BI "int execveat(int " dirfd ", const char *" pathname ","
> .br
> .BI "             char *const " argv "[], char *const " envp "[],"
> .br
> .BI "             int " flags );
> .SH DESCRIPTION
> .\" commit 51f39a1f0cea1cacf8c787f652f26dfee9611874
> The
> .BR execveat ()
> system call executes the program referred to by the combination of
> .I dirfd
> and
> .IR pathname .
> It operates in exactly the same way as
> .BR execve (2),
> except for the differences described in this manual page.
>
> If the pathname given in
> .I pathname
> is relative, then it is interpreted relative to the directory
> referred to by the file descriptor
> .I dirfd
> (rather than relative to the current working directory of
> the calling process, as is done by
> .BR execve (2)
> for a relative pathname).
>
> If
> .I pathname
> is relative and
> .I dirfd
> is the special value
> .BR AT_FDCWD ,
> then
> .I pathname
> is interpreted relative to the current working
> directory of the calling process (like
> .BR execve (2)).
>
> If
> .I pathname
> is absolute, then
> .I dirfd
> is ignored.
>
> If
> .I pathname
> is an empty string and the
> .BR AT_EMPTY_PATH
> flag is specified, then the file descriptor
> .I dirfd
> specifies the file to be executed (i.e.,
> .IR dirfd
> refers to an executable file, rather than a directory).
>
> The
> .I flags
> argument is a bit mask that can include zero or more of the following flags:
> .TP
> .BR AT_EMPTY_PATH
> If
> .I pathname
> is an empty string, operate on the file referred to by
> .IR dirfd
> (which may have been obtained using the
> .BR open (2)
> .B O_PATH
> flag).
> .TP
> .B AT_SYMLINK_NOFOLLOW
> If the file identified by
> .I dirfd
> and a non-NULL
> .I pathname
> is a symbolic link, then the call fails with the error
> .BR EINVAL .

Apologies, I think this should be ELOOP.

> .SH "RETURN VALUE"
> On success,
> .BR execveat ()
> does not return. On error \-1 is returned, and
> .I errno
> is set appropriately.
> .SH ERRORS
> The same errors that occur for
> .BR execve (2)
> can also occur for
> .BR execveat ().
> The following additional errors can occur for
> .BR execveat ():
> .TP
> .B EBADF
> .I dirfd
> is not a valid file descriptor.
> .TP
> .B EINVAL

ELOOP here too.

> .I flags
> includes
> .BR AT_SYMLINK_NOFOLLOW
> and the file identified by
> .I dirfd
> and a non-NULL
> .I pathname
> is a symbolic link.
> .TP
> .B EINVAL
> Invalid flag specified in
> .IR flags .
> .TP
> .B ENOENT
> The program identified by
> .I dirfd
> and
> .I pathname
> requires the use of an interpreter program
> (such as a script starting with "#!"), but the file descriptor
> .I dirfd
> was opened with the
> .B O_CLOEXEC
> flag, with the result that
> the program file is inaccessible to the launched interpreter.
> .TP
> .B ENOTDIR
> .I pathname
> is relative and
> .I dirfd
> is a file descriptor referring to a file other than a directory.
> .SH VERSIONS
> .BR execveat ()
> was added to Linux in kernel 3.19.
> GNU C library support is pending.
> .\" FIXME . check for glibc support in a future release
> .SH CONFORMING TO
> The
> .BR execveat ()
> system call is Linux-specific.
> .SH NOTES
> In addition to the reasons explained in
> .BR openat (2),
> the
> .BR execveat ()
> system call is also needed to allow
> .BR fexecve (3)
> to be implemented on systems that do not have the
> .I /proc
> filesystem mounted.
> .SH SEE ALSO
> .BR execve (2),
> .BR openat (2),
> .BR fexecve (3)
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
