From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v6 8/8] macvtap/tun: cross-endian support for
	little-endian hosts
Date: Thu, 28 May 2015 14:59:38 +1000
Message-ID: <20150528045938.GI6681@voom.redhat.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424122732.19156.77709.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0132229076794719926=="
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424122732.19156.77709.stgit@bahia.local>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org


--===============0132229076794719926==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/GPgYEyhnw15BExa"
Content-Disposition: inline


--/GPgYEyhnw15BExa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2015 at 02:50:36PM +0200, Greg Kurz wrote:
> The VNET_LE flag was introduced to fix accesses to virtio 1.0 headers
> that are always little-endian. It can also be used to handle the special
> case of a legacy little-endian device implemented by a big-endian host.
>=20
> Let's add a flag and ioctls for big-endian devices as well. If both flags
> are set, little-endian wins.
>=20
> Since this is isn't a common usecase, the feature is controlled by a kern=
el
> config option (not set by default).
>=20
> Both macvtap and tun are covered by this patch since they share the same
> API with userland.
>=20
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/GPgYEyhnw15BExa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVZqC5AAoJEGw4ysog2bOS/LsQALvsAgPfm3NYRmihQsfB7g7U
6CGyjdomngZo2MKv2Y/c2fUnxi6rzSvvz9ufWNwskOuMa8D45LOjTOP0W10UgAlo
2/W7RUQwwVo/SkrlAAZ6liARv67hVDp53RcA6ogdhisEGLdD82NwKcEdZYIE3pZH
VS+07C5wjUgGPMj7RqWGRKsSNNO8c4c+b+zK/4gpc7OJF8Vz3zHflCvDoda79q90
06hqMJkLmRnLjpyiWafWvUiUEAS0oFNY4Gh9bA0t3aUDYcdVNOSGmQFaB7Jr1Vwe
Uyx78bWvTYmIXGCDjoLEO8aon+00sGj1DFl7JJ7twea+YPeTZCHhpaLZDFa3xRVM
I+JdcG/p38noXVZA534tGSPv+dat6YWE83QStYnQ/Hh4Lo7886bCu/CS+o0QSYoL
gLpY0qxnSVJMhCYD2W4x0w2Pu7Gxqrhj+vNZFyd6BVfd1U069bmzAgxpyuiyMIOA
gyTiHXDHYbHlu8uKWkvq6QbPhtO130eBFJ2dSztipbjFs+Go+Nj993T6jsPYlxzc
MXo30PPpFm5t+R0IuiBzjNiUel0/ixGaXwFgPjsbivV26IQ4KnyTmv2z54sAzcy8
hMLTz11/EZqzv/YqT5gvgmWqAeB7F3wMqQ73Kt1Z8XtUl907QXjQIJpPi9OGrwYU
5IsgdNjOBFXsD7xAtXC0
=yttj
-----END PGP SIGNATURE-----

--/GPgYEyhnw15BExa--

--===============0132229076794719926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============0132229076794719926==--
