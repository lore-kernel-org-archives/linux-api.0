From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] man2: document FICLONE and FICLONERANGE
Date: Sat, 19 Dec 2015 00:56:13 -0800
Message-ID: <20151219085613.12660.75735.stgit@birch.djwong.org>
References: <20151219085607.12660.75196.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151219085607.12660.75196.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: mtk.manpages@gmail.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Document the FICLONE and FICLONERANGE ioctls, formerly known as the
BTRFS_IOC_CLONE and BTRFS_IOC_CLONE_RANGE ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_ficlone.2      |   89 +++++++++++++++++++++++++++++++++++
 man2/ioctl_ficlonerange.2 |  116 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)
 create mode 100644 man2/ioctl_ficlone.2
 create mode 100644 man2/ioctl_ficlonerange.2


diff --git a/man2/ioctl_ficlone.2 b/man2/ioctl_ficlone.2
new file mode 100644
index 0000000..ba851da
--- /dev/null
+++ b/man2/ioctl_ficlone.2
@@ -0,0 +1,89 @@
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
+.TH IOCTL-FICLONE 2 2015-12-15 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_ficlone \- share all the data of one file with another file
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.sp
+.BI "int ioctl(int " dest_fd ", FICLONE, int " src_fd );
+.SH DESCRIPTION
+If a filesystem supports files sharing physical storage between multiple
+files ("reflink"), this
+.BR ioctl (2)
+system call can be used to make all the data in the
+.B src_fd
+file appear in the
+.B dest_fd
+file by sharing the underlying storage, which is faster than making a separate
+physical copy of the data.  If a file write should occur to a shared region,
+the filesystem must ensure that the changes remain private to the file being
+written.  This behavior is commonly referred to as "copy on write".
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
+The filesystem does not support reflinking the ranges of the given files.  This
+error can also appear if either file descriptor represents a device, fifo, or
+socket.
+.TP
+.B EBADF
+.IR src_fd
+is not open for reading;
+.IR dest_fd
+is not open for writing or is open for append-only writes; or the filesystem
+which
+.IR src_fd
+resides on does not support reflink.
+.TP
+.B EPERM
+.IR dest_fd
+is immutable.
+.TP
+.B ETXTBSY
+One of the files is a swap file.  Swap files cannot share storage.
+.TP
+.B EOPNOTSUPP
+This can appear if the filesystem does not support reflinking either file
+descriptor.
+.SH NOTES
+Because a copy on write operation requires the allocation of new storage, the
+.B fallocate (2)
+operation may un-share shared blocks to guarantee that subsequent writes will
+not fail because of lack of disk space.
+.SH CONFORMING TO
+This API is Linux-specific.  This ioctl was previously known as
+.B BTRFS_IOC_CLONE
+and was private to btrfs.
+.fi
+.in
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
new file mode 100644
index 0000000..80263c5
--- /dev/null
+++ b/man2/ioctl_ficlonerange.2
@@ -0,0 +1,116 @@
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
+.TH IOCTL-FICLONERANGE 2 2015-12-15 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_ficlonerange \- share some the data of one file with another file
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.sp
+.BI "int ioctl(int " dest_fd ", FICLONERANGE, struct file_clone_range * " arg );
+.SH DESCRIPTION
+If a filesystem supports files sharing physical storage between multiple
+files ("reflink"), this
+.BR ioctl (2)
+system call can be used to make some of the data in the
+.B src_fd
+file appear in the
+.B dest_fd
+file by sharing the underlying storage, which is faster than making a separate
+physical copy of the data.  If a file write should occur to a shared region,
+the filesystem must ensure that the changes remain private to the file being
+written.  This behavior is commonly referred to as "copy on write".
+
+This ioctl reflinks up to
+.IR src_length
+bytes from file descriptor
+.IR src_fd
+at offset
+.IR src_offset
+into the file
+.IR dest_fd
+at offset
+.IR dest_offset ",
+provided that both are files.  This information is conveyed in a structure of
+the following form:
+.in +4n
+.nf
+
+struct file_clone_range {
+        __s64 src_fd;
+        __u64 src_offset;
+        __u64 src_length;
+        __u64 dest_offset;
+};
+
+.fi
+.in
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
+The filesystem does not support reflinking the ranges of the given files.  This
+error can also appear if either file descriptor represents a device, fifo, or
+socket.  Disk filesystems generally require the offset and length arguments
+to be aligned to the fundamental block size.  Not all filesystems support
+overlapping reflink ranges in the same file.
+.TP
+.B EBADF
+.IR src_fd
+is not open for reading;
+.IR dest_fd
+is not open for writing or is open for append-only writes; or the filesystem
+which
+.IR src_fd
+resides on does not support reflink.
+.TP
+.B EPERM
+.IR dest_fd
+is immutable.
+.TP
+.B ETXTBSY
+One of the files is a swap file.  Swap files cannot share storage.
+.TP
+.B EOPNOTSUPP
+This can appear if the filesystem does not support reflinking either file
+descriptor.
+.SH NOTES
+Because a copy on write operation requires the allocation of new storage, the
+.B fallocate (2)
+operation may un-share shared blocks to guarantee that subsequent writes will
+not fail because of lack of disk space.
+.SH CONFORMING TO
+This API is Linux-specific.  This ioctl was previously known as
+.B BTRFS_IOC_CLONE_RANGE
+and was private to btrfs.
+.fi
+.in
+.SH SEE ALSO
+.BR ioctl (2)

