From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: statx(2) API and documentation
Date: Wed, 17 Oct 2018 12:45:43 -0600
Message-ID: <006890C4-64D4-4DE2-A1F0-335FFFD585BB@dilger.ca>
References: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AE0B5849-9F29-4FFB-A808-0809BDB00948";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsxFUGeczcC-pzK0WWROjv48_PvXtNun-f5QJMoUDn1Dw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, David Howells <dhowells@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_AE0B5849-9F29-4FFB-A808-0809BDB00948
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 17, 2018, at 12:24 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> I'm trying to implement statx for fuse and ran into the following issues:
> 
> - Need a STATX_ATTRIBUTES bit, so that userspace can explicitly ask
> for stx_attribute; otherwise if querying has non-zero cost, then
> filesystem cannot do it without regressing performance.

Seems reasonable.

> - STATX_ALL definition is unclear, can this change, or is it fixed?
> If it's the former, than that's a backward compatibility nightmare.
> If it's the latter, then what's the point?

The value can change over time.  It is intended to reflect the current
state of affairs at the time the userspace program and kernel are compiled.
The value sent from userspace lets the kernel know what fields are in
the userspace struct, so it doesn't try to set fields that aren't there.
The value in the kernel allows masking off new fields from userspace that
it doesn't understand.

> - STATX_ATIME is cleared from stx_mask on SB_RDONLY, and on NFS it is
> also cleared on MNT_NOATIME, but not on MNT_RDONLY.  We need some sort
> of guideline in the documentation about what constitutes
> "unsupported": does atime become unsupported because filesystem is
> remounted r/o?  If so, why isn't this case handled consistently in the
> VFS and filesystems?

Strange.  I'd think that if userspace is requesting atime, it should
get an atime value.  The fact that the kernel is not updating atime
due to mount options just means that atime might be old.  That doesn't
mean (IMHO) that atime doesn't exist.

> - What about fields that are not cached when statx() is called with
> AT_STATX_DONT_SYNC?  E.g. stx_btime is supported by the filesystem,
> but getting it requires a roundtrip to the server.  Requesting
> STATX_BTIME in the mask and adding  AT_STATX_DONT_SYNC to the flags
> means the filesystem has to decide which it will honor.   My feeling
> is that it should honor AT_STATX_DONT_SYNC and clear STATX_BTIME in
> stx_mask.   Documentation has no word about this case.

The btime value shouldn't change over the lifetime of a file, so
DONT_SYNC shouldn't have any effect on its validity?

I think DONT_SYNC applies to values like size, blocks, mtime, ctime
that may change rapidly over the lifetime of the file, so a totally
up-to-date value is not needed from the server in that case.

Cheers, Andreas






--Apple-Mail=_AE0B5849-9F29-4FFB-A808-0809BDB00948
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvHg1cACgkQcqXauRfM
H+CqrRAAgoCd6bKzHq0tRoHjcysy7L0xS8sTqhX+GhRC5ZYfLOFiLMjZYHu81Bsf
h2Ra6QC/QnTHzI+4eht3uQr4dZUBTQ7bYtBlzG6uJKo/SWbX2ZU8vlmZR9kUfRnb
6O8AgTFRh0k/aEkZQQNYnBazexET+ypTPwilMg0y4K0sUDuGGQudmI90P92/aZ3S
8Rps0+J9XYEF9Oe1fvWf9vZzmHvVnm9m4McFubcktR28uo1qJWQsDLOoLfI/NS/m
KJthGnbG00wlka+nrumvU3CH6aKu7PkUAqcCS8ZSyrT1+NXS0fnJJYcFXAHvET+X
0h5TGr0SBCVvvzV5eu72T30XAShfgekg281keR0+bUXqGrLjdf0HikJQYoqfrB+e
yMx5CWy5beCd81Dm+Q7z2sszMxJuzQMplG35Q/vitZWvHfMt0JsCGkLO2/kTDuRc
pdd1bBzfMtcMvLXl6km7jUJln8+y0oGs8cVSZRv3k0mQf8xWDTTpKAG3R1goi6P+
MZA/iNVJD1k8GL/v9LPiHqajHci2cFiRrZuM8LWUhwNac84NW0kVSjYgHHypHxFS
vE18YIr9qQypTv0S1+1JNDcMZlrPkr1o3sf0omoL61FWz1BwImV7Kere8Gd+UN1y
L875khg4P9QbUdyXUY+MOZBCqbmwYr/3C97n2m8hCtHAm1kIdbg=
=GULC
-----END PGP SIGNATURE-----

--Apple-Mail=_AE0B5849-9F29-4FFB-A808-0809BDB00948--
