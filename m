From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v6 6/8] virtio: add explicit big-endian support to memory
	accessors
Date: Thu, 28 May 2015 14:59:00 +1000
Message-ID: <20150528045900.GG6681@voom.redhat.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424122521.19156.65586.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6901740345731471672=="
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424122521.19156.65586.stgit@bahia.local>
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


--===============6901740345731471672==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline


--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2015 at 02:26:24PM +0200, Greg Kurz wrote:
> The current memory accessors logic is:
> - little endian if little_endian
> - native endian (i.e. no byteswap) if !little_endian
>=20
> If we want to fully support cross-endian vhost, we also need to be
> able to convert to big endian.
>=20
> Instead of changing the little_endian argument to some 3-value enum, this
> patch changes the logic to:
> - little endian if little_endian
> - big endian if !little_endian
>=20
> The native endian case is handled by all users with a trivial helper. This
> patch doesn't change any functionality, nor it does add overhead.
>=20
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVZqCUAAoJEGw4ysog2bOSLaAP/2r1v1u7XHeYB3GT0bqEBJBz
ki7ef7ib/ety7z/HhyZYhTbZlCyEdqRhaPfQBpTS+r+Err0mmKFsPJoecwGFiuBc
Hz9APDGwEVRhvhhE67mStzk4V/45OYuN/BsgRWFjPsYWAwvdUBSRZnAvUDaNkfxu
yEy6HBZtjWAU4f7cAZ/rlrw3zs8CvlTU0QTg6gTiZfcqDb9SNYc07SrXQJ5GDIcj
7eRNqBLMNyLxWD86iz/UUp0+WJ3ISxnwz9KGqs9VsJ5Pp7XiDQ9CAKpN1ApSxnrJ
oi9/+Fq1lCtW+wvJO8O7IPAEEMQdcMTTaqSZDINgyU32MZA1Kvqe2PMLZVcGgkP1
5dqtXzrGOWLMHxU+l9PRijVolFgDKUJ3XW5o7TTYdHMi/7LEHpnPk9Tmske1y0P3
OIoGpHzv2/ZkDfRpFMC7ZF9MrGN3CzxaUsak2I/p8ZWQizCgl8qC8FodoqqtG6Si
Akh6HH91HCjv6+3Oy+Ibcc/1uH0V13miUsSlOo2jijDYzxyGGVz3MhxIKxtku7xU
jLXHO7dPoPTEwu8MhpTSPhcmBR2apb9ErTwE/kTbV0jjzrGz/J93VjIT8v0QuzQm
FqiG9k5PEXzy8zSBHyyv65TFz07JK5ziUBySIYi9s/3eTNItJaqx/C/BAfOPv3GG
K7NrpyYDiSdmvxEp0WTg
=s7iV
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--

--===============6901740345731471672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============6901740345731471672==--
