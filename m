From: Milosz Tanski <milosz@adfin.com>
Subject: [PATCH v2 1/2] Add preadv2/pwritev2 documentation.
Date: Thu,  6 Nov 2014 10:44:26 -0500
Message-ID: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
References: <cover.1415220890.git.milosz@adfin.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cover.1415220890.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

New syscalls that are a variation on the preadv/pwritev but support an extra
flag argument.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
Suggested-by: Jeff Moyer <jmoyer@redhat.com>
Fixes: Jeff Moyer <jmoyer@redhat.com>
---
 man2/readv.2 | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/man2/readv.2 b/man2/readv.2
index 8748efa..31b3870 100644
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
@@ -162,9 +168,9 @@ The
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
@@ -174,15 +180,41 @@ The file offset is not changed by these system calls.
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
+.BR RWF_NONBLOCK " (only " preadv2() " since Linux 3.19)"
+Performs a non-blocking operation for regular files (not sockets) opened in buffered mode (not
+.BR O_DIRECT ")."
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
 On error, \-1 is returned, and \fIerrno\fP is set appropriately.
 .SH ERRORS
@@ -191,12 +223,22 @@ The errors are as given for
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
-Additionally, the following error is defined:
+Additionally, the following errors are defined:
+.TP
+.B EAGAIN
+The operation would block. This is possible if the file descriptor \fIfd\fP refers to a socket and has been marked nonblocking
+.RB ( O_NONBLOCK ),
+or the operation is a
+.BR preadv2
+and the \fIflags\fP argument is set to
+.BR RWF_NONBLOCK.
 .TP
 .B EINVAL
 The sum of the
@@ -205,12 +247,17 @@ values overflows an
 .I ssize_t
 value.
 Or, the vector count \fIiovcnt\fP is less than zero or greater than the
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
+first appeared in Linux 3.19 (if we're lucky);
 .SH CONFORMING TO
 .BR readv (),
 .BR writev ():
@@ -223,6 +270,10 @@ first appeared in Linux 2.6.30; library support was added in glibc 2.10.
 .BR preadv (),
 .BR pwritev ():
 nonstandard, but present also on the modern BSDs.
+.sp
+.BR preadv2 (),
+.BR pwritev2 ():
+nonstandard, Linux extension.
 .SH NOTES
 .SS C library/kernel ABI differences
 POSIX.1-2001 allows an implementation to place a limit on
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
