From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Wed, 9 May 2018 11:15:46 -0600
Message-ID: <E100AC43-CB61-4E90-B605-4E1B77AD3268@dilger.ca>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
 <20180509161043.GF4116@magnolia>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8FD6C067-9963-484E-9E91-336B4A9CC414";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180509161043.GF4116@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_8FD6C067-9963-484E-9E91-336B4A9CC414
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 9, 2018, at 10:10 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, May 09, 2018 at 11:01:21AM -0500, Eric Sandeen wrote:
>> Move the btrfs label ioctls up to the vfs for general use.
>>=20
>> This retains 256 chars as the maximum size through the interface, =
which
>> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
>> label size.
>>=20
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>=20
>> Let the bikeshedding on the exact ioctl name begin ;)
>>=20
>> fs/btrfs/ioctl.c           | 8 ++++----
>> include/uapi/linux/btrfs.h | 6 ++----
>> include/uapi/linux/fs.h    | 8 ++++++--
>> 3 files changed, 12 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 632e26d..2dd4cdf 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -5444,6 +5444,10 @@ long btrfs_ioctl(struct file *file, unsigned =
int
>> 		return btrfs_ioctl_setflags(file, argp);
>> 	case FS_IOC_GETVERSION:
>> 		return btrfs_ioctl_getversion(file, argp);
>> +	case FS_IOC_GETFSLABEL:
>> +		return btrfs_ioctl_get_fslabel(file, argp);
>> +	case FS_IOC_SETFSLABEL:
>> +		return btrfs_ioctl_set_fslabel(file, argp);
>> 	case FITRIM:
>> 		return btrfs_ioctl_fitrim(file, argp);
>> 	case BTRFS_IOC_SNAP_CREATE:
>> @@ -5555,10 +5559,6 @@ long btrfs_ioctl(struct file *file, unsigned =
int
>> 		return btrfs_ioctl_quota_rescan_wait(file, argp);
>> 	case BTRFS_IOC_DEV_REPLACE:
>> 		return btrfs_ioctl_dev_replace(fs_info, argp);
>> -	case BTRFS_IOC_GET_FSLABEL:
>> -		return btrfs_ioctl_get_fslabel(file, argp);
>> -	case BTRFS_IOC_SET_FSLABEL:
>> -		return btrfs_ioctl_set_fslabel(file, argp);
>> 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>> 		return btrfs_ioctl_get_supported_features(argp);
>> 	case BTRFS_IOC_GET_FEATURES:
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index c8d99b9..ec611c8 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -823,10 +823,8 @@ enum btrfs_err_code {
>> #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>> 			       struct btrfs_ioctl_quota_rescan_args)
>> #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
>> -#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>> -				   char[BTRFS_LABEL_SIZE])
>> -#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
>> -				   char[BTRFS_LABEL_SIZE])
>> +#define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
>> +#define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
>> #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>> 				      struct btrfs_ioctl_get_dev_stats)
>> #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index d2a8313..1df3707 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -242,6 +242,8 @@ struct fsxattr {
>> #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
>> #define FIDEDUPERANGE	_IOWR(0x94, 54, struct =
file_dedupe_range)
>>=20
>> +#define FSLABEL_MAX 256	/* Max chars for the interface; each fs =
may differ */
>> +
>> #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>> #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
>> #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
>> @@ -251,8 +253,10 @@ struct fsxattr {
>> #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
>> #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
>> #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
>> -#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
>> -#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
>> +#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
>> +#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
>=20
> Separate patch for whitespace cleanup.

Really?  I've heard Ted complain the other way, that whitespace cleanup
by itself is useless and should only be done as part of other changes.
As long as it is not overwhelming the rest of the patch I don't see an
issue with a minor improvement being part of another patch.

Otherwise, no bikeshedding from me.  Looks very reasonable, and the =
256-char
limit is definitely large enough IMHO (also matches the normal filename =
size
limit, so if the label is used as a pathname component there are no =
added
restrictions).

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas

>> +#define FS_IOC_GETFSLABEL		_IOR(0x94, 49, =
char[FSLABEL_MAX])
>> +#define FS_IOC_SETFSLABEL		_IOW(0x94, 50, =
char[FSLABEL_MAX])
>=20
> Looks ok otherwise,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> --D
>=20
>>=20
>> /*
>>  * File system encryption support
>> --
>> 1.8.3.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-api" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_8FD6C067-9963-484E-9E91-336B4A9CC414
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrzLMIACgkQcqXauRfM
H+CQUg/+I4szpo5AiLf40phI7xZRCqg6Krjg6yVKDXU69pCgP03ivFWWInaPNMCw
AcBwPOf3OSbqckDquZ0zXKRRwPPKluj2QetuVcHunKFiTZ/3AATrbxS3DeWn0WFI
eAezZVYKEKb3/rrdezzWEA8EUCy/gCS0yV2hq/6EEtL2eZizEi3gU1qMPks9tOe0
xgesRqFwfiOM1Bl2netL+2t7wWMQCA6dbqZVCgjYDuLV2eKk24DXKswp/GgjafW6
z8AAsnBK9IXT9/w8RZl/OotfHeRL/B7+wcDATzkez99KOo7ZhuQ9RiIc6nPbcl4p
vgTRcbuw+7NDe97xtBLbuQPHGlAyzONgZvWE1mCfbMtrZUJi62xbKJvb14Erqes7
tv9Fg86w0jRJGE+zuOTNEUNH8RCM+SLS3SO/JcdxsYL7LtJTkriLaUoMEKJtI8VJ
JMx289aSnXFb0W6aJI+SlA8uRNh6dqZWYUecoJvdkqUqiREtfKRCVs4tqRM6585e
RMwPqBpYtaC3cYNC4vGJe8IMgp9KduYA7GfFZWaKrKZpvTJOrIZJPVcFZrqKyiDv
EMrFGHnsf/2UZMbSvj/VF8c9h9DxmucdVDUWUfzFVU7PAtt3gk6WD2pnsgDMtmST
3xRjLdg2jFUvUC1KWCIWaop5pCccTGm1VCR/mAZHGLFNvUcWdwI=
=6ghz
-----END PGP SIGNATURE-----

--Apple-Mail=_8FD6C067-9963-484E-9E91-336B4A9CC414--
