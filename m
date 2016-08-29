From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] ioctl_xfs_ioc_getfsmap.2: document XFS_IOC_GETFSMAP ioctl
Date: Mon, 29 Aug 2016 15:34:11 -0600
Message-ID: <32A3DAED-21FC-4252-B53E-3503764342E8@dilger.ca>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org> <147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2E1D2157-263F-4F98-92FB-AF81C12491C7"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_2E1D2157-263F-4F98-92FB-AF81C12491C7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 25, 2016, at 5:26 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> Document the new XFS_IOC_GETFSMAP ioctl that returns the physical
> layout of a (disk-based) filesystem.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> man2/ioctl_xfs_ioc_getfsmap.2 |  294 =
+++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 294 insertions(+)
> create mode 100644 man2/ioctl_xfs_ioc_getfsmap.2
>=20
>=20
> diff --git a/man2/ioctl_xfs_ioc_getfsmap.2 =
b/man2/ioctl_xfs_ioc_getfsmap.2
> new file mode 100644
> index 0000000..0d9ed47
> --- /dev/null
> +++ b/man2/ioctl_xfs_ioc_getfsmap.2
> @@ -0,0 +1,294 @@
> +.\" Copyright (c) 2016, Oracle.  All rights reserved.
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
> +.TH IOCTL-XFS_IOC_GETFSMAP 2 2016-07-20 "Linux" "Linux Programmer's =
Manual"
> +.SH NAME
> +ioctl_xfs_ioc_getfsmap \- retrieve the physical layout of the =
filesystem
> +.SH SYNOPSIS
> +.br
> +.B #include <sys/ioctl.h>
> +.br
> +.B #include <linux/fs.h>
> +.sp
> +.BI "int ioctl(int " fd ", XFS_IOC_GETFSMAP, struct getfsmap * " arg =
);
> +.SH DESCRIPTION
> +This
> +.BR ioctl (2)
> +retrieves physical extent mappings for a filesystem.
> +This information can be used to discover which files are mapped to a =
physical
> +block, examine free space, or find known bad blocks, among other =
things.
> +
> +The sole argument to this ioctl should be an array of the following
> +structure:
> +.in +4n
> +.nf
> +
> +struct getfsmap {
> +	__u32		fmv_device;	/* device id */
> +	__u32		fmv_unused1;	/* future use, must be zero */
> +	__u64		fmv_block;	/* starting block */
> +	__u64		fmv_owner;	/* owner id */
> +	__u64		fmv_offset;	/* file offset of segment */
> +	__u64		fmv_length;	/* length of segment, blocks */
> +	__u32		fmv_oflags;	/* mapping flags */
> +	__u32		fmv_iflags;	/* control flags (1st structure) =
*/
> +	__u32		fmv_count;	/* # of entries in array incl. =
input */
> +	__u32		fmv_entries;	/* # of entries filled in =
(output). */
> +	__u64		fmv_unused2;	/* future use, must be zero */
> +};
> +
> +.fi
> +.in
> +The array must contain at least two elements.
> +The first two array elements specify the lowest and highest =
reverse-mapping
> +keys, respectively, for which userspace would like physical mapping
> +information.
> +A reverse mapping key consists of the tuple (device, block, owner, =
offset).
> +The owner and offset fields are part of the key because some =
filesystems
> +support sharing physical blocks between multiple files and
> +therefore may return multiple mappings for a given physical block.
> +
> +.SS Fields of struct getfsmap
> +.PP
> +The
> +.I fmv_device
> +field contains a 32-bit cookie to uniquely identify the underlying =
storage
> +device.
> +If the
> +.B FMV_HOF_DEV_T
> +flag is set in the header's
> +.I fmv_oflags
> +field, this field contains a dev_t from which major and minor numbers =
can
> +be extracted.
> +If the flag is not set, this field contains a value that must be =
unique
> +for each storage device.
> +
> +.PP
> +The
> +.I fmv_unused1
> +field must be zero in the first two array elements.
> +
> +.PP
> +The
> +.I fmv_block
> +field contains the 512-byte sector address of the extent.

Why would you use 512-byte sectors in a new interface?  I recall for =
FIEMAP
that some filesystems may not have files aligned to sector offsets, and =
we
just used byte offsets.  Storage like NVDIMMs are cacheline granular, so =
I
don't think it makes sense to tie this to old disk sector sizes.  =
Alternately,
the units could be in terms of fs blocks as returned by =
statvfs.st_bsize,
but mixing units for fmv_block, fmv_offset, fmv_length is uneeded =
complexity.

> +
> +.PP
> +The
> +.I fmv_owner
> +field contains the owner of the extent.
> +This is generally an inode number, though if
> +.B FMV_OF_SPECIAL_OWNER
> +is set in the
> +.I fmv_oflags
> +field, then the owner value is one of the following special values:
> +.TP
> +.B FMV_OWN_FREE
> +Free space.
> +.TP
> +.B FMV_OWN_UNKNOWN
> +This extent has an unknown owner.
> +.TP
> +.B FMV_OWN_FS
> +Static filesystem metadata.
> +.TP
> +.B FMV_OWN_LOG
> +The filesystem journal.
> +.TP
> +.B FMV_OWN_AG
> +Allocation group metadata.
> +.TP
> +.B FMV_OWN_INODES
> +Inodes.
> +.TP
> +.B FMV_OWN_DEFECTIVE:
> +This extent has been marked defective either by the filesystem or the
> +underlying device.

These above ones are relatively clear what they are.  The next items are
not very clear what they are, and whether they need to be exported as
specific items, or could they just be lumped under "FMV_OWN_FS"?  If =
they
serve some specific purpose, at a minimum they need better descriptions.

> +.TP
> +.B FMV_OWN_INOBT
> +The inode index, if one is provided.
> +.TP
> +.B FMV_OWN_REFC
> +Reference counting indexes.
> +.TP
> +.B FMV_OWN_COW
> +This extent is being used to stage a copy-on-write.
>=20
> +
> +.PP
> +The
> +.I fmv_offset
> +field contains the logical address of the reverse mapping record, in =
units
> +of 512-byte blocks.
> +This field has no meaning if the
> +.BR FMV_OF_SPECIAL_OWNER " or " FMV_OF_EXTENT_MAP
> +flags are set in
> +.IR fmv_oflags "."
> +
> +.PP
> +The
> +.I fmv_length
> +field contains the length of the extent, in units of 512-byte blocks.
> +This field must be zero in the second array element.
> +
> +.PP
> +The
> +.I fmv_oflags
> +field is a bitmask of extent state flags.
> +In the header, the bits are:
> +.TP
> +.B FMV_HOF_DEV_T
> +All
> +.I fmv_device
> +values will be in dev_t format.
> +If this flag is not set, the value is merely a 32-bit cookie that =
will be
> +unique for each physical device.
> +.TP
> +In a non-header, the bits are:
> +.TP
> +.B FMV_OF_PREALLOC
> +The extent is allocated but not yet written.
> +.TP
> +.B FMV_OF_ATTR_FORK
> +This extent contains extended attribute data.
> +.TP
> +.B FMV_OF_EXTENT_MAP
> +This extent contains extent map information for the owner.
> +.TP
> +.B FMV_OF_SHARED
> +Parts of this extent may be shared.
> +.TP
> +.B FMV_OF_SPECIAL_OWNER
> +The
> +.I fmv_owner
> +field contains a special value instead of an inode number.
> +.TP
> +.B FMV_OF_LAST
> +This is the last record in the filesystem.
> +
> +.PP
> +The
> +.I fmv_iflags
> +field is a bitmask passed to the kernel to alter the output.
> +There are no flags defined, so this value must be zero in the first
> +two array elements.

It seems like there are several fields in the structure that are used =
for
only input or only output?  Does it make more sense to have one =
structure
used only for the input request, and then the array of values returned =
be
in a different structure?  I'm not necessarily requesting that it be =
changed,
but it definitely is something I noticed a few times while reading this =
doc.

Cheers, Andreas

> +.PP
> +The
> +.I fmv_count
> +field contains the number of elements in the array being passed to =
the
> +kernel.
> +This count must include the two control elements at the start of the
> +array.
> +The value must be specified in the first array element; in the second
> +element this field must be zero.
> +
> +If this value is 2,
> +.I fmv_entries
> +will be set to the number of records that would have been returned =
had
> +the array been large enough;
> +no extent information will be returned.
> +
> +.PP
> +The
> +.I fmv_entries
> +field contains the number of elements in the array that contain =
useful
> +information if the ioctl returns a non-error value.
> +This value does not include the two control elements at the start of =
the array.
> +This value is only set in the first array element;
> +in the second element, this field must be zero.
> +
> +.PP
> +The
> +.I fmv_unused2
> +field must be zero in the first two array elements.
> +
> +.SS Array Elements
> +.PP
> +The key fields (fmv_device, fmv_block, fmv_owner, fmv_offset) of the =
first
> +element of the array specify the lowest extent record in the keyspace =
that
> +the caller wants returned.
> +For example, if the key is set to (0, 36, 0, 0), the filesystem will
> +only return records for extents starting at or above sector 36 on
> +disk.
> +For convenience, the
> +.I fmv_length
> +field will be added to the
> +.IR fmv_block " and " fmv_offset
> +fields as appropriate so that the (fmv_device, fmv_block, fmv_owner,
> +fmv_offset, fmv_length) fields in the last array element can be =
copied
> +into the first element to seed the next ioctl call.
> +
> +The key fields of the second element of the array specify the highest
> +extent record in the keyspace that the caller wants returned.
> +Returning to our example above, if that example key were instead
> +passed in via the second array element, the filesystem will not =
return
> +records for extents going past sector 36 on disk.
> +For convenience, the four key fields can be set to ~0 (all ones) to
> +signify "end of filesystem".
> +
> +If
> +.I fmv_count
> +in the first element of the array is 2, then
> +.I fmv_entries
> +in the first element of the array will be set to the number of extent
> +records found in the filesystem.
> +Otherwise,
> +.I fmv_entries
> +will be set to the number of extents actually returned, and the =
subsequent
> +array elements will be filled out with extent information.
> +In these
> +subsequent array elements, the fields
> +.IR fmv_iflags ", " fmv_count ", " fmv_entries ", and " fmv_unused1
> +will be set to zero by the filesystem.
> +
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EINVAL
> +The array is not long enough, or a non-zero value was passed in one =
of the
> +fields that must be zero.
> +.TP
> +.B EFAULT
> +The pointer passed in was not mapped to a valid memory address.
> +.TP
> +.B EBADF
> +.IR fd
> +is not open for reading.
> +.TP
> +.B EPERM
> +This query is not allowed.
> +.TP
> +.B EOPNOTSUPP
> +The filesystem does not support this command.
> +
> +.SH CONFORMING TO
> +This API is Linux-specific.
> +Not all filesystems support it.
> +.fi
> +.in
> +.SH SEE ALSO
> +.BR ioctl (2)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2E1D2157-263F-4F98-92FB-AF81C12491C7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV8SqU3Kl2rkXzB/gAQjWMRAAo4wcTqoGaPKVJt26vl8F2aAk73zGpw0p
IM1ySAbpOBQhdAKgRUZQMagqpPJATCctCXo9h7TYfNaIjL8ujnKfTuIEPhw/KMTU
iiJh9Ms+tVq9VtskdOtdCdWf0x1Xlgo+ig5SyXNCRirjMeJT1+TQkGv6joc6rypx
GC8mjeh9hShOSFKTs06V1XuvaJ2f3Xoj1eXAcXRsTLtTBibvQdLQKLmFtsvsRY3Q
Q2mJIg2NvE32xaynI1GbD+LBrK3CENp5MiKlNfK5tv+BV+/ZB5GCu71NR8+/qPg/
3yQls86UbHSQuNWhJwm/dkRorjI7mxy9YUq1X9ESXDq6dtf96vEURXfmHCpE9tRm
GCHWRs0UJXLx7a3iM296tH/lOISo31hTbkICxSxClwKDgE47C9DfqWHkKtmHqJ04
sS+Xc+bW7H8drUs0lWqmFuG+bq5zmNtYaZXjPyDgRz4jlaeL/htLvplyshlJmJBH
ZhptuJxXW6VYAb1t+GVpo8/Kzp6xLWYBT+nrwirlwb0LOSYAsD/oqoQt3JFZIEQb
OsV/yEfJeiAK1ZstXkO5cM5ngdmSTknhUcj+OfXRe3FGUTqhUsQhgnAmOi5IN8Gu
3F68foV0hV2i5snMeCvedntCMv1udodMYafEkImpf/6c9PNut2TWegO2hSVmGWy6
eUd+oAWU9R4=
=QQYm
-----END PGP SIGNATURE-----

--Apple-Mail=_2E1D2157-263F-4F98-92FB-AF81C12491C7--
