From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Thu, 2 Nov 2017 11:10:19 +0000
Message-ID: <20171102111019.kpsvobvzfiezdndp@sirena.co.uk>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
 <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
 <20171102104407.GA14048@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1688066064=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171102104407.GA14048@kroah.com>
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


--===============1688066064==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="icwplgw65fvta4y3"
Content-Disposition: inline


--icwplgw65fvta4y3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2017 at 11:44:07AM +0100, Greg KH wrote:
> On Tue, Oct 31, 2017 at 07:11:53PM +0000, Mark Brown wrote:

> > There was a discussion a while ago in the context of I2C/SPI MFDs
> > which concluded that if you need a bus and it's going to be effectively
> > noop then you should just use the platform bus as anything else will
> > consist almost entirely of cut'n'paste from the platform bus with some
> > light sed usage and code duplication is bad.  It's not super lovely as
> > it's not actually a memory mapped device but it's the best idea we've
> > got.

> Ugh, I hate that.  What's wrong with using a "virtual" device instead?

It was the duplication, initially everyone was making buses. =20

> I can create a "virtual" bus for things like this if they really want a
> "simple" bus, abusing platform for this is the major reason I hate the
> platform bus code...

In the MFD case they're physical devices, they're just usually on the
wrong side of an I2C or SPI link.  Plus MFD already handles platform
devices for things that are memory mapped so it's a bit of a more
natural fit there.

--icwplgw65fvta4y3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAln6/RoACgkQJNaLcl1U
h9AgJQf9E25nclgxWPr2Zk0l9foyVDQi/OEeCreZ6q0+IsKyoqolY1HS+h86vuve
rQjp2ukr03NuIAIHGb4JGOFevvmbXd8Xt6yDnX5g7GMzBMnZwR5UO1hjJay+CwVz
WGZN+dccbmtSGp5ACySGLuy3NvqBPyv0jcdregonpPRPikRy0cPDQNnZ1wuwM8fp
VNQgIPfvz6K5o95kRjaI0pUwJpOH1c2jLNNH+f31ywbltPDy54f1qJzO5sNdptfD
gSGAHFCsindgGkq4na9O0jUxcphitAnAkKolQ0vBizN0fIEow6dlmg60TL86MrB+
rinZOoM01eQoTOCfuNuc3n2LYPKBIA==
=xkLD
-----END PGP SIGNATURE-----

--icwplgw65fvta4y3--

--===============1688066064==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1688066064==--
