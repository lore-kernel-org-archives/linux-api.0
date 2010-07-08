From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats
	available [ver #3]
Date: Thu, 8 Jul 2010 21:44:09 +0200
Message-ID: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi David,

A couple of comments below.

On Thu, Jul 1, 2010 at 1:36 AM, David Howells <dhowells@redhat.com> wro=
te:
> Add a pair of system calls to make extended file stats available, inc=
luding
> file creation time, inode version and data version where available th=
rough the
> underlying filesystem.
>
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

Poor name, since it's a value-result arg? Better maybe something like
"field_mask"?

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

There is no XSTAT_REQUEST__GET_ANYWAY, AFAICS. I guess here you meant
XSTAT_REQUEST__EXTENDED_STATS? Or?


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

This case is almost certainly a user error, so why not simply return
an error (-1 and ERANGE or E2BIG)? The above approach invites
userspace errors of the form:

if (xtat(...) < 0) { /* How users often check for error */
    /* I'll handle the error */
} else {
    /* The call succeeded; I'm fine */
}

Instead, more complex error-handling is required for *every* call:

ret =3D xstat(..., buflen);
if (ret < 0 || ret > buflen)
    /* I'll handle the error */
} else {
    /* The call succeeded; I'm fine */
}

If you are looking for a way to inform the user about the required
buffer size, I think it would be better to take a leaf from the
getxattr(2) book: if 'buflen' is zero, then do nothing with the output
arg, but return the size that would be required.

Cheers,

Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
