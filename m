From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to
	procure some inode flags [ver #4]
Date: Sun, 4 Jul 2010 06:29:46 +0200
Message-ID: <AANLkTimj6ors03ysxqyuiDcSxEdKqGxTCAppDnV3haTZ@mail.gmail.com>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
	<20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
	<C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C80B6032-0FB2-4D63-B940-3FE86B52992B-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[CC+=3Dlinux-api]

On Fri, Jul 2, 2010 at 7:45 PM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrot=
e:
> On 2010-07-01, at 17:57, David Howells wrote:
>> [This is, for the moment, to be considered an example. =A0Do we actu=
ally want to
>> export these flags? =A0Should they be a full member of struct xstat?=
]
>
> I would say this should be a full-fledged member of struct xstat.
> I think they are fairly standard (available on many filesystems
> today), and requiring an ioctl to access them is unpleasant.
>
>> (1) User settable flags (to be consistent with the BSD st_flags fiel=
d):
>>
>> =A0 =A0 =A0 UF_NODUMP =A0 =A0 =A0 Do not dump this file.
>> =A0 =A0 =A0 UF_IMMUTABLE =A0 =A0This file is immutable.
>> =A0 =A0 =A0 UF_APPEND =A0 =A0 =A0 This file is append-only.
>> =A0 =A0 =A0 UF_OPAQUE =A0 =A0 =A0 This directory is opaque (unionfs)=
=2E
>> =A0 =A0 =A0 UF_NOUNLINK =A0 =A0 This file can't be removed or rename=
d.
>> =A0 =A0 =A0 UF_COMPRESSED =A0 This file is compressed.
>> =A0 =A0 =A0 UF_HIDDEN =A0 =A0 =A0 This file shouldn't be displayed i=
n a GUI.
>>
>> =A0 =A0The UF_SETTABLE constant is the union of the above flags.
>>
>> (2) Superuser settable flags (to be consistent with the BSD st_flags=
 field):
>>
>> =A0 =A0 =A0 SF_ARCHIVED =A0 =A0 This file has been archived.
>> =A0 =A0 =A0 SF_IMMUTABLE =A0 =A0This file is immutable.
>> =A0 =A0 =A0 SF_APPEND =A0 =A0 =A0 This file is append-only.
>> =A0 =A0 =A0 SF_NOUNLINK =A0 =A0 This file can't be removed or rename=
d.
>> =A0 =A0 =A0 SF_HIDDEN =A0 =A0 =A0 This file is a snapshot inode.
>>
>> =A0 =A0The SF_SETTABLE constant is the union of the above flags.
>>
>> (3) Linux-specific flags:
>>
>> =A0 =A0 =A0 XSTAT_LF_MAGIC_FILE =A0 =A0 Magic file, such as found in=
 procfs and sysfs.
>> =A0 =A0 =A0 XSTAT_LF_SYNC =A0 =A0 =A0 =A0 =A0 File is written synchr=
onously.
>> =A0 =A0 =A0 XSTAT_LF_NOATIME =A0 =A0 =A0 =A0Atime is not updated on =
this file.
>> =A0 =A0 =A0 XSTAT_LF_JOURNALLED_DATA Data modifications to this file=
 are journalled.
>> =A0 =A0 =A0 XSTAT_LF_ENCRYPTED =A0 =A0 =A0This file is encrypted.
>> =A0 =A0 =A0 XSTAT_LF_SYSTEM =A0 =A0 =A0 =A0 This file is a system fi=
le (FAT/NTFS/CIFS).
>> =A0 =A0 =A0 XSTAT_LF_TEMPORARY =A0 =A0 =A0This file is a temporary f=
ile (NTFS/CIFS).
>> =A0 =A0 =A0 XSTAT_LF_OFFLINE =A0 =A0 =A0 =A0file is currently unavai=
lable (CIFS).
>
> Yuck on the names. =A0Why not stick with the "UF_" and "SF_" prefixes=
?
> Since we don't need to keep _binary_ compatibility with these flag va=
lues
> (only name portability) we can use the same flag values as the
> FS_*_FL definitions in fs.h. =A0That is what all of the existing file=
systems
> already use (ext2/3/4, ocfs, btrfs, reiserfs, xfs, jfs).

Agree on the naming. Andreas expresses what I intended when I proposed =
the idea.

Cheers,

Michael


--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
