From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] man2: document the FIDEDUPERANGE ioctl
Date: Sat, 19 Dec 2015 00:56:20 -0800
Message-ID: <20151219085620.12660.65947.stgit@birch.djwong.org>
References: <20151219085607.12660.75196.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151219085607.12660.75196.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Document the FIDEDUPERANGE ioctl, formerly known as BTRFS_IOC_EXTENT_SAME.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_fideduperange.2 |  164 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)
 create mode 100644 man2/ioctl_fideduperange.2


diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
new file mode 100644
index 0000000..a8a19d0
--- /dev/null
+++ b/man2/ioctl_fideduperange.2
@@ -0,0 +1,164 @@
+.\" Copyright (C) 2015 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" This program is free software; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation.
+.\"
+.\" This program is distributed in the hope that it would be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public License
+.\" along with this program; if not, write the Free Software Foundation,
+.\" Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+.\" %%%LICENSE_END
+.TH IOCTL-FIDEDUPERANGE 2 2015-12-15 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_fideduperange \- share some the data of one file with another file
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.sp
+.BI "int ioctl(int " src_fd ", FIDEDUPERANGE, struct file_dedupe_range * " arg );
+.SH DESCRIPTION
+If a filesystem supports files sharing physical storage between multiple
+files, this
+.BR ioctl (2)
+system call can be used to make some of the data in the
+.B src_fd
+file appear in the
+.B dest_fd
+file by sharing the underlying storage if the file data is identical
+("deduplication").  This reduces storage consumption by allowing the filesystem
+to store one shared copy of the data.  If a file write should occur to a shared
+region, the filesystem must ensure that the changes remain private to the file
+being written.  This behavior is commonly referred to as "copy on write".
+
+This ioctl performs the "compare and share if identical" operation on up to
+.IR src_length
+bytes from file descriptor
+.IR src_fd
+at offset
+.IR src_offset ".
+This information is conveyed in a structure of the following form:
+.in +4n
+.nf
+
+struct file_dedupe_range {
+        __u64 src_offset;
+        __u64 src_length;
+        __u16 dest_count;
+        __u16 reserved1;
+        __u32 reserved2;
+        struct file_dedupe_range_info info[0];
+};
+.fi
+.in
+
+The fields 
+.IR reserved1 " and " reserved2
+must be zero.
+
+Destinations for the deduplication operation are conveyed in the array at the
+end of the structure.  The number of destinations is given in
+.IR dest_count ",
+and the destination information is conveyed in the following form:
+
+.in +4n
+.nf
+struct file_dedupe_range_info {
+        __s64 dest_fd;
+        __u64 dest_offset;
+        __u64 bytes_deduped;
+        __s32 status;
+        __u32 reserved;
+};
+
+.fi
+.in
+
+Each deduplication operation targets
+.IR length
+bytes in file descriptor
+.IR dest_fd
+at offset
+.IR logical_offset ".
+The field
+.IR reserved
+must be zero.
+
+Upon successful completion of this ioctl, the number of bytes successfully
+deduplicated is returned in
+.IR bytes_deduped
+and a status code for the deduplication operation is returned in
+.IR status ".
+
+The
+.IR status
+code is set to
+.B 0
+for success, a negative error code in case of error, or
+.B FILE_DEDUPE_RANGE_DIFFERS
+if the data did not match.
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EXDEV
+.IR dest_fd " and " src_fd
+are not on the same mounted filesystem.
+.TP
+.B EISDIR
+One of the files is a directory and the filesystem does not support shared
+regions in directories.
+.TP
+.B EINVAL
+The filesystem does not support deduplicating the ranges of the given files.
+This error can also appear if either file descriptor represents a device, fifo,
+or socket.  Disk filesystems generally require the offset and length arguments
+to be aligned to the fundamental block size.  Not all filesystems support
+overlapping deduplication ranges in the same file.
+.TP
+.B EBADF
+.IR src_fd
+is not open for reading;
+.IR dest_fd
+is not open for writing or is open for append-only writes; or the filesystem
+which
+.IR src_fd
+resides on does not support deduplication.
+.TP
+.B EPERM
+.IR dest_fd
+is immutable.
+.TP
+.B ETXTBSY
+One of the files is a swap file.  Swap files cannot share storage.
+.TP
+.B EOPNOTSUPP
+This can appear if the filesystem does not support deduplicating either file
+descriptor.
+.SH NOTES
+Because a copy on write operation requires the allocation of new storage, the
+.B fallocate (2)
+operation may un-share shared blocks to guarantee that subsequent writes will
+not fail because of lack of disk space.
+
+Some filesystems may limit the amount of data that can be deduplicated in a
+single call.
+
+.SH CONFORMING TO
+This API is Linux-specific.  This ioctl was previously known as
+.B BTRFS_IOC_FILE_EXTENT_SAME
+and was private to btrfs.
+.fi
+.in
+.SH SEE ALSO
+.BR ioctl (2)

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
