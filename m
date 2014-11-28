From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 28 Nov 2014 14:50:35 +0000
Message-ID: <20141128145035.GO7712@sirena.org.uk>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
 <20141128143532.GI25883@leverpostej>
 <20141128144412.GG7144@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xe+avc01A/A8Y9/A"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141128144412.GG7144@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, "heiko@sntech.de" <heiko@sntech.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "jslaby@suse.cz" <jslaby@suse.cz>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, Pawel Moll <Pawel.Moll@arm.com>, "corbet@lwn.net" <corbet@lwn.net>, "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>, "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, "shawn.guo@freescale.com" <shawn.guo@freescale.com>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "grant.likely@linaro.org" <grant.likely@linaro.org>, "orsonzhai@gmail.com" <orsonzhai@gm>
List-Id: linux-api@vger.kernel.org


--Xe+avc01A/A8Y9/A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 02:44:12PM +0000, Will Deacon wrote:
> On Fri, Nov 28, 2014 at 02:35:32PM +0000, Mark Rutland wrote:

> > Probably too rude, given it doesn't WARN() the user.

> We override broken hardware ID registers all the time in device-tree without
> dumping stack. Why is this any different?

I do tend to agree that a WARN() is excessive but given the amount of
pushback on using this property on ARMv8 systems saying something would
be nice, though...

> > We should be extremely loud if we see the clock-frequency property on an
> > arm64 system. Whether or not we should ignore the property is another
> > matter.

> I don't really see the point in ignoring it. We will see broken hardware
> [1] and this is just preventing ourselves from working around it. I'd much
> rather have arch-timers with a "clock-frequence" property than have some
> other timer instead because the kernel driver is being stubborn.

...it is likely that even if there is a warning we'll end up in this
situation.  If the kernel doesn't complain at all it seems totally
reasonable for people to use the feature, but just refusing to allow it
to be used at all doesn't seem like it's actually helping things.

--Xe+avc01A/A8Y9/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeIu6AAoJECTWi3JdVIfQ0tcH/3KMyCBo1mdFxstyyVH07Idn
oaz3yVG2twGNKRdqys0dLnea5PfpQaG6vNUfJy05QpKLCZWJyvq/4njs2eofWE0j
aqLDcb5uE0StBm+rDYae9Csu3DCYB1t/AigZ137XZwr6dw3AOhH91SVUtrbrDD+7
LVwSaORK5ZkE15Hv2+IVCw2q4mZGeqxP9oe3mVIqmwadpUDIu5U6MIrAHTaZ+RR2
ifIHUTvxj5YjgIagx4vaaJxXHY4u+V4a0kgi1lWEgu8lgFBFEqlGD6C4XFnrLetU
U20jdJamgazrKjjxmiBdl2gKRntiWQ7pr3seAR3ANtNN+3tivKwBNb1GeVSzrzk=
=YmyB
-----END PGP SIGNATURE-----

--Xe+avc01A/A8Y9/A--
