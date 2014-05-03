From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: execve is not atomic, what is the exit state of the process when
 execve fails after throwing away the original process image?
Date: Sat, 3 May 2014 19:45:10 +0200
Message-ID: <20140503174510.GA7720@debjann.fritz.box>
References: <faa2c0e82f8a8.536300c8@langara.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <faa2c0e82f8a8.536300c8-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 02:19:52AM +0000, Steven Stewart-Gallus wrote:
> execve is not atomic, what is the exit state of the process when
> execve fails after throwing away the original process image?

See http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740 or
so =E2=80=93 as far as I know, the kernel sends a SIGKILL. Does that help?

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZSsmAAoJED4KNFJOeCOo/HQP/1iMJ4EtxpopYNC/jBbao6GL
tQUXzVvL0Gyb2paVT02lngUa1UG+C8yOKMAnInmMTntrcaentzSAc2HGTtECty+7
qZXx3SKd73Rm0tlr2gw68JwiFJCplSE8fat8Q5CEzApQzyGq6zil2Nm/FelX9S2+
ngALsSwcXpI9fmvf+gZu0eqkubOmBRhx6ZYMh5/oIXwp1TEgKv/xejipRimUPObE
NCGDxs8+E9B41vmwOhg8DVs11qMX+x+Yokm6c4cTPmrdXWKN9sT5WQby3CXLBThU
JFpIFAl1dSTLdl+IQV0JO1UM+i/ZDEak6o7DZgxCeYpijyIG68KZjZ8OpTQ5WchS
oIzHrKXPiI8brp5JWeIqc3b5HWNHmFp3rz7PrDV4EKgCLduZZZtfo3QcaStgti9Z
jpaailvJlwpppCsuuNV2IIEKkl7WNrzfgbtcUttgtBG4S9SKo3eHJQr0BI08OCCp
tkOmtLQhYzWjCASYR8876xH2WeqyKYiWZYEr5HHMZs7wLyL57rdQRuvNUS6MGMKC
rTLyd5r/w2ZJeRpsZTFXZmViTSj6CqbDIA748oBcmPgEpO/Iv+1RVzJCSQ9envh4
9HHGFnO0lxxoKX8+L2c2OdNPocoxeq7jyY1xfxw4RZ1D4pudXl2U302WIDeLWTiN
FP7tcqy2rTpLhVxFsUAU
=oFTg
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
