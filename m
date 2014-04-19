From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Date: Sat, 19 Apr 2014 11:08:38 +0200
Message-ID: <53523D16.9020101@gmail.com>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu> <1389219015-10980-12-git-send-email-miklos@szeredi.hu> <20140113122517.GA10366@quack.suse.cz> <20140115182347.GB5715@fieldses.org> <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com> <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu> <52D90B93.5010209@gmail.com> <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140117144126.GG24171-nYI/l+Q8b4r16c5iV7KQqR1Qg9XOENNVk/YoNI2nt5o@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "mszeredi-AlSwsSmVLrQ@public.gmane.org" <mszeredi-AlSwsSmVLrQ@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Miklos,

> The code changes are pushed to the git tree and the updated man page is below.

Now that renameat2() is in 3.15, I've taken these changes. This had to be 
manually does, because I'd done some major reworking on the pages since you 
originally wrote your text. So, I may have injected some errors.

I did a little light reworking of the text and added VERSIONS and 
CONFORMING TO pieces. I also added a couple of FIXMEs, to note points 
that will need to be updated once glibc support is (presumably) added.
(Carlos, what's the usual process for triggering that sort of thing?)

Could you please review the diff below (now against rename(2)).

Cheers,

Michael

diff --git a/man2/rename.2 b/man2/rename.2
index 9f9eda4..73b00ff 100644
--- a/man2/rename.2
+++ b/man2/rename.2
@@ -30,9 +30,9 @@
 .\" Modified Thu Mar  3 09:49:35 2005 by Michael Haardt <michael-8s1n8bisGiQ@public.gmane.org>
 .\" 2007-03-25, mtk, added various text to DESCRIPTION.
 .\"
-.TH RENAME 2 2014-02-21 "Linux" "Linux Programmer's Manual"
+.TH RENAME 2 2014-04-19 "Linux" "Linux Programmer's Manual"
 .SH NAME
-rename, renameat \- change the name or location of a file
+rename, renameat, renameat2 \- change the name or location of a file
 .SH SYNOPSIS
 .nf
 .B #include <stdio.h>
@@ -44,6 +44,10 @@ rename, renameat \- change the name or location of a file
 .sp
 .BI "int renameat(int " olddirfd ", const char *" oldpath ,
 .BI "             int " newdirfd ", const char *" newpath );
+
+.BI "int renameat2(int " olddirfd ", const char *" oldpath ,
+.BI "              int " newdirfd ", const char *" newpath \
+", unsigned int " flags );
 .fi
 .sp
 .in -4n
@@ -61,6 +65,7 @@ _XOPEN_SOURCE\ >=\ 700 || _POSIX_C_SOURCE\ >=\ 200809L
 .TP
 Before glibc 2.10:
 _ATFILE_SOURCE
+.\" FIXME need to define FTMs for renameat2(), once it hits glibc
 .RE
 .ad
 .PD
@@ -163,6 +168,38 @@ See
 .BR openat (2)
 for an explanation of the need for
 .BR renameat ().
+.SS renameat2()
+.BR renameat2 ()
+has an additional
+.I flags
+argument.
+A
+.BR renameat2 ()
+call with a zero
+.I flags
+argument is equivalent to
+.BR renameat ().
+
+The
+.I flags
+argument is a bit mask consisting of zero or more of the following flags:
+.TP
+.B RENAME_NOREPLACE
+Don't overwrite
+.IR newpath .
+of the rename.
+Return an error if
+.IR newpath
+already exists.
+.TP
+.B RENAME_EXCHANGE
+Atomically exchange
+.IR oldpath
+and
+.IR newpath .
+Both pathnames must exist
+but may be of different types (e.g., one could be a non-empty directory
+and the other a symbolic link).
 .SH RETURN VALUE
 On success, zero is returned.
 On error, \-1 is returned, and
@@ -306,7 +343,9 @@ does not work across different mount points,
 even if the same filesystem is mounted on both.)
 .PP
 The following additional errors can occur for
-.BR renameat ():
+.BR renameat ()
+and
+.BR renameat2 ():
 .TP
 .B EBADF
 .I olddirfd
@@ -323,16 +362,55 @@ or similar for
 .I newpath
 and
 .I newdirfd
+.PP
+The following additional errors can occur for
+.BR renameat2 ():
+.TP
+.B EEXIST
+.I flags
+contains
+.B RENAME_NOREPLACE
+and
+.I newpath
+already exists.
+.TP 
+.B EINVAL
+An invalid flag was specified in
+.IR flags ,
+or both
+.B RENAME_NOREPLACE
+and
+.B RENAME_EXCHANGE
+were specified.
+.TP
+.B EINVAL
+The filesystem does not support one of the flags in
+.IR flags .
+.TP
+.B ENOENT
+.I flags
+contains
+.B RENAME_EXCHANGE
+and
+.IR newpath
+does not exist.
 .SH VERSIONS
 .BR renameat ()
 was added to Linux in kernel 2.6.16;
 library support was added to glibc in version 2.4.
+
+.BR renameat2 ()
+was added to Linux in kernel 3.15.
+.\" FIXME glibc support is pending.
 .SH CONFORMING TO
 .BR rename ():
 4.3BSD, C89, C99, POSIX.1-2001, POSIX.1-2008.
 
 .BR renameat ():
 POSIX.1-2008.
+
+.BR renameat2()
+is Linux-specific.
 .SH BUGS
 On NFS filesystems, you can not assume that if the operation
 failed, the file was not renamed.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
