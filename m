From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/2 V2] man2: New page documenting filesystem get/set label
 ioctls
Date: Thu, 10 May 2018 12:29:10 -0500
Message-ID: <7d74cc3b-52cc-be60-0a69-1a5ee1499f47@sandeen.net>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <708b8e2a-2bc2-df38-ec9c-c605203052b5@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <708b8e2a-2bc2-df38-ec9c-c605203052b5@sandeen.net>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

This documents the proposed new vfs-level ioctls which can
get or set a mounted filesytem's label.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: make primary file ioctl_getfslabel, link ioctl_setfslabel to it
    note that getfslabel requires CAP_SYS_ADMIN

diff --git a/man2/ioctl_getfslabel.2 b/man2/ioctl_getfslabel.2
new file mode 100644
index 0000000..2c3375c
--- /dev/null
+++ b/man2/ioctl_getfslabel.2
@@ -0,0 +1,87 @@
+.\" Copyright (c) 2018, Red Hat, Inc.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.TH IOCTL-FSLABEL 2 2018-05-02 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_fslabel \- get or set a filesystem label
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <linux/fs.h>
+.sp
+.BI "int ioctl(int " fd ", FS_IOC_GETFSLABEL, char " label [FSLABEL_MAX]);
+.br
+.BI "int ioctl(int " fd ", FS_IOC_SETFSLABEL, char " label [FSLABEL_MAX]);
+.SH DESCRIPTION
+If a filesystem supports online label manipulation, these
+.BR ioctl (2)
+operations can be used to get or set the filesystem label for the filesystem
+on which
+.B fd
+resides.
+The
+.B FS_IOC_SETFSLABEL
+operation requires privilege
+.RB ( CAP_SYS_ADMIN ).
+.SH RETURN VALUE
+On success zero is returned.  On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EINVAL
+The specified label exceeds the maximum label length for the filesystem.
+.TP
+.B ENOTTY
+This can appear if the filesystem does not support online label manipulation.
+.TP
+.B EPERM
+The calling process does not have sufficient permissions to set the label.
+.TP
+.B EFAULT
+.I label
+references an inaccessible memory area.
+.SH VERSIONS
+These ioctl operations first appeared in Linux 4.18.
+They were previously known as
+.B BTRFS_IOC_GET_FSLABEL
+and
+.B BTRFS_IOC_SET_FSLABEL
+and were private to Btrfs.
+.SH CONFORMING TO
+This API is Linux-specific.
+.SH NOTES
+The maximum string length for this interface is
+.BR FSLABEL_MAX ,
+including the terminating null byte (\(aq\\0\(aq).
+Filesystems have differing maximum label lengths, which may or
+may not include the terminating null.  The string provided to
+.B FS_IOC_SETFSLABEL
+must always be null-terminated, and the string returned by
+.B FS_IOC_GETFSLABEL
+will always be null-terminated.
+.SH SEE ALSO
+.BR ioctl (2),
+.BR blkid (8)
diff --git a/man2/ioctl_setfslabel.2 b/man2/ioctl_setfslabel.2
new file mode 100644
index 0000000..2119835
--- /dev/null
+++ b/man2/ioctl_setfslabel.2
@@ -0,0 +1 @@
+.so man2/ioctl_getfslabel.2

