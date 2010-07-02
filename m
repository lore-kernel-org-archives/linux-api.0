From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats
	available [ver #3]
Date: Fri, 2 Jul 2010 07:36:53 +0200
Message-ID: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100630233614.32422.97038.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi David,

[Please CC linux-api@ on patches that change the API/ABI]

On Thu, Jul 1, 2010 at 1:36 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> Add a pair of system calls to make extended file stats available, inc=
luding
> file creation time, inode version and data version where available th=
rough the
> underlying filesystem.

Just some random thoughts here. I've not tried to guess the overhead
of these ideas...

* Include information from the "inode_info" structure, most notably
i_flags, but perhaps other info as well.

* Return a bit mask indicating the presence of additional information
associated with the i-node. Here, I am thinking of flags that indicate
that the file has any of the following: capabilities, an ACL, and
extended attributes (obviously a superset of the previous). I could
imagine some apps that, having got the xstat info, would be interested
to obtain some of this other info.

Obviously, the above only make sense if the overhead of providing the
extra information is low.

> [This depends on the previously posted pair of patches to (a) constif=
y a number
> =A0of syscall string and buffer arguments and (b) rearrange AFS's use=
 of
> =A0i_version and i_generation].
>
> The following structures are defined for their use:
>
> =A0 =A0 =A0 =A0struct xstat_parameters {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0request_=
mask;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat_dev {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0ma=
jor, minor;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat_time {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0tv_sec, =
tv_nsec;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_nlink;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_uid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_gid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_rde=
v;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_dev=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_atime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_mtime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_ctime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_btime=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_ino;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_blksi=
ze;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_block=
s;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_gen;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_data_=
version;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_resul=
t_mask;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_extra=
_results[0];
> =A0 =A0 =A0 =A0};
>
> where st_btime is the file creation time, st_gen is the inode generat=
ion
> (i_generation), st_data_version is the data version number (i_version=
),
> request_mask and st_result_mask are bitmasks of data desired/provided=
 and
> st_extra_results[] is where as-yet undefined fields are appended.
>
> The defined bits in request_mask and st_result_mask are:
>
> =A0 =A0 =A0 =A0XSTAT_REQUEST_MODE =A0 =A0 =A0 =A0 =A0 =A0 =A0Want/got=
 st_mode
> =A0 =A0 =A0 =A0XSTAT_REQUEST_NLINK =A0 =A0 =A0 =A0 =A0 =A0 Want/got s=
t_nlink
> =A0 =A0 =A0 =A0XSTAT_REQUEST_UID =A0 =A0 =A0 =A0 =A0 =A0 =A0 Want/got=
 st_uid
> =A0 =A0 =A0 =A0XSTAT_REQUEST_GID =A0 =A0 =A0 =A0 =A0 =A0 =A0 Want/got=
 st_gid
> =A0 =A0 =A0 =A0XSTAT_REQUEST_RDEV =A0 =A0 =A0 =A0 =A0 =A0 =A0Want/got=
 st_rdev
> =A0 =A0 =A0 =A0XSTAT_REQUEST_ATIME =A0 =A0 =A0 =A0 =A0 =A0 Want/got s=
t_atime
> =A0 =A0 =A0 =A0XSTAT_REQUEST_MTIME =A0 =A0 =A0 =A0 =A0 =A0 Want/got s=
t_mtime
> =A0 =A0 =A0 =A0XSTAT_REQUEST_CTIME =A0 =A0 =A0 =A0 =A0 =A0 Want/got s=
t_ctime
> =A0 =A0 =A0 =A0XSTAT_REQUEST_INO =A0 =A0 =A0 =A0 =A0 =A0 =A0 Want/got=
 st_ino
> =A0 =A0 =A0 =A0XSTAT_REQUEST_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =A0Want/got=
 st_size
> =A0 =A0 =A0 =A0XSTAT_REQUEST_BLOCKS =A0 =A0 =A0 =A0 =A0 =A0Want/got s=
t_blocks
> =A0 =A0 =A0 =A0XSTAT_REQUEST__BASIC_STATS =A0 =A0 =A0The stuff in the=
 normal stat struct
> =A0 =A0 =A0 =A0XSTAT_REQUEST_BTIME =A0 =A0 =A0 =A0 =A0 =A0 Want/got s=
t_btime
> =A0 =A0 =A0 =A0XSTAT_REQUEST_GEN =A0 =A0 =A0 =A0 =A0 =A0 =A0 Want/got=
 st_gen
> =A0 =A0 =A0 =A0XSTAT_REQUEST_DATA_VERSION =A0 =A0 =A0Want/got st_data=
_version
> =A0 =A0 =A0 =A0XSTAT_REQUEST__EXTENDED_STATS =A0 The stuff in the xst=
at struct
> =A0 =A0 =A0 =A0XSTAT_REQUEST__ALL_STATS =A0 =A0 =A0 =A0The defined se=
t of requestables
>
> The system calls are:
>
> =A0 =A0 =A0 =A0ssize_t ret =3D xstat(int dfd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fi=
lename,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned flags=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct x=
stat_parameters *params,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat *=
buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t buflen)=
;
>
> =A0 =A0 =A0 =A0ssize_t ret =3D fxstat(unsigned fd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned flag=
s,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct =
xstat_parameters *params,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat =
*buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t buflen=
);
>
>
> The dfd, filename, flags and fd parameters indicate the file to query=
=2E =A0There
> is no equivalent of lstat() as that can be emulated with xstat() by p=
assing
> AT_SYMLINK_NOFOLLOW in flags.
>
> AT_FORCE_ATTR_SYNC can also be set in flags. =A0This will require a n=
etwork
> filesystem to synchronise its attributes with the server.
>
> When the system call is executed, the request_mask bitmask is read fr=
om the
> parameter block to work out what the user is requesting. =A0If params=
 is NULL,
> then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.
>
> The request_mask should be set by the caller to specify extra results=
 that the
> caller may desire. =A0These come in a number of classes:
>
> =A0(0) dev, blksize.
>
> =A0 =A0 These are local data and are always available.
>
> =A0(1) mode, nlinks, uid, gid, [amc]time, ino, size, blocks.
>
> =A0 =A0 These will be returned whether the caller asks for them or no=
t. =A0The
> =A0 =A0 corresponding bits in result_mask will be set to indicate the=
ir presence.
>
> =A0 =A0 If the caller didn't ask for them, then they may be approxima=
ted. =A0For
> =A0 =A0 example, NFS won't waste any time updating them from the serv=
er, unless as
> =A0 =A0 a byproduct of updating something requested.
>
> =A0(2) rdev.
>
> =A0 =A0 As for class (1), but this won't be returned if the file is n=
ot a blockdev
> =A0 =A0 or chardev. =A0The bit will be cleared if the value is not re=
turned.
>
> =A0(3) File creation time, inode generation and data version.
>
> =A0 =A0 These will be returned if available whether the caller asked =
for them or
> =A0 =A0 not. =A0The corresponding bits in result_mask will be set or =
cleared as
> =A0 =A0 appropriate to indicate their presence.
>
> =A0 =A0 If the caller didn't ask for them, then they may be approxima=
ted. =A0For
> =A0 =A0 example, NFS won't waste any time updating them from the serv=
er, unless
> =A0 =A0 as a byproduct of updating something requested.
>
> =A0(4) Extra results.
>
> =A0 =A0 These will only be returned if the caller asked for them by s=
etting their
> =A0 =A0 bits in request_mask. =A0They will be placed in the buffer af=
ter the xstat
> =A0 =A0 struct in ascending result_mask bit order. =A0Any bit set in =
request_mask
> =A0 =A0 mask will be left set in result_mask if the result is availab=
le and
> =A0 =A0 cleared otherwise.
>
> =A0 =A0 The pointer into the results list will be rounded up to the n=
earest 8-byte
> =A0 =A0 boundary after each result is written in. =A0The size of each=
 extra result
> =A0 =A0 is specific to the definition for that result.
>
> =A0 =A0 No extra results are currently defined.
>
> If the buffer is insufficiently big, the syscall returns the amount o=
f space it
> will need to write the complete result set and returns a partial resu=
lt in the
> buffer.
>
> At the moment, this will only work on x86_64 as it requires system ca=
lls to be
> wired up.
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> FILESYSTEMS
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The following filesystems have been modified to make use of this faci=
lity:
>
> =A0(*) Ext4. =A0This will return the creation time and inode version =
number for all
> =A0 =A0 files. =A0It will, however, only return the data version numb=
er for
> =A0 =A0 directories unless the I_VERSION option is set on the filesys=
tem.
>
> =A0(*) AFS. =A0This will return the vnode ID uniquifier as the inode =
version and
> =A0 =A0 the AFS data version number as the data version. =A0There is =
no file
> =A0 =A0 creation time available.
>
> =A0 =A0 AFS should go to the server if AT_FORCE_ATTR_SYNC is specifie=
d.
>
> =A0(*) NFS. =A0This will return the change attribute if NFSv4 only. =A0=
No other extra
> =A0 =A0 values are returned at this time.
>
> =A0 =A0 If AT_FORCE_ATTR_SYNC is set or mtime, ctime or data_version =
(NFSv4 only)
> =A0 =A0 are asked for then the outstanding writes will be written to =
the server
> =A0 =A0 first.
>
> =A0 =A0 If AT_FORCE_ATTR_SYNC is set or atime is requested then the a=
ttributes
> =A0 =A0 will be reread unconditionally, otherwise if any of data vers=
ion (NFSv4
> =A0 =A0 only) XSTAT_REQUEST__BASIC_STATS are requested, then the attr=
ibutes will
> =A0 =A0 be reread if the cached attributes have expired.
>
>
> =3D=3D=3D=3D=3D=3D=3D
> TESTING
> =3D=3D=3D=3D=3D=3D=3D
>
> The following test program can be used to test the xstat system call:
>
> =A0 =A0 =A0 =A0#define _GNU_SOURCE
> =A0 =A0 =A0 =A0#define _ATFILE_SOURCE
> =A0 =A0 =A0 =A0#include <stdio.h>
> =A0 =A0 =A0 =A0#include <stdlib.h>
> =A0 =A0 =A0 =A0#include <string.h>
> =A0 =A0 =A0 =A0#include <unistd.h>
> =A0 =A0 =A0 =A0#include <fcntl.h>
> =A0 =A0 =A0 =A0#include <time.h>
> =A0 =A0 =A0 =A0#include <sys/syscall.h>
> =A0 =A0 =A0 =A0#include <sys/stat.h>
> =A0 =A0 =A0 =A0#include <sys/types.h>
>
> =A0 =A0 =A0 =A0#define AT_FORCE_ATTR_SYNC =A0 =A0 =A00x800
>
> =A0 =A0 =A0 =A0struct xstat_parameters {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0request_=
mask;
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_MODE =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x00000001ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_NLINK =A0 =A0 =A0 =A0 =A0 =A0 0x=
00000002ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_UID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0x00000004ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_GID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0x00000008ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_RDEV =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x00000010ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_ATIME =A0 =A0 =A0 =A0 =A0 =A0 0x=
00000020ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_MTIME =A0 =A0 =A0 =A0 =A0 =A0 0x=
00000040ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_CTIME =A0 =A0 =A0 =A0 =A0 =A0 0x=
00000080ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_INO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0x00000100ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x00000200ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_BLOCKS =A0 =A0 =A0 =A0 =A0 =A00x=
00000400ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST__BASIC_STATS =A0 =A0 =A00x000007=
ffULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_BTIME =A0 =A0 =A0 =A0 =A0 =A0 0x=
00000800ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_GEN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
0x00001000ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST_DATA_VERSION =A0 =A0 =A00x000020=
00ULL
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST__EXTENDED_STATS =A0 0x00003fffUL=
L
> =A0 =A0 =A0 =A0#define XSTAT_REQUEST__ALL_STATS =A0 =A0 =A0 =A00x0000=
3fffULL
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat_dev {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0major;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0minor;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat_time {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0tv_sec;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0tv_nsec;
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0struct xstat {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_nlink;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_uid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0st=
_gid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_rde=
v;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_dev =A0 =A0 =A0 =A0st_dev=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_atim;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_mtim;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_ctim;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_time =A0 =A0 =A0 st_btim;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_ino;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_blksi=
ze;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_block=
s;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_gen;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_data_=
version;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_resul=
t_mask;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_extra=
_results[0];
> =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0#define __NR_xstat =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0300
> =A0 =A0 =A0 =A0#define __NR_fxstat =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 301
>
> =A0 =A0 =A0 =A0static __attribute__((unused))
> =A0 =A0 =A0 =A0ssize_t xstat(int dfd, const char *filename, unsigned =
flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_parameters *p=
arams,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat *buffer, size=
_t bufsize)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return syscall(__NR_xstat, dfd, filena=
me, flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 params, b=
uffer, bufsize);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0static __attribute__((unused))
> =A0 =A0 =A0 =A0ssize_t fxstat(int fd, unsigned flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat_parameters *=
params,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat *buffer, siz=
e_t bufsize)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return syscall(__NR_fxstat, fd, flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 params, b=
uffer, bufsize);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0static void print_time(const char *field, const struct=
 xstat_time *xstm)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct tm tm;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0time_t tim;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char buffer[100];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int len;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tim =3D xstm->tv_sec;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!localtime_r(&tim, &tm)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("localtime_r");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D strftime(buffer, 100, "%F %T",=
 &tm);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (len =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("strftime");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("%s", field);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fwrite(buffer, 1, len, stdout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(".%09llu", xstm->tv_nsec);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D strftime(buffer, 100, "%z", &t=
m);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (len =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("strftime2");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fwrite(buffer, 1, len, stdout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("\n");
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0static void dump_xstat(struct xstat *xst)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char buffer[256], ft;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("results=3D%llx\n", xst->st_res=
ult_mask);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" ");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_SIZE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" Size: %-15llu=
", xst->st_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_BLOCKS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" Blocks: %-10l=
lu", xst->st_blocks);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" IO Block: %-6llu ", xst->st_b=
lksize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_MODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (xst->st_mode &=
 S_IFMT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFIFO: =A0 prin=
tf(" FIFO\n"); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ft =3D 'p'; b=
reak;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFCHR: =A0 prin=
tf(" character special file\n"); =A0 =A0ft =3D 'c'; break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFDIR: =A0 prin=
tf(" directory\n"); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ft =3D 'd'; break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFBLK: =A0 prin=
tf(" block special file\n"); =A0 =A0 =A0 =A0ft =3D 'b'; break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFREG: =A0 prin=
tf(" regular file\n"); =A0 =A0 =A0 =A0 =A0 =A0 =A0ft =3D '-'; break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFLNK: =A0 prin=
tf(" symbolic link\n"); =A0 =A0 =A0 =A0 =A0 =A0 ft =3D 'l'; break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case S_IFSOCK: =A0prin=
tf(" socket\n"); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ft =3D 's'; bre=
ak;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf=
("unknown type (%o)\n", xst->st_mode & S_IFMT);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ft =3D=
 '?';
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sprintf(buffer, "%02x:%02x", xst->st_d=
ev.major, xst->st_dev.minor);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Device: %-15s", buffer);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_INO)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" Inode: %-11ll=
u", xst->st_ino);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_SIZE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" Links: %-5u",=
 xst->st_nlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_RDEV)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf(" Device type: =
%u,%u",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_r=
dev.major, xst->st_rdev.minor);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("\n");
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_MODE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Access: (%04o/=
%c%c%c%c%c%c%c%c%c%c) =A0",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & 07777,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ft,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IRUSR ? 'r' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IWUSR ? 'w' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IXUSR ? 'x' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IRGRP ? 'r' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IWGRP ? 'w' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IXGRP ? 'x' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IROTH ? 'r' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IWOTH ? 'w' : '-',
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xst->st_m=
ode & S_IXOTH ? 'x' : '-');
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_UID)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Uid: %d =A0 \n=
", xst->st_uid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_GID)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Gid: %u\n", xs=
t->st_gid);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_ATIME)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_time("Access: ",=
 &xst->st_atim);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_MTIME)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_time("Modify: ",=
 &xst->st_mtim);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_CTIME)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_time("Change: ",=
 &xst->st_ctim);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_BTIME)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0print_time("Create: ",=
 &xst->st_btim);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_GEN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Inode version:=
 %llxh\n", xst->st_gen);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xst->st_result_mask & XSTAT_REQUES=
T_DATA_VERSION)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("Data version: =
%llxh\n", xst->st_data_version);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0int main(int argc, char **argv)
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_parameters params;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat xst;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ret, atflag =3D AT_SYMLINK_NOFOLLO=
W;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long query =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XSTAT_REQUEST__BASIC_S=
TATS |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XSTAT_REQUEST_BTIME |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XSTAT_REQUEST_GEN |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XSTAT_REQUEST_DATA_VER=
SION;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (argv++; *argv; argv++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (strcmp(*argv, "-F"=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atflag=
 |=3D AT_FORCE_ATTR_SYNC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (strcmp(*argv, "-L"=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atflag=
 &=3D ~AT_SYMLINK_NOFOLLOW;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (strcmp(*argv, "-O"=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0query =
&=3D ~XSTAT_REQUEST__BASIC_STATS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(&xst, 0xbf, siz=
eof(xst));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0params.request_mask =3D=
 query;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D xstat(AT_FDCWD=
, *argv, atflag, &params, &xst, sizeof(xst));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("xstat(%s) =3D =
%d\n", *argv, ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror=
(*argv);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dump_xstat(&xst);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> Just compile and run, passing it paths to the files you want to exami=
ne:
>
> =A0 =A0 =A0 =A0[root@andromeda ~]# /tmp/xstat -O /dev/tty
> =A0 =A0 =A0 =A0xstat(/dev/tty) =3D 152
> =A0 =A0 =A0 =A0results=3D7ff
> =A0 =A0 =A0 =A0 =A0Size: 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Blocks: 0 =A0 =
=A0 =A0 =A0 =A0IO Block: 4096 =A0 =A0character special file
> =A0 =A0 =A0 =A0Device: 00:0f =A0 =A0 =A0 =A0 =A0 Inode: 246 =A0 =A0 =A0=
 =A0 Links: 1 =A0 =A0 Device type: 5,0
> =A0 =A0 =A0 =A0Access: (0666/crw-rw-rw-) =A0Uid: 0
> =A0 =A0 =A0 =A0Gid: 5
> =A0 =A0 =A0 =A0Access: 2010-06-30 16:25:01.813517001+0100
> =A0 =A0 =A0 =A0Modify: 2010-06-30 16:25:01.813517001+0100
> =A0 =A0 =A0 =A0Change: 2010-06-30 16:25:01.813517001+0100
>
> =A0 =A0 =A0 =A0[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cach=
e/
> =A0 =A0 =A0 =A0xstat(/var/cache/fscache/cache/) =3D 152
> =A0 =A0 =A0 =A0results=3D3fef
> =A0 =A0 =A0 =A0 =A0Size: 4096 =A0 =A0 =A0 =A0 =A0 =A0Blocks: 16 =A0 =A0=
 =A0 =A0 IO Block: 4096 =A0 =A0directory
> =A0 =A0 =A0 =A0Device: 08:06 =A0 =A0 =A0 =A0 =A0 Inode: 130561 =A0 =A0=
 =A0Links: 3
> =A0 =A0 =A0 =A0Access: (0700/drwx------) =A0Uid: 0
> =A0 =A0 =A0 =A0Gid: 0
> =A0 =A0 =A0 =A0Access: 2010-06-29 18:16:33.680703545+0100
> =A0 =A0 =A0 =A0Modify: 2010-06-29 18:16:20.132786632+0100
> =A0 =A0 =A0 =A0Change: 2010-06-29 18:16:20.132786632+0100
> =A0 =A0 =A0 =A0Create: 2010-06-25 15:17:39.471199293+0100
> =A0 =A0 =A0 =A0Inode version: f585ab70h
> =A0 =A0 =A0 =A0Data version: 2h
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0arch/x86/include/asm/unistd_32.h | =A0 =A04 +
> =A0arch/x86/include/asm/unistd_64.h | =A0 =A04 +
> =A0fs/afs/inode.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 11 +-
> =A0fs/ecryptfs/inode.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02
> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02
> =A0fs/ext4/file.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02
> =A0fs/ext4/inode.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 27 +++++-
> =A0fs/ext4/namei.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02
> =A0fs/ext4/symlink.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02
> =A0fs/nfs/inode.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 46 ++++++=
+---
> =A0fs/nfsd/nfs3proc.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02
> =A0fs/nfsd/nfs3xdr.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 +
> =A0fs/nfsd/nfs4xdr.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 +
> =A0fs/nfsd/nfsproc.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A06 +
> =A0fs/nfsd/nfsxdr.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02
> =A0fs/stat.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0175 =
++++++++++++++++++++++++++++++++++----
> =A0include/linux/fcntl.h =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01
> =A0include/linux/fs.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02
> =A0include/linux/stat.h =A0 =A0 =A0 =A0 =A0 =A0 | =A0103 ++++++++++++=
++++++++++
> =A0include/linux/syscalls.h =A0 =A0 =A0 =A0 | =A0 =A09 ++
> =A020 files changed, 368 insertions(+), 42 deletions(-)
>
> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/=
unistd_32.h
> index beb9b5f..a9953cc 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -343,10 +343,12 @@
> =A0#define __NR_rt_tgsigqueueinfo 335
> =A0#define __NR_perf_event_open =A0 336
> =A0#define __NR_recvmmsg =A0 =A0 =A0 =A0 =A0337
> +#define __NR_xstat =A0 =A0 =A0 =A0 =A0 =A0 338
> +#define __NR_fxstat =A0 =A0 =A0 =A0 =A0 =A0339
>
> =A0#ifdef __KERNEL__
>
> -#define NR_syscalls 338
> +#define NR_syscalls 340
>
> =A0#define __ARCH_WANT_IPC_PARSE_VERSION
> =A0#define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/=
unistd_64.h
> index ff4307b..c90d240 100644
> --- a/arch/x86/include/asm/unistd_64.h
> +++ b/arch/x86/include/asm/unistd_64.h
> @@ -663,6 +663,10 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqu=
eueinfo)
> =A0__SYSCALL(__NR_perf_event_open, sys_perf_event_open)
> =A0#define __NR_recvmmsg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0299
> =A0__SYSCALL(__NR_recvmmsg, sys_recvmmsg)
> +#define __NR_xstat =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 300
> +__SYSCALL(__NR_xstat, sys_xstat)
> +#define __NR_fxstat =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0301
> +__SYSCALL(__NR_fxstat, sys_fxstat)
>
> =A0#ifndef __NO_STUBS
> =A0#define __ARCH_WANT_OLD_READDIR
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index ee3190a..f624c5a 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -300,16 +300,17 @@ error_unlock:
> =A0/*
> =A0* read the attributes of an inode
> =A0*/
> -int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> +int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct =
kstat *stat)
> =A0{
> - =A0 =A0 =A0 struct inode *inode;
> -
> - =A0 =A0 =A0 inode =3D dentry->d_inode;
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
>
> =A0 =A0 =A0 =A0_enter("{ ino=3D%lu v=3D%u }", inode->i_ino, inode->i_=
generation);
>
> =A0 =A0 =A0 =A0generic_fillattr(inode, stat);
> +
> + =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_GEN | XSTAT_REQUES=
T_DATA_VERSION;
> + =A0 =A0 =A0 stat->gen =3D inode->i_generation;
> + =A0 =A0 =A0 stat->data_version =3D inode->i_version;
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 31ef525..0b02272 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -994,6 +994,8 @@ int ecryptfs_getattr(struct vfsmount *mnt, struct=
 dentry *dentry,
> =A0 =A0 =A0 =A0struct kstat lower_stat;
> =A0 =A0 =A0 =A0int rc;
>
> + =A0 =A0 =A0 lower_stat.query_flags =3D stat->query_flags;
> + =A0 =A0 =A0 lower_stat.request_mask =3D stat->request_mask | XSTAT_=
REQUEST_BLOCKS;
> =A0 =A0 =A0 =A0rc =3D vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry=
),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ecryptfs_dentry_to_lo=
wer(dentry), &lower_stat);
> =A0 =A0 =A0 =A0if (!rc) {
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 19a4de5..96823f3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1571,6 +1571,8 @@ extern int =A0ext4_write_inode(struct inode *, =
struct writeback_control *);
> =A0extern int =A0ext4_setattr(struct dentry *, struct iattr *);
> =A0extern int =A0ext4_getattr(struct vfsmount *mnt, struct dentry *de=
ntry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 kstat *stat);
> +extern int =A0ext4_file_getattr(struct vfsmount *mnt, struct dentry =
*dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
kstat *stat);
> =A0extern void ext4_delete_inode(struct inode *);
> =A0extern int =A0ext4_sync_inode(handle_t *, struct inode *);
> =A0extern void ext4_dirty_inode(struct inode *);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 5313ae4..18c29ab 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -150,7 +150,7 @@ const struct file_operations ext4_file_operations=
 =3D {
> =A0const struct inode_operations ext4_file_inode_operations =3D {
> =A0 =A0 =A0 =A0.truncate =A0 =A0 =A0 =3D ext4_truncate,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> - =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_file_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 42272d6..f9a730a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5550,12 +5550,33 @@ err_out:
> =A0int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> =A0{
> - =A0 =A0 =A0 struct inode *inode;
> - =A0 =A0 =A0 unsigned long delalloc_blocks;
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
>
> - =A0 =A0 =A0 inode =3D dentry->d_inode;
> =A0 =A0 =A0 =A0generic_fillattr(inode, stat);
>
> + =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_BTIME;
> + =A0 =A0 =A0 stat->btime.tv_sec =3D EXT4_I(inode)->i_crtime.tv_sec;
> + =A0 =A0 =A0 stat->btime.tv_nsec =3D EXT4_I(inode)->i_crtime.tv_nsec=
;
> +
> + =A0 =A0 =A0 if (inode->i_ino !=3D EXT4_ROOT_INO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_GE=
N;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gen =3D inode->i_generation;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (S_ISDIR(inode->i_mode) || test_opt(inode->i_sb, I_V=
ERSION)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_DA=
TA_VERSION;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->data_version =3D inode->i_version=
;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> +{
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 unsigned long delalloc_blocks;
> +
> + =A0 =A0 =A0 ext4_getattr(mnt, dentry, stat);
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We can't update i_blocks if the block allocation is=
 delayed
> =A0 =A0 =A0 =A0 * otherwise in the case of system crash before the re=
al block
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a43e661..0f776c7 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2542,6 +2542,7 @@ const struct inode_operations ext4_dir_inode_op=
erations =3D {
> =A0 =A0 =A0 =A0.mknod =A0 =A0 =A0 =A0 =A0=3D ext4_mknod,
> =A0 =A0 =A0 =A0.rename =A0 =A0 =A0 =A0 =3D ext4_rename,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -2554,6 +2555,7 @@ const struct inode_operations ext4_dir_inode_op=
erations =3D {
>
> =A0const struct inode_operations ext4_special_inode_operations =3D {
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index ed9354a..d8fe7fb 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -35,6 +35,7 @@ const struct inode_operations ext4_symlink_inode_op=
erations =3D {
> =A0 =A0 =A0 =A0.follow_link =A0 =A0=3D page_follow_link_light,
> =A0 =A0 =A0 =A0.put_link =A0 =A0 =A0 =3D page_put_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -47,6 +48,7 @@ const struct inode_operations ext4_fast_symlink_ino=
de_operations =3D {
> =A0 =A0 =A0 =A0.readlink =A0 =A0 =A0 =3D generic_readlink,
> =A0 =A0 =A0 =A0.follow_link =A0 =A0=3D ext4_follow_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 099b351..8c6de96 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -495,11 +495,21 @@ void nfs_setattr_update_inode(struct inode *ino=
de, struct iattr *attr)
> =A0int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struc=
t kstat *stat)
> =A0{
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 unsigned force =3D stat->query_flags & AT_FORCE_ATTR_SY=
NC;
> =A0 =A0 =A0 =A0int need_atime =3D NFS_I(inode)->cache_validity & NFS_=
INO_INVALID_ATIME;
> =A0 =A0 =A0 =A0int err;
>
> - =A0 =A0 =A0 /* Flush out writes to the server in order to update c/=
mtime. =A0*/
> - =A0 =A0 =A0 if (S_ISREG(inode->i_mode)) {
> + =A0 =A0 =A0 if (NFS_SERVER(inode)->nfs_client->rpc_ops->version < 4=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->request_mask &=3D ~XSTAT_REQUEST_=
DATA_VERSION;
> +
> + =A0 =A0 =A0 /* Flush out writes to the server in order to update c/=
mtime
> + =A0 =A0 =A0 =A0* or data version if the user wants them */
> + =A0 =A0 =A0 if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME=
 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 XSTAT_REQUEST_CTIME |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 XSTAT_REQUEST_DATA_VERSION
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 )) &&
> + =A0 =A0 =A0 =A0 =A0 S_ISREG(inode->i_mode)
> + =A0 =A0 =A0 =A0 =A0 ) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D filemap_write_and_wait(inode->=
i_mapping);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> @@ -514,18 +524,30 @@ int nfs_getattr(struct vfsmount *mnt, struct de=
ntry *dentry, struct kstat *stat)
> =A0 =A0 =A0 =A0 * =A0- NFS never sets MS_NOATIME or MS_NODIRATIME so =
there is
> =A0 =A0 =A0 =A0 * =A0 =A0no point in checking those.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if ((mnt->mnt_flags & MNT_NOATIME) ||
> - =A0 =A0 =A0 =A0 =A0 ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(i=
node->i_mode)))
> + =A0 =A0 =A0 if (!(stat->request_mask & XSTAT_REQUEST_ATIME) ||
> + =A0 =A0 =A0 =A0 =A0 (mnt->mnt_flags & MNT_NOATIME) ||
> + =A0 =A0 =A0 =A0 =A0 ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(i=
node->i_mode)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0need_atime =3D 0;
>
> - =A0 =A0 =A0 if (need_atime)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D __nfs_revalidate_inode(NFS_SERV=
ER(inode), inode);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D nfs_revalidate_inode(NFS_SERVER=
(inode), inode);
> - =A0 =A0 =A0 if (!err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_fillattr(inode, stat);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->ino =3D nfs_compat_user_ino64(NFS=
_FILEID(inode));
> + =A0 =A0 =A0 if (force || stat->request_mask & (XSTAT_REQUEST__BASIC=
_STATS |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0XSTAT_REQUEST_DATA_VERSION)
> + =A0 =A0 =A0 =A0 =A0 ) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (force || need_atime)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D __nfs_revalidat=
e_inode(NFS_SERVER(inode), inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D nfs_revalidate_=
inode(NFS_SERVER(inode), inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 generic_fillattr(inode, stat);
> + =A0 =A0 =A0 stat->ino =3D nfs_compat_user_ino64(NFS_FILEID(inode));
> +
> + =A0 =A0 =A0 if (stat->request_mask & XSTAT_REQUEST_DATA_VERSION) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->data_version =3D NFS_I(inode)->ch=
ange_attr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_DA=
TA_VERSION;
> + =A0 =A0 =A0 }
> +
> =A0out:
> =A0 =A0 =A0 =A0return err;
> =A0}
> @@ -770,7 +792,7 @@ int nfs_revalidate_inode(struct nfs_server *serve=
r, struct inode *inode)
> =A0static int nfs_invalidate_mapping(struct inode *inode, struct addr=
ess_space *mapping)
> =A0{
> =A0 =A0 =A0 =A0struct nfs_inode *nfsi =3D NFS_I(inode);
> -
> +
> =A0 =A0 =A0 =A0if (mapping->nrpages !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ret =3D invalidate_inode_pages2(ma=
pping);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret < 0)
> diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
> index 3d68f45..310ff05 100644
> --- a/fs/nfsd/nfs3proc.c
> +++ b/fs/nfsd/nfs3proc.c
> @@ -55,6 +55,8 @@ nfsd3_proc_getattr(struct svc_rqst *rqstp, struct n=
fsd_fhandle =A0*argp,
> =A0 =A0 =A0 =A0if (nfserr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RETURN_STATUS(nfserr);
>
> + =A0 =A0 =A0 resp->stat.query_flags =3D 0;
> + =A0 =A0 =A0 resp->stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STA=
TS;
> =A0 =A0 =A0 =A0err =3D vfs_getattr(resp->fh.fh_export->ex_path.mnt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0resp->fh.fh_dentry=
, &resp->stat);
> =A0 =A0 =A0 =A0nfserr =3D nfserrno(err);
> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> index 2a533a0..eaa3c3b 100644
> --- a/fs/nfsd/nfs3xdr.c
> +++ b/fs/nfsd/nfs3xdr.c
> @@ -205,6 +205,8 @@ encode_post_op_attr(struct svc_rqst *rqstp, __be3=
2 *p, struct svc_fh *fhp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kstat stat;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat.query_flags =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat.request_mask =3D XSTAT_REQUEST__EX=
TENDED_STATS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D vfs_getattr(fhp->fh_export->ex=
_path.mnt, dentry, &stat);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*p++ =3D xdr_one; =A0 =
=A0 =A0 =A0 /* attributes follow */
> @@ -257,6 +259,8 @@ void fill_post_wcc(struct svc_fh *fhp)
> =A0 =A0 =A0 =A0if (fhp->fh_post_saved)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("nfsd: inode locked twice durin=
g operation.\n");
>
> + =A0 =A0 =A0 fhp->fh_post_attr.query_flags =3D 0;
> + =A0 =A0 =A0 fhp->fh_post_attr.request_mask =3D XSTAT_REQUEST__EXTEN=
DED_STATS;
> =A0 =A0 =A0 =A0err =3D vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->=
fh_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fhp->fh_post_attr);
> =A0 =A0 =A0 =A0fhp->fh_post_change =3D fhp->fh_dentry->d_inode->i_ver=
sion;
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index ac17a70..e9d1b59 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1769,6 +1769,8 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct s=
vc_export *exp,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 stat.query_flags =3D 0;
> + =A0 =A0 =A0 stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STATS;
> =A0 =A0 =A0 =A0err =3D vfs_getattr(exp->ex_path.mnt, dentry, &stat);
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_nfserr;
> @@ -2139,6 +2141,8 @@ out_acl:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (pa=
th.dentry !=3D path.mnt->mnt_root)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat.query_flags =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat.request_mask =3D X=
STAT_REQUEST__EXTENDED_STATS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D vfs_getattr(pa=
th.mnt, path.dentry, &stat);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path_put(&path);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
> index a047ad6..7c0e74b 100644
> --- a/fs/nfsd/nfsproc.c
> +++ b/fs/nfsd/nfsproc.c
> @@ -26,6 +26,8 @@ static __be32
> =A0nfsd_return_attrs(__be32 err, struct nfsd_attrstat *resp)
> =A0{
> =A0 =A0 =A0 =A0if (err) return err;
> + =A0 =A0 =A0 resp->stat.query_flags =3D 0;
> + =A0 =A0 =A0 resp->stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STA=
TS;
> =A0 =A0 =A0 =A0return nfserrno(vfs_getattr(resp->fh.fh_export->ex_pat=
h.mnt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
resp->fh.fh_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&resp->stat));
> @@ -34,6 +36,8 @@ static __be32
> =A0nfsd_return_dirop(__be32 err, struct nfsd_diropres *resp)
> =A0{
> =A0 =A0 =A0 =A0if (err) return err;
> + =A0 =A0 =A0 resp->stat.query_flags =3D 0;
> + =A0 =A0 =A0 resp->stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STA=
TS;
> =A0 =A0 =A0 =A0return nfserrno(vfs_getattr(resp->fh.fh_export->ex_pat=
h.mnt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
resp->fh.fh_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&resp->stat));
> @@ -150,6 +154,8 @@ nfsd_proc_read(struct svc_rqst *rqstp, struct nfs=
d_readargs *argp,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&r=
esp->count);
>
> =A0 =A0 =A0 =A0if (nfserr) return nfserr;
> + =A0 =A0 =A0 resp->stat.query_flags =3D 0;
> + =A0 =A0 =A0 resp->stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STA=
TS;
> =A0 =A0 =A0 =A0return nfserrno(vfs_getattr(resp->fh.fh_export->ex_pat=
h.mnt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
resp->fh.fh_dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&resp->stat));
> diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
> index 4ce005d..a595fb6 100644
> --- a/fs/nfsd/nfsxdr.c
> +++ b/fs/nfsd/nfsxdr.c
> @@ -197,6 +197,8 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, s=
truct svc_fh *fhp,
> =A0__be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, st=
ruct svc_fh *fhp)
> =A0{
> =A0 =A0 =A0 =A0struct kstat stat;
> + =A0 =A0 =A0 stat.query_flags =3D 0;
> + =A0 =A0 =A0 stat.request_mask =3D XSTAT_REQUEST__EXTENDED_STATS;
> =A0 =A0 =A0 =A0vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentr=
y, &stat);
> =A0 =A0 =A0 =A0return encode_fattr(rqstp, p, fhp, &stat);
> =A0}
> diff --git a/fs/stat.c b/fs/stat.c
> index 12e90e2..2fb1527 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -33,6 +33,9 @@ void generic_fillattr(struct inode *inode, struct k=
stat *stat)
> =A0 =A0 =A0 =A0stat->size =3D i_size_read(inode);
> =A0 =A0 =A0 =A0stat->blocks =3D inode->i_blocks;
> =A0 =A0 =A0 =A0stat->blksize =3D (1 << inode->i_blkbits);
> + =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST__BASIC_STATS & ~XS=
TAT_REQUEST_RDEV;
> + =A0 =A0 =A0 if (unlikely(S_ISBLK(stat->mode) || S_ISCHR(stat->mode)=
))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_REQUEST_RD=
EV;
> =A0}
>
> =A0EXPORT_SYMBOL(generic_fillattr);
> @@ -42,6 +45,8 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry=
 *dentry, struct kstat *stat)
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
> =A0 =A0 =A0 =A0int retval;
>
> + =A0 =A0 =A0 stat->result_mask =3D 0;
> +
> =A0 =A0 =A0 =A0retval =3D security_inode_getattr(mnt, dentry);
> =A0 =A0 =A0 =A0if (retval)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return retval;
> @@ -55,41 +60,64 @@ int vfs_getattr(struct vfsmount *mnt, struct dent=
ry *dentry, struct kstat *stat)
>
> =A0EXPORT_SYMBOL(vfs_getattr);
>
> -int vfs_fstat(unsigned int fd, struct kstat *stat)
> +/*
> + * VFS entrypoint to get extended stats by file descriptor
> + */
> +int vfs_fxstat(unsigned int fd, int flags, struct kstat *stat)
> =A0{
> =A0 =A0 =A0 =A0struct file *f =3D fget(fd);
> =A0 =A0 =A0 =A0int error =3D -EBADF;
>
> + =A0 =A0 =A0 if (flags & ~KSTAT_QUERY_FLAGS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 stat->query_flags =3D flags;
> +
> =A0 =A0 =A0 =A0if (f) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D vfs_getattr(f->f_path.mnt, f=
->f_path.dentry, stat);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fput(f);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return error;
> =A0}
> +EXPORT_SYMBOL(vfs_fxstat);
> +
> +int vfs_fstat(unsigned int fd, struct kstat *stat)
> +{
> + =A0 =A0 =A0 stat->request_mask =3D XSTAT_REQUEST__BASIC_STATS;
> + =A0 =A0 =A0 return vfs_fxstat(fd, 0, stat);
> +}
> =A0EXPORT_SYMBOL(vfs_fstat);
>
> -int vfs_fstatat(int dfd, const char __user *filename, struct kstat *=
stat,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int flag)
> +/*
> + * VFS entrypoint to get extended stats by filename
> + */
> +int vfs_xstat(int dfd, const char __user *filename, int flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> =A0{
> =A0 =A0 =A0 =A0struct path path;
> - =A0 =A0 =A0 int error =3D -EINVAL;
> - =A0 =A0 =A0 int lookup_flags =3D 0;
> + =A0 =A0 =A0 int error, lookup_flags;
>
> - =A0 =A0 =A0 if ((flag & ~AT_SYMLINK_NOFOLLOW) !=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 if (flags & ~(AT_SYMLINK_NOFOLLOW | KSTAT_QUERY_FLAGS))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 if (!(flag & AT_SYMLINK_NOFOLLOW))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lookup_flags |=3D LOOKUP_FOLLOW;
> + =A0 =A0 =A0 stat->query_flags =3D flags;
> + =A0 =A0 =A0 lookup_flags =3D (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LO=
OKUP_FOLLOW;
>
> =A0 =A0 =A0 =A0error =3D user_path_at(dfd, filename, lookup_flags, &p=
ath);
> - =A0 =A0 =A0 if (error)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> -
> - =A0 =A0 =A0 error =3D vfs_getattr(path.mnt, path.dentry, stat);
> - =A0 =A0 =A0 path_put(&path);
> -out:
> + =A0 =A0 =A0 if (!error) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D vfs_getattr(path.mnt, path.de=
ntry, stat);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_put(&path);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return error;
> =A0}
> +EXPORT_SYMBOL(vfs_xstat);
> +
> +int vfs_fstatat(int dfd, const char __user *filename, struct kstat *=
stat,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int flags)
> +{
> + =A0 =A0 =A0 stat->request_mask =3D XSTAT_REQUEST__BASIC_STATS;
> + =A0 =A0 =A0 stat->query_flags =3D 0;
> + =A0 =A0 =A0 return vfs_xstat(dfd, filename, flags, stat);
> +}
> =A0EXPORT_SYMBOL(vfs_fstatat);
>
> =A0int vfs_stat(const char __user *name, struct kstat *stat)
> @@ -115,7 +143,7 @@ static int cp_old_stat(struct kstat *stat, struct=
 __old_kernel_stat __user * sta
> =A0{
> =A0 =A0 =A0 =A0static int warncount =3D 5;
> =A0 =A0 =A0 =A0struct __old_kernel_stat tmp;
> -
> +
> =A0 =A0 =A0 =A0if (warncount > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0warncount--;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_WARNING "VFS: Warning: %s =
using old stat() call. Recompile your binary.\n",
> @@ -140,7 +168,7 @@ static int cp_old_stat(struct kstat *stat, struct=
 __old_kernel_stat __user * sta
> =A0#if BITS_PER_LONG =3D=3D 32
> =A0 =A0 =A0 =A0if (stat->size > MAX_NON_LFS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EOVERFLOW;
> -#endif
> +#endif
> =A0 =A0 =A0 =A0tmp.st_size =3D stat->size;
> =A0 =A0 =A0 =A0tmp.st_atime =3D stat->atime.tv_sec;
> =A0 =A0 =A0 =A0tmp.st_mtime =3D stat->mtime.tv_sec;
> @@ -222,7 +250,7 @@ static int cp_new_stat(struct kstat *stat, struct=
 stat __user *statbuf)
> =A0#if BITS_PER_LONG =3D=3D 32
> =A0 =A0 =A0 =A0if (stat->size > MAX_NON_LFS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EOVERFLOW;
> -#endif
> +#endif
> =A0 =A0 =A0 =A0tmp.st_size =3D stat->size;
> =A0 =A0 =A0 =A0tmp.st_atime =3D stat->atime.tv_sec;
> =A0 =A0 =A0 =A0tmp.st_mtime =3D stat->mtime.tv_sec;
> @@ -408,6 +436,117 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char=
 __user *, filename,
> =A0}
> =A0#endif /* __ARCH_WANT_STAT64 */
>
> +/*
> + * Get the xstat parameters if supplied
> + */
> +static int xstat_get_params(struct xstat_parameters __user *_params,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *s=
tat)
> +{
> + =A0 =A0 =A0 struct xstat_parameters params;
> +
> + =A0 =A0 =A0 memset(stat, 0xde, sizeof(*stat)); =A0 =A0 =A0// DEBUGG=
ING
> +
> + =A0 =A0 =A0 if (_params) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copy_from_user(&params, _params, si=
zeof(params)) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->request_mask =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 params.request_mask & X=
STAT_REQUEST__ALL_STATS;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->request_mask =3D XSTAT_REQUEST__E=
XTENDED_STATS;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 stat->result_mask =3D 0;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/*
> + * copy the extended stats to userspace and return the amount of dat=
a written
> + * into the buffer
> + */
> +static long xstat_set_result(struct kstat *stat,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat=
 __user *buffer, size_t bufsize)
> +{
> + =A0 =A0 =A0 struct xstat tmp;
> + =A0 =A0 =A0 size_t copy;
> +
> + =A0 =A0 =A0 /* transfer the fixed results */
> + =A0 =A0 =A0 memset(&tmp, 0, sizeof(tmp));
> + =A0 =A0 =A0 tmp.st_result_mask =A0 =A0 =A0=3D stat->result_mask;
> + =A0 =A0 =A0 tmp.st_mode =A0 =A0 =A0 =A0 =A0 =A0 =3D stat->mode;
> + =A0 =A0 =A0 tmp.st_nlink =A0 =A0 =A0 =A0 =A0 =A0=3D stat->nlink;
> + =A0 =A0 =A0 tmp.st_uid =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D stat->uid;
> + =A0 =A0 =A0 tmp.st_gid =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D stat->gid;
> + =A0 =A0 =A0 tmp.st_blksize =A0 =A0 =A0 =A0 =A0=3D stat->blksize;
> + =A0 =A0 =A0 tmp.st_rdev.major =A0 =A0 =A0 =3D MAJOR(stat->rdev);
> + =A0 =A0 =A0 tmp.st_rdev.minor =A0 =A0 =A0 =3D MINOR(stat->rdev);
> + =A0 =A0 =A0 tmp.st_dev.major =A0 =A0 =A0 =A0=3D MAJOR(stat->dev);
> + =A0 =A0 =A0 tmp.st_dev.minor =A0 =A0 =A0 =A0=3D MINOR(stat->dev);
> + =A0 =A0 =A0 tmp.st_atime.tv_sec =A0 =A0 =3D stat->atime.tv_sec;
> + =A0 =A0 =A0 tmp.st_atime.tv_nsec =A0 =A0=3D stat->atime.tv_nsec;
> + =A0 =A0 =A0 tmp.st_mtime.tv_sec =A0 =A0 =3D stat->mtime.tv_sec;
> + =A0 =A0 =A0 tmp.st_mtime.tv_nsec =A0 =A0=3D stat->mtime.tv_nsec;
> + =A0 =A0 =A0 tmp.st_ctime.tv_sec =A0 =A0 =3D stat->ctime.tv_sec;
> + =A0 =A0 =A0 tmp.st_ctime.tv_nsec =A0 =A0=3D stat->ctime.tv_nsec;
> + =A0 =A0 =A0 tmp.st_ino =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D stat->ino;
> + =A0 =A0 =A0 tmp.st_size =A0 =A0 =A0 =A0 =A0 =A0 =3D stat->size;
> + =A0 =A0 =A0 tmp.st_blocks =A0 =A0 =A0 =A0 =A0 =3D stat->blocks;
> +
> + =A0 =A0 =A0 if (tmp.st_result_mask & XSTAT_REQUEST_BTIME) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp.st_btime.tv_sec =A0 =A0 =3D stat->b=
time.tv_sec;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp.st_btime.tv_nsec =A0 =A0=3D stat->b=
time.tv_nsec;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (tmp.st_result_mask & XSTAT_REQUEST_GEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp.st_gen =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 stat->gen;
> + =A0 =A0 =A0 if (tmp.st_result_mask & XSTAT_REQUEST_DATA_VERSION)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp.st_data_version =A0 =A0 =3D stat->d=
ata_version;
> +
> + =A0 =A0 =A0 copy =3D sizeof(tmp);
> + =A0 =A0 =A0 if (copy > bufsize)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 copy =3D bufsize;
> + =A0 =A0 =A0 if (copy_to_user(buffer, &tmp, copy) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EFAULT;
> + =A0 =A0 =A0 return sizeof(tmp);
> +}
> +
> +/*
> + * System call to get extended stats by path
> + */
> +SYSCALL_DEFINE6(xstat,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int, dfd, const char __user *, filename=
, unsigned, atflag,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat_parameters __user *, param=
s,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat __user *, buffer, size_t, =
bufsize)
> +{
> + =A0 =A0 =A0 struct kstat stat;
> + =A0 =A0 =A0 int error;
> +
> + =A0 =A0 =A0 error =3D xstat_get_params(params, &stat);
> + =A0 =A0 =A0 if (error !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
> + =A0 =A0 =A0 error =3D vfs_xstat(dfd, filename, atflag, &stat);
> + =A0 =A0 =A0 if (error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
> + =A0 =A0 =A0 return xstat_set_result(&stat, buffer, bufsize);
> +}
> +
> +/*
> + * System call to get extended stats by file descriptor
> + */
> +SYSCALL_DEFINE5(fxstat, unsigned int, fd, unsigned int, flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat_parameters __user *, param=
s,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat __user *, buffer, size_t, =
bufsize)
> +{
> + =A0 =A0 =A0 struct kstat stat;
> + =A0 =A0 =A0 int error;
> +
> + =A0 =A0 =A0 error =3D xstat_get_params(params, &stat);
> + =A0 =A0 =A0 if (error < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
> + =A0 =A0 =A0 error =3D vfs_fxstat(fd, flags, &stat);
> + =A0 =A0 =A0 if (error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
> +
> + =A0 =A0 =A0 return xstat_set_result(&stat, buffer, bufsize);
> +}
> +
> =A0/* Caller is here responsible for sufficient locking (ie. inode->i=
_lock) */
> =A0void __inode_add_bytes(struct inode *inode, loff_t bytes)
> =A0{
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index afc00af..bcf8083 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -45,6 +45,7 @@
> =A0#define AT_REMOVEDIR =A0 =A0 =A0 =A0 =A0 0x200 =A0 /* Remove direc=
tory instead of
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0unlinking file. =A0*/
> =A0#define AT_SYMLINK_FOLLOW =A0 =A0 =A00x400 =A0 /* Follow symbolic =
links. =A0*/
> +#define AT_FORCE_ATTR_SYNC =A0 =A0 0x800 =A0 /* Force the attributes=
 to be sync'd with the server */
>
> =A0#ifdef __KERNEL__
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a18bcea..9ce2119 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2343,6 +2343,8 @@ extern int vfs_stat(const char __user *, struct=
 kstat *);
> =A0extern int vfs_lstat(const char __user *, struct kstat *);
> =A0extern int vfs_fstat(unsigned int, struct kstat *);
> =A0extern int vfs_fstatat(int , const char __user *, struct kstat *, =
int);
> +extern int vfs_xstat(int, const char __user *, int, struct kstat *);
> +extern int vfs_xfstat(unsigned int, struct kstat *);
>
> =A0extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsign=
ed int cmd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long arg);
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 611c398..e0b89e4 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -46,6 +46,99 @@
>
> =A0#endif
>
> +/*
> + * Extended stat structures
> + */
> +struct xstat_parameters {
> + =A0 =A0 =A0 /* Query request/result mask
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Bits should be set in request_mask to request part=
icular items
> + =A0 =A0 =A0 =A0* before calling xstat() or fxstat().
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* For each item in the set XSTAT_REQUEST__EXTENDED_S=
TATS:
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if not available at all, the bit will be cleared=
 before returning
> + =A0 =A0 =A0 =A0* =A0 and the field will be cleared; otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if AT_FORCE_ATTR_SYNC is set, then the datum wil=
l be synchronised
> + =A0 =A0 =A0 =A0* =A0 to the server and the bit will be set on retur=
n; otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if requested, the datum will be synchronised to =
a server or other
> + =A0 =A0 =A0 =A0* =A0 hardware if out of date before being returned,=
 and the bit will be
> + =A0 =A0 =A0 =A0* =A0 set on return; otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if not requested, but available in approximate f=
orm without any
> + =A0 =A0 =A0 =A0* =A0 effort, it will be filled in anyway, and the b=
it will be set upon
> + =A0 =A0 =A0 =A0* =A0 return (it might not be up to date, however, a=
nd no attempt will
> + =A0 =A0 =A0 =A0* =A0 be made to synchronise the internal state firs=
t); otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - the bit will be cleared before returning, and th=
e field will be
> + =A0 =A0 =A0 =A0 * =A0 cleared.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* For each item not in the set XSTAT_REQUEST__EXTEND=
ED_STATS
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if not available at all, the bit will be cleared=
, and no result
> + =A0 =A0 =A0 =A0 * =A0 data will be returned; otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - if requested, the datum will be synchronised to =
a server or other
> + =A0 =A0 =A0 =A0* =A0 hardware before being appended if necessary, a=
nd the bit will be
> + =A0 =A0 =A0 =A0* =A0 set on return; otherwise,
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* - the bit will be cleared, and no result data will=
 be returned.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Items in XSTAT_REQUEST__BASIC_STATS may be marked =
unavailable on
> + =A0 =A0 =A0 =A0* return, but they will have a value installed for c=
ompatibility
> + =A0 =A0 =A0 =A0* purposes.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0request_mask;
> +#define XSTAT_REQUEST_MODE =A0 =A0 =A0 =A0 =A0 =A0 0x00000001ULL =A0=
 /* want/got st_mode */
> +#define XSTAT_REQUEST_NLINK =A0 =A0 =A0 =A0 =A0 =A00x00000002ULL =A0=
 /* want/got st_nlink */
> +#define XSTAT_REQUEST_UID =A0 =A0 =A0 =A0 =A0 =A0 =A00x00000004ULL =A0=
 /* want/got st_uid */
> +#define XSTAT_REQUEST_GID =A0 =A0 =A0 =A0 =A0 =A0 =A00x00000008ULL =A0=
 /* want/got st_gid */
> +#define XSTAT_REQUEST_RDEV =A0 =A0 =A0 =A0 =A0 =A0 0x00000010ULL =A0=
 /* want/got st_rdev */
> +#define XSTAT_REQUEST_ATIME =A0 =A0 =A0 =A0 =A0 =A00x00000020ULL =A0=
 /* want/got st_atime */
> +#define XSTAT_REQUEST_MTIME =A0 =A0 =A0 =A0 =A0 =A00x00000040ULL =A0=
 /* want/got st_mtime */
> +#define XSTAT_REQUEST_CTIME =A0 =A0 =A0 =A0 =A0 =A00x00000080ULL =A0=
 /* want/got st_ctime */
> +#define XSTAT_REQUEST_INO =A0 =A0 =A0 =A0 =A0 =A0 =A00x00000100ULL =A0=
 /* want/got st_ino */
> +#define XSTAT_REQUEST_SIZE =A0 =A0 =A0 =A0 =A0 =A0 0x00000200ULL =A0=
 /* want/got st_size */
> +#define XSTAT_REQUEST_BLOCKS =A0 =A0 =A0 =A0 =A0 0x00000400ULL =A0 /=
* want/got st_blocks */
> +#define XSTAT_REQUEST__BASIC_STATS =A0 =A0 0x000007ffULL =A0 /* the =
stuff in the normal stat struct */
> +#define XSTAT_REQUEST_BTIME =A0 =A0 =A0 =A0 =A0 =A00x00000800ULL =A0=
 /* want/got st_btime */
> +#define XSTAT_REQUEST_GEN =A0 =A0 =A0 =A0 =A0 =A0 =A00x00001000ULL =A0=
 /* want/got st_gen */
> +#define XSTAT_REQUEST_DATA_VERSION =A0 =A0 0x00002000ULL =A0 /* want=
/got st_data_version */
> +#define XSTAT_REQUEST__EXTENDED_STATS =A00x00003fffULL =A0 /* the st=
uff in the xstat struct */
> +#define XSTAT_REQUEST__ALL_STATS =A0 =A0 =A0 0x00003fffULL =A0 /* th=
e defined set of requestables */
> +};
> +
> +struct xstat_dev {
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0major, minor;
> +};
> +
> +struct xstat_time {
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0tv_sec, tv_nsec;
> +};
> +
> +struct xstat {
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0st_mode; =A0 =A0 =A0=
 =A0/* file mode */
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0st_nlink; =A0 =A0 =A0=
 /* number of hard links */
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0st_uid; =A0 =A0 =A0=
 =A0 /* user ID of owner */
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0st_gid; =A0 =A0 =A0=
 =A0 /* group ID of owner */
> + =A0 =A0 =A0 struct xstat_dev =A0 =A0 =A0 =A0st_rdev; =A0 =A0 =A0 =A0=
/* device ID of special file */
> + =A0 =A0 =A0 struct xstat_dev =A0 =A0 =A0 =A0st_dev; =A0 =A0 =A0 =A0=
 /* ID of device containing file */
> + =A0 =A0 =A0 struct xstat_time =A0 =A0 =A0 st_atime; =A0 =A0 =A0 /* =
last access time */
> + =A0 =A0 =A0 struct xstat_time =A0 =A0 =A0 st_mtime; =A0 =A0 =A0 /* =
last data modification time */
> + =A0 =A0 =A0 struct xstat_time =A0 =A0 =A0 st_ctime; =A0 =A0 =A0 /* =
last attribute change time */
> + =A0 =A0 =A0 struct xstat_time =A0 =A0 =A0 st_btime; =A0 =A0 =A0 /* =
file creation time */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_ino; =A0 =A0 =A0 =A0 /=
* inode number */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_size; =A0 =A0 =A0 =A0/=
* file size */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_blksize; =A0 =A0 /* bl=
ock size for filesystem I/O */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_blocks; =A0 =A0 =A0/* =
number of 512-byte blocks allocated */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_gen; =A0 =A0 =A0 =A0 /=
* inode generation number */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_data_version; /* data =
version number */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_result_mask; /* what r=
equests were written */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_extra_results[0]; /* e=
xtra requested results */
> +};
> +
> =A0#ifdef __KERNEL__
> =A0#define S_IRWXUGO =A0 =A0 =A0(S_IRWXU|S_IRWXG|S_IRWXO)
> =A0#define S_IALLUGO =A0 =A0 =A0(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
> @@ -67,14 +160,20 @@ struct kstat {
> =A0 =A0 =A0 =A0uid_t =A0 =A0 =A0 =A0 =A0 uid;
> =A0 =A0 =A0 =A0gid_t =A0 =A0 =A0 =A0 =A0 gid;
> =A0 =A0 =A0 =A0dev_t =A0 =A0 =A0 =A0 =A0 rdev;
> + =A0 =A0 =A0 unsigned int =A0 =A0query_flags; =A0 =A0 =A0 =A0 =A0 =A0=
/* operational flags */
> +#define KSTAT_QUERY_FLAGS (AT_FORCE_ATTR_SYNC)
> =A0 =A0 =A0 =A0loff_t =A0 =A0 =A0 =A0 =A0size;
> - =A0 =A0 =A0 struct timespec =A0atime;
> + =A0 =A0 =A0 struct timespec atime;
> =A0 =A0 =A0 =A0struct timespec mtime;
> =A0 =A0 =A0 =A0struct timespec ctime;
> + =A0 =A0 =A0 struct timespec btime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0/* file creation time */
> =A0 =A0 =A0 =A0unsigned long =A0 blksize;
> =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0blocks;
> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 request_mask; =A0 =A0 =A0 =A0=
 =A0 /* what fields the user asked for */
> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 result_mask; =A0 =A0 =A0 =A0=
 =A0 =A0/* what fields the user got */
> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 gen; =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0/* inode generation */
> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 data_version;
> =A0};
>
> =A0#endif
> -
> =A0#endif
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 8812a63..5d68b4c 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -44,6 +44,8 @@ struct shmid_ds;
> =A0struct sockaddr;
> =A0struct stat;
> =A0struct stat64;
> +struct xstat_parameters;
> +struct xstat;
> =A0struct statfs;
> =A0struct statfs64;
> =A0struct __sysctl_args;
> @@ -824,4 +826,11 @@ asmlinkage long sys_mmap_pgoff(unsigned long add=
r, unsigned long len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long fd, unsi=
gned long pgoff);
> =A0asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
>
> +asmlinkage long sys_xstat(int, const char __user *, unsigned,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat_parame=
ters __user *,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xstat __user=
 *, size_t);
> +asmlinkage long sys_fxstat(unsigned, unsigned,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_par=
ameters __user *,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat __u=
ser *, size_t);
> +
> =A0#endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
