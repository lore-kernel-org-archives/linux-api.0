From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 0/2] add cursor blink interval terminal escape sequence
Date: Mon, 2 Mar 2015 13:15:34 +0200
Message-ID: <54F44656.8090107@ti.com>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain> <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain> <20150225094946.GA24627@amd> <alpine.LNX.2.11.1502252319330.276@localhost> <20150226220243.GC9935@amd> <alpine.LNX.2.11.1502271905580.4212@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="MrqmfubdwnxbboBpPv8hwnhoD0MJu87mT"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.11.1502271905580.4212@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--MrqmfubdwnxbboBpPv8hwnhoD0MJu87mT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 27/02/15 21:10, Scot Doyle wrote:
> Greg, the first patch of this series is for the tty tree.
>=20
> Tomi, the second patch of this series is for your tree, but it depends =
on
> the first patch. Also, will you remove these two previously queued patc=
hes?
> "fbcon: store cursor blink interval in fbcon_ops"
> "fbcon: expose cursor blink interval via sysfs"

I have dropped those two patches from fbdev tree.

I don't know much about the console side, so I can't comment anything on
that.

 Tomi



--MrqmfubdwnxbboBpPv8hwnhoD0MJu87mT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU9EZWAAoJEPo9qoy8lh719NgQAI4zzovgCtPyc+YUtbbLAaVG
hBGkhGm7b2LXFvPnYZd+FtVkzzUZ/ZD/kTNIhJRfzNc3hipRMKLzeYYics8IDE7y
/0geDZb252Sbzkg5FYMwbBglvjo2FcYOG4fXMMs5rWIpL+0XZi4ssB6JfTHTGUsP
/ZYpQ3Lb/y+BFpbvtBV8ye3Du8pIg0JwOKCgZTLklw6SsR77t64lQcbJzFDAPEDq
DswnJ8tdhuva2oP7ucK92NvbtFF8EOPAbfa9zjG/MxvODeQ7C/ioWYeHxPlVA7XU
h5cZEgimoKLgt19gW+u90X4CZzRXm5Tgi+GEcPMGD4q+scZs76CdATtDv/wouKuh
hncTwfpDwuTZvhC1nVPv6h67ZJcW9SVL6uFG4k7ugdrFXTKE8oWkVjQEN+xLNyml
3ezHvWllGci9/HhqMsZ0IKkU4eqzT6U6k8GT01U7DYMfk/Jw7khW2540lN/ea4CB
U/vsyzVqo7zo0sLxOBUP9yGjKQUfR4aGL5MRE9bX+gUowMKvBgsCVH2Q3KYOjDyA
EgelvshvHpxU5APyLRACVp5roqDGUSMt6Z50fovfLQIzlssnJPFHXnxZMYuuym4b
F6p6USsfEgiC3cfG8iwrwxRiCWMZXK4KaYaWCCYqgOtwd77iktfijsXmrUGPFtH0
WoM9mt1siUA9Qd/UUlio
=oUUI
-----END PGP SIGNATURE-----

--MrqmfubdwnxbboBpPv8hwnhoD0MJu87mT--
