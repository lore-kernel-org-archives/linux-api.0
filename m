From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 17:12:23 +0000
Message-ID: <20171128171223.qnd7z7h2lnxy5lkd@sirena.org.uk>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
 <20171128170822.GA22359@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1956256861=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171128170822.GA22359@kroah.com>
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


--===============1956256861==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bcrwn7rpbzlierix"
Content-Disposition: inline


--bcrwn7rpbzlierix
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 28, 2017 at 06:08:22PM +0100, Greg KH wrote:
> On Tue, Nov 28, 2017 at 04:26:20PM +0000, Mark Brown wrote:
> > On Tue, Nov 28, 2017 at 02:32:17PM +0100, Greg KH wrote:

> > > call you added?  What did you do to test this out?  Where are the AOSP
> > > patches to use this?  Happen to have a VTS test for it?

> > Do we need to convert Android for this to be accepted?  The single
> > device is being kept around for it and the use case was from non-Android
> > users wasn't it?

> So we are just going to add kernel features with no userspace users of
> it at all?  Why would we do that?  How was it even tested?

I think it's reasonable to ask for userspace, I'm querying why it needs
to specifically be Android.

--bcrwn7rpbzlierix
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlodmPYACgkQJNaLcl1U
h9DmCAf+P2pI3Z49ZHoR71EKfGIpH8806I4Zp2Nn/yDOg6gnCrD/NTN5OWPnUqhv
XlvMhvDxvk0l9Abvd9VV60JFlOc6JPGakNbs8+mbx3hcDY1Ueu2SJMQPcTKGTg2s
eVgBp6B1RwSEVXRc8U8wkJbYnaqJR37Z/8NDagWYlSzcfptBw63sLHEHjApIK7SM
GHQLvWqGtGRysf22ZfpB661+QygqR25G6lAPj9U6PO88/9ABX09GOLjHlwk+zFuZ
JncJ1Qu/0yQmlTMtD686lap+jDa5HpNRgoy+5zIyeCW6FRdEqhsYI91yFX9/EK7W
rnpnaEoocx5ZergZ27m8Xlp0amvNZg==
=00k5
-----END PGP SIGNATURE-----

--bcrwn7rpbzlierix--

--===============1956256861==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1956256861==--
