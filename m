From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 2/2] staging: ion: create one device entry per heap
Date: Tue, 26 Sep 2017 09:17:01 -0700
Message-ID: <20170926161701.aegnk3kb3fpgz4uy@sirena.org.uk>
References: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506427625-19202-3-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2037571495=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1506427625-19202-3-git-send-email-benjamin.gaignard@linaro.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, linux-api@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org


--===============2037571495==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w7wl2khfhirzognz"
Content-Disposition: inline


--w7wl2khfhirzognz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 26, 2017 at 02:07:05PM +0200, Benjamin Gaignard wrote:

> version 4:
> - add a configuration flag to switch between legacy Ion misc device
>   and one device per heap version.

Should this be a switch or should it just be enabling and disabling the
legacy device with the per heap ones always availalbe?  I can't see that
the new devices would do any harm or have trouble interacting with the=20
per heap ones.  Being able to have both enabled would make things easier
for userspaces that are moving to the device per heap interface.

--w7wl2khfhirzognz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnKfXwACgkQJNaLcl1U
h9CayQf9EnkP/9iAy1o0vNr6tZhJC6jWpBZu+j6PCEExlwGrkL1ICLF/QQRoggK3
3yXZYvRzLdAfZYR2qURK3FCiMHhsuTRK7fS3OaaRJePjGGNmBrxNSOuLxmbMTupH
BCuEDoAnZWhaBbJ/OSca/Tyc3hpABm6nH2SZnm5Zo6SvTuMBIzw+R9Mhzgt/KwvL
1HrVCVWbh/LkpBzKyS2f0qdU0jLksM0xl3WSd4vNfoTc6O5jwXhbyUVFpb/eOGl7
kkMQHmMqPxBjjzL0y29s4NkcY0je5res4CQc2uklLU+W911Xk9C2K0uYeTJ1eOvT
O3H9h3jEqmdPrcOIGPNqRont1fnQVQ==
=Awkx
-----END PGP SIGNATURE-----

--w7wl2khfhirzognz--

--===============2037571495==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============2037571495==--
