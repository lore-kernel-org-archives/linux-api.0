From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 17:37:53 +0000
Message-ID: <20171128173753.t7dk6n7ouwypmumw@sirena.org.uk>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
 <20171128170822.GA22359@kroah.com>
 <20171128171223.qnd7z7h2lnxy5lkd@sirena.org.uk>
 <20171128172838.GA31113@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0924790535=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171128172838.GA31113@kroah.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, arve@android.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, riandrews@android.com, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org


--===============0924790535==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="egtkkdot5ws6qmgf"
Content-Disposition: inline


--egtkkdot5ws6qmgf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 28, 2017 at 06:28:38PM +0100, Greg KH wrote:
> On Tue, Nov 28, 2017 at 05:12:23PM +0000, Mark Brown wrote:

> > I think it's reasonable to ask for userspace, I'm querying why it needs
> > to specifically be Android.

> Does anyone other than Android use this interface?

There's plenty of other userspaces that have the same requirements for
allocation for applications like video capture, I believe some of them
have actually moved to ION already and they're certainly where some of
the requirements here are coming from.

--egtkkdot5ws6qmgf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlodnvAACgkQJNaLcl1U
h9DxCgf9GhYnpGBMkPF2GAxJYDycSKZu34Jmr68VhZn5JcTayRi6Lfh8fHkKJkXk
saZM9SHwFFInjxYanGM56VTWpjpA61uk+4PcbSIwEuaOWybkFgGMcsigaaRbDEQ4
jNkAoVGKacSsj6g0AuVq82rGotwDBRkBC0Z0DLh6Dds4M/oEDUHMBmDlzv3UeTWn
Kozah+XwX4OR5aIruapkNL0H3twIOJpRNYNsU2S4cNdZNH2tN8xgxMF99IffoyRa
1ZVM4Iy9nONVCpEasDqduw4pLUn4QeUEXnr/fdVHuEntj9nWl3NNulIJ960TPZ9W
eY9BccFHsqoCO/MIaxCrKxFnAAUsFA==
=D2Bt
-----END PGP SIGNATURE-----

--egtkkdot5ws6qmgf--

--===============0924790535==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============0924790535==--
