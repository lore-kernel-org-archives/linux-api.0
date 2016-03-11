From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/6] vfs: vfs: Define new syscalls preadv2,pwritev2
Date: Fri, 11 Mar 2016 10:53:57 +0100
Message-ID: <20160311095357.GA29350@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <1457017443-17662-3-git-send-email-hch@lst.de> <56E1B9A8.3070904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E1B9A8.3070904-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 07:15:04PM +0100, Michael Kerrisk (man-pages) wrote:
> Hi Christoph,
> 
> On 03/03/2016 04:03 PM, Christoph Hellwig wrote:
> > From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
> > 
> > New syscalls that take an flag argument.   No flags are added yet in this
> > patch.
> 
> Are there some man pages patches for these proposed system calls?

This is what I have:

---
>From d33a02d56f447a6cb223b3964e1dd894f2921d5c Mon Sep 17 00:00:00 2001
From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Date: Fri, 11 Mar 2016 10:52:31 +0100
Subject: add preadv2/pwritev2 documentation

New syscalls that are a variation on the preadv/pwritev but support an extra
flag argument.

Signed-off-by: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
[hch: added RWF_HIPRI documentation]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 man2/readv.2 | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/man2/readv.2 b/man2/readv.2
index 93f2b6f..5cba5e2 100644
--- a/man2/readv.2
+++ b/man2/readv.2
@@ -45,6 +45,12 @@ readv, writev, preadv, pwritev \- read or write data into multiple buffers
 .sp
 .BI "ssize_t pwritev(int " fd ", const struct iovec *" iov ", int " iovcnt ,
 .BI "                off_t " offset );
+.sp
+.BI "ssize_t preadv2(int " fd ", const struct iovec *" iov ", int " iovcnt ,
+.BI "                off_t " offset ", int " flags );
+.sp
+.BI "ssize_t pwritev2(int " fd ", const struct iovec *" iov ", int " iovcnt ,
+.BI "                 off_t " offset ", int " flags );
 .fi
 .sp
 .in -4n
@@ -166,9 +172,9 @@ The
 system call combines the functionality of
 .BR writev ()
 and
-.BR pwrite (2).
+.BR pwrite (2) "."
 It performs the same task as
-.BR writev (),
+.BR writev () ","
 but adds a fourth argument,
 .IR offset ,
 which specifies the file offset at which the output operation
@@ -178,15 +184,43 @@ The file offset is not changed by these system calls.
 The file referred to by
 .I fd
 must be capable of seeking.
+.SS preadv2() and pwritev2()
+
+This pair of system calls has similar functionality to the
+.BR preadv ()
+and
+.BR pwritev ()
+calls, but adds a fifth argument, \fIflags\fP, which modifies the behavior on a per call basis.
+
+Like the
+.BR preadv ()
+and
+.BR pwritev ()
+calls, they accept an \fIoffset\fP argument. Unlike those calls, if the \fIoffset\fP argument is set to -1 then the current file offset is used and updated.
+
+The \fIflags\fP arguments to
+.BR preadv2 ()
+and
+.BR pwritev2 ()
+contains a bitwise OR of one or more of the following flags:
+.TP
+.BR RWF_HIPRI " (since Linux 4.6)"
+High priority read/write.  Allows block based filesystems to use polling of the
+device, which provides lower latency, but may use additional ressources.  (Currently
+only usable on a file descriptor opened using the
+.BR O_DIRECT " flag)."
+
 .SH RETURN VALUE
 On success,
-.BR readv ()
-and
+.BR readv () ","
 .BR preadv ()
-return the number of bytes read;
-.BR writev ()
 and
+.BR preadv2 ()
+return the number of bytes read;
+.BR writev () ","
 .BR pwritev ()
+and
+.BR pwritev2 ()
 return the number of bytes written.
 
 Note that is not an error for a successful call to transfer fewer bytes
@@ -202,9 +236,11 @@ The errors are as given for
 and
 .BR write (2).
 Furthermore,
-.BR preadv ()
-and
+.BR preadv () ","
+.BR preadv2 () ","
 .BR pwritev ()
+and
+.BR pwritev2 ()
 can also fail for the same reasons as
 .BR lseek (2).
 Additionally, the following error is defined:
@@ -218,12 +254,17 @@ value.
 .TP
 .B EINVAL
 The vector count \fIiovcnt\fP is less than zero or greater than the
-permitted maximum.
+permitted maximum. Or, an unknown flag is specified in \fIflags\fP.
 .SH VERSIONS
 .BR preadv ()
 and
 .BR pwritev ()
 first appeared in Linux 2.6.30; library support was added in glibc 2.10.
+.sp
+.BR preadv2 ()
+and
+.BR pwritev2 ()
+first appeared in Linux 4.6
 .SH CONFORMING TO
 .BR readv (),
 .BR writev ():
@@ -237,6 +278,10 @@ POSIX.1-2001, POSIX.1-2008,
 .BR preadv (),
 .BR pwritev ():
 nonstandard, but present also on the modern BSDs.
+.sp
+.BR preadv2 (),
+.BR pwritev2 ():
+nonstandard, Linux extension.
 .SH NOTES
 POSIX.1 allows an implementation to place a limit on
 the number of items that can be passed in
-- 
2.1.4
