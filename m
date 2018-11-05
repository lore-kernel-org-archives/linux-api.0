From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 5/5] nfs: don't clear STATX_ATIME from result_mask
Date: Mon, 5 Nov 2018 15:29:02 -0700
Message-ID: <6E9E333D-CD57-4EDB-A55F-CD79DF9E2811@dilger.ca>
References: <20181019122049.27121-1-mszeredi@redhat.com>
 <20181019122049.27121-5-mszeredi@redhat.com>
 <2ca365ec330cf918188e8c47b26e741073382d9d.camel@primarydata.com>
 <CAJfpegtq1+vZ+uXwzFs20GeSPCR9UbtqD5-fOn8ynoJUJYx25g@mail.gmail.com>
 <05184f29b5778563519174769c675c5f6c5b2dd3.camel@hammerspace.com>
 <CAJfpeguFe=KcahJmZire52TPppMk8amiTJFiBZuv=97bRbCj8g@mail.gmail.com>
 <fbc3501c07fd48e65c0ffc8634870bf57a6f7fe1.camel@hammerspace.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A3D1DE8D-EBD7-45B5-AD6A-BDCAD24D6C1F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fbc3501c07fd48e65c0ffc8634870bf57a6f7fe1.camel@hammerspace.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "mszeredi@redhat.com" <mszeredi@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "fw@deneb.enyo.de" <fw@deneb.enyo.de>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_A3D1DE8D-EBD7-45B5-AD6A-BDCAD24D6C1F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 20, 2018, at 11:46 AM, Trond Myklebust <trondmy@hammerspace.com> =
wrote:
>=20
> On Fri, 2018-10-19 at 22:48 +0200, Miklos Szeredi wrote:
>> On Fri, Oct 19, 2018 at 8:14 PM, Trond Myklebust
>> <trondmy@hammerspace.com> wrote:
>>> On Fri, 2018-10-19 at 19:46 +0200, Miklos Szeredi wrote:
>>>> How is it then that only STATX_ATIME is cleared and not the other
>>>> fields?
>>>=20
>>> It isn't just the atime. We can also fail to revalidate the ctime
>>> and mtime if they are not being requested by the user.
>>>=20
>>>> Note: junk !=3D stale.  The statx definition doesn't talk about the
>>>> fields being up-to-date, except for AT_STATX_FORCE_SYNC, so stale
>>>> attributes are okay, and do not warrant clearing the result_mask.
>>>=20
>>> I disagree. stale =3D=3D junk here, because the default of
>>> AT_STATX_SYNC_AS_STAT is described by the manpage as "Do whatever
>>> stat(2) does." which this is not.
>>=20
>> Ah, you are talking about this:
>>=20
>>  /* Is the user requesting attributes that might need revalidation? =
*/
>>  if (!(request_mask & =
(STATX_MODE|STATX_NLINK|STATX_ATIME|STATX_CTIME|
>>                    STATX_MTIME|STATX_UID|STATX_GID|
>>                    STATX_SIZE|STATX_BLOCKS)))
>>        goto out_no_update;
>>=20
>> Well, if this is triggered for statx(...,  STATX_ATIME,
>> AT_STATX_SYNC_AS_STAT) and MNT_NOATIME, then yes, result will be
>> junk. Which means that the code is wrong, it shouldn't do that.
>=20
> The problem is that vfs_getattr_nosec() populates stat->result_mask
> with a default of STATX_BASIC_STATS, which makes no sense unless you
> assume that the user will always ask for a superset of
> STATX_BASIC_STATS (or you assume that those attributes never need
> revalidation, which is obviously braindead).

I guess the assumption in the VFS code is that statx is mostly called
by local filesystems, for which STATX_BASIC_STATS is usually right,
so the basic VFS helper is OK to set those stats.  It should also be
possible for the filesystem to clear flags out of result_mask for
attributes that it doesn't want to return.

For filesystems that know what they are doing, it might just be best
to always clear stat->result_mask and fill in what they want, based
on the available attributes and request_mask rather than assuming
something is set by the caller.

Cheers, Andreas

>> Otherwise (if something other than STATX_ATIME or STATX_INO or
>> STATX_TYPE is given as well) it *will* do the same thing as what
>> stat(2) does, so in that case STATX_ATIME should not  be cleared (yet
>> it is cleared).
>=20
> As far as I'm concerned, we can definitely get rid of the
>=20
>        /*
>         * We may force a getattr if the user cares about atime.
>         *
>         * Note that we only have to check the vfsmount flags here:
>         *  - NFS always sets S_NOATIME by so checking it would give a
>         *    bogus result
>         *  - NFS never sets SB_NOATIME or SB_NODIRATIME so there is
>         *    no point in checking those.
>         */
>        if ((path->mnt->mnt_flags & MNT_NOATIME) ||
>            ((path->mnt->mnt_flags & MNT_NODIRATIME) && =
S_ISDIR(inode->i_mode)))
>                request_mask &=3D ~STATX_ATIME;
>=20
>=20
> however the rest needs to stay, or there is no way we can use statx()
> to allow optimised retrieval of only those attributes that your
> application cares about.


Cheers, Andreas






--Apple-Mail=_A3D1DE8D-EBD7-45B5-AD6A-BDCAD24D6C1F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvgxC8ACgkQcqXauRfM
H+DhlA/8DfrhlinN2C5XAwZltrRk/RhipSbv/YqBj6u2eTqVaL4y5B4BMlrUjtNc
LQ1cB51KKRQg8gqmVvAdxMXaWyctrHXlbVR9u44dYweCD48lsxzxJX+LnsJRF72J
Bk5QMXenxhQDuS+B8x/vI63/ReC995hq8/jlvs2w1CLZM2wnzUl4PqOwXkXO5cDt
3XniAVAbJ1Io9ESBPKwrztQ3LDraBR7Y3zcNI9n5UQrIxc2qoZGZso8vKs1j4DiU
TzOTIM+8qffNd6ZPPaOkbTHEkHlNXIlEjoNNxEecEF7YmtcgOq6RwstiiWqVB8kn
OHjhNjgjnhX591RCnlQkhacYbmA4NMKjlOYzUD5ie74Dv//XO/hDkbgROVrEzF30
ics3MQnvCzYkL4e+7Sj0OJigImS+lmjfSOartBjwHqCGC8pm5JE+32ojSYqSwPjG
BeadvZcMUimFIMv5StSjASa3u8/0h8x9S9vdmhi0BVpa0xYuBefF/pYyBFiXVGM/
w9i8XMiVxu3uX/oWzBA0/wEdiNHqV3whVyjcCGPT2k/u69G58I3V2GBkU90iIsme
k9Xmm5Ui7e/qF7SjG9cpg2OwTZsrPbquYKDKeU6QWAaizp5TwyctTxbdo6rI7yG0
YI6A1m2HCt5Y/qgtCfvHcPHOCduchZbnYT9dovJLMpSlCnZdPOQ=
=fMRQ
-----END PGP SIGNATURE-----

--Apple-Mail=_A3D1DE8D-EBD7-45B5-AD6A-BDCAD24D6C1F--
