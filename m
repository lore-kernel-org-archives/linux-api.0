From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Tue, 3 Oct 2017 09:48:49 -0700
Message-ID: <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1687208630=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Laura Abbott <labbott@redhat.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, linux-api@vger.kernel.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org


--===============1687208630==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fcwkpm357ypn6nz7"
Content-Disposition: inline


--fcwkpm357ypn6nz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 11:07:48AM -0700, Laura Abbott wrote:

> Thinking about this a bit more, I'm not 100% sure if this
> will allow the security rules we want. Heap ids are assigned
> dynamically and therefore so will the /dev/ionX designation.
> From my understanding, security rules like selinux need to
> be fully specified at boot time so I'm not sure how you would
> be able to write rules to differentiate between /dev/ionX and
> /dev/ionY without knowing the values at boottime.

Isn't this something that should be managable via udev rules that ensure
stable names in the same way as for things like disks or ethernet
controllers (even if it just ends up doing something like /dev/ion-gpu
or whatever)?  If we're not giving it enough information to assign stable
names where needed we probably need to fix that anyway.

--fcwkpm357ypn6nz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnTv24ACgkQJNaLcl1U
h9DuvQf9GkTZ3z5XJ8MEuc2dMn+kBEvgOny2P69T+H2ioFQgZJymKQbyR4bP86Li
n2LWCF54U7+pnPenVa1KNprFaBfv3n05nNscbjiqYcyaDzL/fntRvM2aaHE0iFBU
NLNL37BLl9egvsPwFPqoHsMp9BJVwmPEGdk1jrproeSZ4vd5G8Q53c0vtsVzBcTw
wXLPOhWERHLeOTiwIor4pVNiIazFDnMWOtau/KUV3LvZDX9cR8xWQg0TqqodIH3c
v/D0RRS+CquKpGocUs1K7TWpca+U6VzEL2w9PYUElMhfdEhmjL5aYilV8R/05SjF
u7zgiSCiXYxRryK3sx3QG8uSsqraFg==
=awwB
-----END PGP SIGNATURE-----

--fcwkpm357ypn6nz7--

--===============1687208630==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1687208630==--
