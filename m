From: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/13] MADV_FREE support
Date: Sat, 5 Dec 2015 10:51:58 -0500
Message-ID: <5663081E.4010205@gmail.com>
References: <1446600367-7976-1-git-send-email-minchan@kernel.org>
 <20151205111042.GA11598@amd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="25AEtqoWBXCvAxgbRSFnbrHf3lJq2GSlb"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151205111042.GA11598@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--25AEtqoWBXCvAxgbRSFnbrHf3lJq2GSlb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/12/15 06:10 AM, Pavel Machek wrote:
> On Wed 2015-11-04 10:25:54, Minchan Kim wrote:
>> MADV_FREE is on linux-next so long time. The reason was two, I think.
>>
>> 1. MADV_FREE code on reclaim path was really mess.
>=20
> Could you explain what MADV_FREE does?
>=20
> Comment in code says 'free the page only when there's memory
> pressure'. So I mark my caches MADV_FREE, no memory pressure, I can
> keep using it? And if there's memory pressure, what happens? I get
> zeros? SIGSEGV?

You get zeroes. It's not designed for that use case right now. It's for
malloc implementations to use internally. There would need to be a new
feature like MADV_FREE_UNDO for it to be usable for caches and it may
make more sense for that to be a separate feature entirely, i.e. have a
different flag for marking too (not sure) since it wouldn't need to
worry about whether stuff is touched.


--25AEtqoWBXCvAxgbRSFnbrHf3lJq2GSlb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWYwgeAAoJEPnnEuWa9fIqgHIP/jTlp7FHHc0W2g6+GR5Httb2
2ORoNvgw05Ry1iOpPNIYOJJpUBz++nE6tDC57amsOLsV1/CKxw/kZDs+zSEeAIyR
yQRIlG46pVA5nTmtpgBTGJX7ryD9BvDsoZKsWqkRJjby6S2Iy/v7c9bSjpmJdDVp
4hxrAgdBKWoSxnkcIC4LTEVGr9KhPEDyVXCihGhW78gMHY5KdnF4mxPPfgGaRTmq
eths7pEK9aAEDB1mjXRNj1q7I/PV+2yNuwGl5Bgi1JuHVKx6fpjWH42C1CBdAxPD
8qEtaT18uJZcsO3yIp/J3caXLwYBNooQIFcDV/0HAYcGW1NjyJvoVvPdnXH+cVp2
ICBhOVMgRUVTQiAmxMXem5PS1nMMwTI3m1WmpShCNO0XI0kF5We4WhpeAt1wns+A
mmLF3A/9JpdYwVnF4m7Sfj0lahSyvO+XJMJObtq5YwiAps/Cg91xC43rTe4n4TpK
rhG0stTS/RlW6/vJYcF7K5eH4dzm3xPCOY1lOKG4xlfkDalO+rLfVz/CuUjDbDCK
4ut8JyO5eq9Wx3bG1h3/pHPrpgQOcrr7lNhrv+6259/dkzq5HQ5hl70bl8r1yZzJ
2EX35OxYYVrwIJVI8kovg9oyECXR4xAmz/KygYVCotJ4/0NNd/1792XCqyYvPvJ8
EL+l2snIELktLOqS2NSO
=FiDs
-----END PGP SIGNATURE-----

--25AEtqoWBXCvAxgbRSFnbrHf3lJq2GSlb--
