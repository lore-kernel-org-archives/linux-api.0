From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v6 7/8] vhost: cross-endian support for legacy devices
Date: Thu, 28 May 2015 14:59:19 +1000
Message-ID: <20150528045919.GH6681@voom.redhat.com>
References: <20150424122211.19156.97626.stgit@bahia.local>
	<20150424122632.19156.88058.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8228653873239979939=="
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424122632.19156.88058.stgit@bahia.local>
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


--===============8228653873239979939==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2015 at 02:27:24PM +0200, Greg Kurz wrote:
> This patch brings cross-endian support to vhost when used to implement
> legacy virtio devices. Since it is a relatively rare situation, the
> feature availability is controlled by a kernel config option (not set
> by default).
>=20
> The vq->is_le boolean field is added to cache the endianness to be
> used for ring accesses. It defaults to native endian, as expected
> by legacy virtio devices. When the ring gets active, we force little
> endian if the device is modern. When the ring is deactivated, we
> revert to the native endian default.
>=20
> If cross-endian was compiled in, a vq->user_be boolean field is added
> so that userspace may request a specific endianness. This field is
> used to override the default when activating the ring of a legacy
> device. It has no effect on modern devices.
>=20
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVZqCnAAoJEGw4ysog2bOSHh8P/iQXAlZAk6uVRICEqhnOfpyq
Ui/vR2lOISix8TPuEl0vUyZwLTxu4eT6DivWvA0KPRCSuUrwXp4GYxp/vPtV4uG7
SQC2kHQB2+cWsuMzR0QIkHT3aBTQhUky4w8nMlqjoDCWLUE1EYt7k4vHq9yJZHur
3h0DMjcgpUkUhdc92eDbchuF6JICaeyTbl7eEP+N721g5fSBs0rbaKDXvsOMMYC4
35qwaTY2MIrZ1snI9jSdvkXnlfU+MN58AA5J8UXXvlvh0m+YE9C3NJ/NUswBqgLh
1jtF2qdaK7GHYsLdgJ0Ui685V2ChSNTSH3HEfnGghDvStQnODb+CSyXtxXsOccwn
3ht7aJQ/47SyFn4I2L0RoaBUFac6c2+dm+tnOp/Yn94Dp+++UB1IeA9GqJZbZiFm
IVgCSZeUrJQOEyD0oM8vbi2Tel/TMlrKtYkS3968HV/C+WZj94Mg9XCAplEhDBD2
zfj5IDxlmOcD/HPlqLyRjoVAfR049IpSu3kc/w+T+UZ1UjW7LiNuRh4PMF6ZcAGb
viP381G6VCqguFaea6snA+81OgkPyvD3eQVgcDwluYiwRI8eJlFBqBG0M3hGrbfJ
dBVPUnEvh/pBCZMOentNEPLVzkKFJv2cWZUqoEDhnKqqtUg8Q2DHl7loZnqeOo52
fyiGJZcNClqYJmHqu1mW
=RAE5
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--

--===============8228653873239979939==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============8228653873239979939==--
