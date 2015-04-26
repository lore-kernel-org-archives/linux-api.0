From: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Subject: Re: [PATCH] of: Move OF flags to be visible even when !CONFIG_OF
Date: Sun, 26 Apr 2015 14:45:04 +0200
Message-ID: <20150426124504.GA2647@katana>
References: <1429868516-19519-1-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429868516-19519-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2015 at 12:41:56PM +0300, Pantelis Antoniou wrote:
> We need those to be visible even when compiling with CONFIG_OF
> disabled, since even the empty of_node_*_flag() method use the
> flag.
>=20
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>

Acked-by: Wolfram Sang <wsa+renesas-jBu1N2QxHDJrcw3mvpCnnVaTQe2KTcn/@public.gmane.org>

You should have mentioned that this is needed to get a bugfix for
OF_DYNAMIC in i2c upstream!


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVPN3QAAoJEBQN5MwUoCm2RxsQAJySLYYuGjjIn0ZXRHp81gwe
RpqtlgfbEZInGfDDv6VrXO2BPO25udVD++AcZ3u+zU424p4NOLwvqZBdeMiLrwcH
23LA+tf8PC8wvF6AHGZBJ+TQ3cES+4rZxF2xy1/JnfYHJ6tfJX0pKyq1msF49jFt
au3uUP9fGWyTnAdCH8WELOZG61cl1dE907WAoEyCAuTKupMBw6QqMws0hXky0Az/
RQCTOUOz1mVrISJO5E0GuO+sGVUCKH++zdkurwUmgMTX73EYxcr66QVyiXdqnBbt
zzroinbWxysQCaVF+P4LZfapN28ym0IaZMFQUIZ0FV1Hw2GO42fxdZ9pF9stwfNY
BWTQcrI1YpY0sPhvk1sZ26gLFyyJvO4fAtpY33OxUv7i6zNSIk5Kf44Of7iBNPLD
UnvUHH4VsDRIrD5xyQU80zmx5XG+hvx1FS94Ci7zypkSf3sgziUhu2fAHcoSCmeq
pErBo1yciood9rbkN9ucQST5ZjFJUyP5MdJpIQQYmIkGJOgPb9RzykpqBR9E5N3c
3qWMRMEUuLsB9F/Vn2SM8GGTokXHxx4+ie9zm07FtZwlbDfLzTebJZC39RcO6cQK
uSLsv4LN+ylJc7BGaiBhhwdBWg8clZdBRShH82qJKVKFA+F0CQy76Ei+AeedUZn+
ZkjYVSKLql2/INRsPmGf
=cZ1T
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
