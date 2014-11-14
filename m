From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv8 man-pages 4/4] execveat.2: initial man page for execveat(2)
Date: Fri, 14 Nov 2014 16:23:03 +0000
Message-ID: <1415982183-20525-5-git-send-email-drysdale@google.com>
References: <1415982183-20525-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415982183-20525-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)
 create mode 100644 man2/execveat.2

diff --git a/man2/execveat.2 b/man2/execveat.2
new file mode 100644
index 000000000000..937d79e4c4f0
--- /dev/null
+++ b/man2/execveat.2
@@ -0,0 +1,153 @@
+.\" Copyright (c) 2014 Google, Inc.
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of this
+.\" manual under the conditions for verbatim copying, provided that the
+.\" entire resulting derived work is distributed under the terms of a
+.\" permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume no
+.\" responsibility for errors or omissions, or for damages resulting from
+.\" the use of the information contained herein.  The author(s) may not
+.\" have taken the same level of care in the production of this manual,
+.\" which is licensed free of charge, as they might when working
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.\"
+.TH EXECVEAT 2 2014-04-02 "Linux" "Linux Programmer's Manual"
+.SH NAME
+execveat \- execute program relative to a directory file descriptor
+.SH SYNOPSIS
+.B #include <unistd.h>
+.sp
+.BI "int execveat(int " fd ", const char *" pathname ","
+.br
+.BI "             char *const " argv "[],  char *const " envp "[],"
+.br
+.BI "             int " flags);
+.SH DESCRIPTION
+The
+.BR execveat ()
+system call executes the program pointed to by the combination of \fIfd\fP and \fIpathname\fP.
+The
+.BR execveat ()
+system call operates in exactly the same way as
+.BR execve (2),
+except for the differences described in this manual page.
+
+If the pathname given in
+.I pathname
+is relative, then it is interpreted relative to the directory
+referred to by the file descriptor
+.I fd
+(rather than relative to the current working directory of
+the calling process, as is done by
+.BR execve (2)
+for a relative pathname).
+
+If
+.I pathname
+is relative and
+.I fd
+is the special value
+.BR AT_FDCWD ,
+then
+.I pathname
+is interpreted relative to the current working
+directory of the calling process (like
+.BR execve (2)).
+
+If
+.I pathname
+is absolute, then
+.I fd
+is ignored.
+
+If
+.I pathname
+is an empty string and the
+.BR AT_EMPTY_PATH
+flag is specified, then the file descriptor
+.I fd
+specifies the file to be executed.
+
+.I flags
+can either be 0, or include the following flags:
+.TP
+.BR AT_EMPTY_PATH
+If
+.I pathname
+is an empty string, operate on the file referred to by
+.IR fd
+(which may have been obtained using the
+.BR open (2)
+.B O_PATH
+flag).
+.TP
+.B AT_SYMLINK_NOFOLLOW
+If the file identified by
+.I fd
+and a non-NULL
+.I pathname
+is a symbolic link, then the call fails with the error
+.BR EINVAL .
+.SH "RETURN VALUE"
+On success,
+.BR execveat ()
+does not return. On error \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+The same errors that occur for
+.BR execve (2)
+can also occur for
+.BR execveat ().
+The following additional errors can occur for
+.BR execveat ():
+.TP
+.B EBADF
+.I fd
+is not a valid file descriptor.
+.TP
+.B ENOENT
+The program identified by \fIfd\fP and \fIpathname\fP requires the
+use of an interpreter program (such as a script starting with
+"#!") but the file descriptor
+.I fd
+was opened with the
+.B O_CLOEXEC
+flag and so the program file is inaccessible to the launched interpreter.
+.TP
+.B EINVAL
+Invalid flag specified in
+.IR flags .
+.TP
+.B ENOTDIR
+.I pathname
+is relative and
+.I fd
+is a file descriptor referring to a file other than a directory.
+.SH VERSIONS
+.BR execveat ()
+was added to Linux in kernel 3.???.
+.SH NOTES
+In addition to the reasons explained in
+.BR openat (2),
+the
+.BR execveat ()
+system call is also needed to allow
+.BR fexecve (3)
+to be implemented on systems that do not have the
+.I /proc
+filesystem mounted.
+.SH SEE ALSO
+.BR execve (2),
+.BR fexecve (3)
--
2.1.0.rc2.206.gedb03e5
