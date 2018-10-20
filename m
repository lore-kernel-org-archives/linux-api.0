From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 6/5] statx: add STATX_RESULT_MASK flag
Date: Fri, 19 Oct 2018 23:55:04 -0600
Message-ID: <191D94B6-B91B-45C0-81A2-C6E7A3124731@dilger.ca>
References: <20181019143932.6697-1-mszeredi@redhat.com>
 <18142.1539964788@warthog.procyon.org.uk>
 <CAJfpegtPv4+QxzcqMAGwTt7QALjBaxQtt2Qet98pdmuT1MRUeA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2AA2161F-DEAC-4A18-B584-431061FB00A9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtPv4+QxzcqMAGwTt7QALjBaxQtt2Qet98pdmuT1MRUeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_2AA2161F-DEAC-4A18-B584-431061FB00A9
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 19, 2018, at 11:42 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> +#define STATX_RESULT_MASK STATX__RESERVED
>> 
>> Please don't use that bit.
> 
> Using it internally is perfectly harmless.   If we'll need to extend
> statx in the future and make use of this flag externally, then we can
> easily move the internal flag somewhere else (e.g. extend request_mask
> to 64bit, which we'll probably need to do anyway in that case).

I was thinking about this - what is the point of returning an error
if STATX__RESERVED is set?  If this is used to indicate the presence
of e.g. stx_mask2, then newer applications trying to request any of the
flags encoded into stx_mask2 will get an error, rather than the expected
behaviour of "ignore flags you don't understand, and don't set them in
the return stx_mask".

Essentially, this will make STATX__RESERVED useless in the future, since
no application will be able to use it without getting an error if they
are running on an old kernel.

Cheers, Andreas






--Apple-Mail=_2AA2161F-DEAC-4A18-B584-431061FB00A9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvKwzgACgkQcqXauRfM
H+ATqxAApNR2xdaiSRfe2Fgfo8reQlhc30NE6O1bmlWMKVdMR5/QZoJ33qvSD3YM
T01+drMlFx+L5Onoy9VF36bcvMm7LO3AN6ghINgQXVyPyitFXJiNn8DU/wwIwzNR
8evyURtDSgdw0+BNOx6zuuLcOsDcAhSS9HwCpf57upQWVsnKsqTs0ZOPQMM2Bz3f
/FcuVbe8UMyvyORUg+3AS+aX05MG12LXRClCGMyVnczbbfABtW+PJMtyZUvniqJd
AmXS0y41IV0PU7Fun5m0J2EEdtQvMkqcT3ULutB5VtcZGAitBuBIKBeQs7a5PBlK
lk0koGse1IR4sZi3NrCg+8UAUAQJG7Zvt6N4QFEN6pvilK3SflOydGEI7IQ7fQgJ
52xCWLSOXwQvm1/oOFOC3sTOmZHOEwVn+YeEpWIaNHb9xSMuNgdBDYnpsVoMDdec
w/2HECiWqi5+SkwRFzRjaeLkAHs5pnjVrDsV4i17gn4eJSIrg1wt0vDUbbPFBUJI
qgqenVwOdUkrmiJ2PGnKzUoh0/WIhy3jHVhs9TTFLeSFMORP0KOmzVDuLX9TrY7u
TTWKEj4bxU2NhAZCt2YmPcb+DZnpo/9hGziL1CF3zHqBgc9x/86si6lLnghZ40uA
r+s3TJzEj02WHO3DIHk4Fr4YrjGyPI5Ys+MyhLwObu7JSDhQrRw=
=X1q8
-----END PGP SIGNATURE-----

--Apple-Mail=_2AA2161F-DEAC-4A18-B584-431061FB00A9--
