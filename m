From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH 01/14] twl4030_charger: use devm_request_threaded_irq
Date: Fri, 24 Jul 2015 16:34:16 +0200
Message-ID: <20150724143416.GB27569@earth>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232028.23789.97241.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150322232028.23789.97241.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 23, 2015 at 10:20:28AM +1100, NeilBrown wrote:
> From: NeilBrown <neilb@suse.de>
>=20
> This simplifies the error paths.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>

I queued this with Pavel's ACK after a rebase to current master:

http://git.infradead.org/battery-2.6.git/commit/1b7cac23419e1398eac4c28368d=
a6671c9c4ce9d

-- Sebastian

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVskzkAAoJENju1/PIO/qaOD4P/jR284yP1PQDWS3MCD7V4DOu
nPhnYkAzN3qkZ3rVO09fPf0FOQVRbctNt2qG4N0D5xxks/i9Ys7znzODhgHeHVMe
QVQEp50igMwtGQHcGPYhD5TeSq50Wtjg1Q5/YvycNY/ku4iCM5/1Z2FcefywBDXU
hq9NEN6iaVQxXAnRROWgiUGohmCqKcBJKeyKVsjrDkJgxS4RcingY8WNfWXZ1XuT
7mffcdL81abt1AfC69Oyd4bXrLoy0MTc78oecxv5Sw4kb+CFSktZqE7SbT/G9+4p
F2xLcR6FOYHHwmCo+i7BM+WFt9CfStr5Jz0GyirOnbaMB8qwyHAELYSIEt3FUB5/
+sOpuzME8/YlUsb/UMfyDCMx/sCRQADX3WIdPAOU1HwQ9hzi+BRVX/EC6c/JPZ1A
QuM694+ftcb7kaGQHG+dypkiV1Lln3qLt3IQp/D9SWqeoAf5AiQ1hIV3lmC3Scj7
rxoxTUWSVc2UfFP81upWfK1safrHyB7hwAF3h1pjZfDrAW3Xj74NfzFhrbXNAty2
o6a0/VwIEbxRa5igz084up42xfOrRfPjwdUcW8Ll8V0RcebYCKFg14+7rqw9dHtD
fdcb5ae0cRZLFHDO+gh8ubnGpDs0fUcEYPWJ6zNdR3shyxwQ1S/SDcHjtWvVtFCO
aHvpO/k51pLwZrz42L7m
=kOyO
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
