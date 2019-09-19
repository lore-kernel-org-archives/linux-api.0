From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] readv.2: Document new RWF_ENCODED flag to pwritev2()
Date: Wed, 18 Sep 2019 23:53:45 -0700
Message-ID: <5026db117fb57fa480706a7a77460e4288e69180.1568875837.git.osandov@fb.com>
References: <cover.1568875700.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1568875700.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 man2/readv.2 | 156 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/man2/readv.2 b/man2/readv.2
index af27aa63e..7d32b3bd2 100644
--- a/man2/readv.2
+++ b/man2/readv.2
@@ -265,6 +265,135 @@ the data is always appended to the end of the file.
 However, if the
 .I offset
 argument is \-1, the current file offset is updated.
+.TP
+.BR RWF_ENCODED " (since Linux 5.5)"
+Read or write encoded (e.g., compressed) data.
+.I iov[0].iov_base
+points to an
+.I
+encoded_iov
+structure, defined in
+.I <linux/fs.h>
+as:
+.IP
+.in +4n
+.EX
+struct encoded_iov {
+    __u64 unencoded_len;
+    __u32 compression;
+    __u32 encryption;
+};
+.EE
+.in
+.IP
+.I iov[0].iov_len
+must be set to
+.IR "sizeof(struct\ encoded_iov)" .
+.IP
+.I compression
+is one of
+.B ENCODED_IOV_COMPRESSION_NONE
+(zero),
+.BR ENCODED_IOV_COMPRESSION_ZLIB ,
+.BR ENCODED_IOV_COMPRESSION_LZO ,
+or
+.BR ENCODED_IOV_COMPRESSION_ZSTD .
+.I encryption
+is currently always
+.B ENCODED_IOV_ENCRYPTION_NONE
+(zero).
+.I unencoded_len
+is the length of the unencoded (i.e., decrypted and decompressed) data.
+If
+.I offset
+is -1, then the current file offset is incremented by the unencoded length.
+.IP
+For
+.BR pwritev2 (),
+the remaining buffers in the
+.I iov
+array should point to the encoded data;
+.I unencoded_len
+should be set to the logical length of the data in the file; and
+.I compression
+and
+.I encryption
+should be set to indicate the encoding.
+The calling process must have the
+.B CAP_SYS_ADMIN
+capability.
+If
+.I compression
+is
+.B ENCODED_IOV_COMPRESSION_NONE
+and
+.I encryption
+is
+.BR ENCODED_IOV_ENCRYPTION_NONE ,
+then
+.I unencoded_len
+is ignored and the write behaves as if the
+.B RWF_ENCODED
+flag was not specified.
+.IP
+As of Linux 5.5, this flag is only implemented for
+.BR pwritev2 (),
+and only on Btrfs with the following requirements:
+.RS
+.IP \(bu 3
+.I offset
+(or the current file offset if
+.I offset
+is -1) must be aligned to the sector size of the filesystem.
+.IP \(bu
+.I unencoded_len
+and the length of the encoded data must each be no more than 128 KiB.
+This limit may increase in the future.
+.IP \(bu
+.I unencoded_len
+must be non-zero.
+.IP \(bu
+.I unencoded_len
+must be aligned to the sector size of the filesystem,
+unless the data ends at or beyond the current end of the file.
+.IP \(bu
+If
+.I compression
+is not
+.BR ENCODED_IOV_COMPRESSION_NONE ,
+then the length of the encoded data rounded up to the nearest sector must be less than
+.IR unencoded_len .
+.IP \(bu
+If
+.I compression
+is
+.BR ENCODED_IOV_COMPRESSION_ZLIB ,
+then the encoded data must be a single zlib stream.
+.IP \(bu
+If
+.I compression
+is
+.BR ENCODED_IOV_COMPRESSION_LZO ,
+then the encoded data must be be compressed page by page with LZO1X
+and wrapped in the format described in the Linux kernel source file
+.IR fs/btrfs/lzo.c .
+.IP \(bu
+If
+.I compression
+is
+.BR ENCODED_IOV_COMPRESSION_ZSTD ,
+then the encoded data must be a single zstd stream,
+and the
+.I windowLog
+compression parameter must be no more than 17.
+.RE
+.IP
+Note that the encoded data is not validated when it is written.
+If it is not valid (e.g., it cannot be decompressed,
+or its decompressed length does not match
+.IR unencoded_len ),
+then a subsequent read may result in an error or return truncated data.
+.\" TODO: how should this interact with O_DIRECT?
 .SH RETURN VALUE
 On success,
 .BR readv (),
@@ -284,6 +413,13 @@ than requested (see
 and
 .BR write (2)).
 .PP
+If
+.B
+RWF_ENCODED
+was specified in
+.IR flags ,
+then the return value is the unencoded number of bytes.
+.PP
 On error, \-1 is returned, and \fIerrno\fP is set appropriately.
 .SH ERRORS
 The errors are as given for
@@ -312,8 +448,28 @@ The vector count,
 .IR iovcnt ,
 is less than zero or greater than the permitted maximum.
 .TP
+.B EINVAL
+.B RWF_ENCODED
+is specified in
+.I flags
+and the alignment and/or size requirements are not met.
+.TP
 .B EOPNOTSUPP
 An unknown flag is specified in \fIflags\fP.
+.TP
+.B EOPNOTSUPP
+.B RWF_ENCODED
+is specified in
+.I flags
+and the filesystem does not implement encoded I/O.
+.TP
+.B EPERM
+.B RWF_ENCODED
+is specified in
+.I flags
+and the calling process does not have the
+.B CAP_SYS_ADMIN
+capability.
 .SH VERSIONS
 .BR preadv ()
 and
-- 
2.23.0
