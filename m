From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] man2: New page documenting filesystem get/set label
 ioctls
Date: Wed, 9 May 2018 09:15:14 -0700
Message-ID: <20180509161514.GG4116@magnolia>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <708b8e2a-2bc2-df38-ec9c-c605203052b5@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <708b8e2a-2bc2-df38-ec9c-c605203052b5@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2018 at 11:04:03AM -0500, Eric Sandeen wrote:
> This documents the proposed new vfs-level ioctls which can
> get or set a mounted filesytem's label.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> btrfs folks, please verify that this accurately describes your
> current behavior, thanks.
> 
> diff --git a/man2/ioctl_fslabel.2 b/man2/ioctl_fslabel.2
> new file mode 100644
> index 0000000..150aa53
> --- /dev/null
> +++ b/man2/ioctl_fslabel.2
> @@ -0,0 +1,83 @@
> +.\" Copyright (c) 2018, Red Hat, Inc.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" This is free documentation; you can redistribute it and/or
> +.\" modify it under the terms of the GNU General Public License as
> +.\" published by the Free Software Foundation; either version 2 of
> +.\" the License, or (at your option) any later version.
> +.\"
> +.\" The GNU General Public License's references to "object code"
> +.\" and "executables" are to be interpreted as the output of any
> +.\" document formatting or typesetting system, including
> +.\" intermediate and printed output.
> +.\"
> +.\" This manual is distributed in the hope that it will be useful,
> +.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> +.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +.\" GNU General Public License for more details.
> +.\"
> +.\" You should have received a copy of the GNU General Public
> +.\" License along with this manual; if not, see
> +.\" <http://www.gnu.org/licenses/>.
> +.\" %%%LICENSE_END
> +.TH IOCTL-FSLABEL 2 2018-05-02 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +ioctl_fslabel \- get or set a filesystem label
> +.SH SYNOPSIS
> +.br
> +.B #include <sys/ioctl.h>
> +.br
> +.B #include <linux/fs.h>
> +.sp
> +.BI "int ioctl(int " fd ", FS_IOC_GETFSLABEL, char " label [FSLABEL_MAX]);
> +.br
> +.BI "int ioctl(int " fd ", FS_IOC_SETFSLABEL, char " label [FSLABEL_MAX]);
> +.SH DESCRIPTION
> +If a filesystem supports online label manipulation, these
> +.BR ioctl (2)
> +operations can be used to get or set the filesystem label for the filesystem
> +on which
> +.B fd
> +resides.

Does the calling process need special capabilities or permissions?  If
so, those should be listed here.

> +.SH RETURN VALUE
> +On success zero is returned.  On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EINVAL
> +The specified label exceeds the maximum label length for the filesystem.
> +.TP
> +.B ENOTTY
> +This can appear if the filesystem does not support online label manipulation.
> +.TP
> +.B EPERM
> +The calling process does not have sufficient permissions to set the label.
> +.TP
> +.B EFAULT
> +.I label
> +references an inaccessible memory area.
> +.SH VERSIONS
> +These ioctl operations first appeared in Linux 4.18.
> +They were previously known as
> +.B BTRFS_IOC_GET_FSLABEL
> +and
> +.B BTRFS_IOC_SET_FSLABEL
> +and were private to Btrfs.
> +.SH CONFORMING TO
> +This API is Linux-specific.
> +.SH NOTES
> +The maximum string length for this interface is
> +.BR FSLABEL_MAX ,
> +including the terminating null byte (\(aq\\0\(aq).
> +Filesystems have differing maximum label lengths, which may or
> +may not include the terminating null.  The string provided to
> +.B FS_IOC_SETFSLABEL
> +must always be null-terminated, and the string returned by
> +.B FS_IOC_GETFSLABEL
> +will always be null-terminated.
> +.SH SEE ALSO
> +.BR ioctl (2),
> +.BR blkid (8)
> diff --git a/man2/ioctl_getfslabel.2 b/man2/ioctl_getfslabel.2
> new file mode 100644
> index 0000000..bfa8dca
> --- /dev/null
> +++ b/man2/ioctl_getfslabel.2
> @@ -0,0 +1 @@
> +.so man2/ioctl_fslabel.2
> diff --git a/man2/ioctl_setfslabel.2 b/man2/ioctl_setfslabel.2
> new file mode 100644
> index 0000000..bfa8dca
> --- /dev/null
> +++ b/man2/ioctl_setfslabel.2
> @@ -0,0 +1 @@
> +.so man2/ioctl_fslabel.2

Put all the manpage content into ioctl_getfslabel.2 and have
ioctl_setfslabel.2 point to it, rather than three files.

--D

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
