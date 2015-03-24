From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 12:02:26 -0700
Message-ID: <20150324190226.GB17265@sirena.org.uk>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150323210918.GS14954@sirena.org.uk>
 <55108E2B.7050305@linaro.org>
 <55112BD6.2070600@linaro.org>
 <20150324172346.GW17265@sirena.org.uk>
 <5511AE38.3000108@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2R+TDOstMAPx/aG/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5511AE38.3000108@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--2R+TDOstMAPx/aG/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 06:34:32PM +0000, Srinivas Kandagatla wrote:
> On 24/03/15 17:23, Mark Brown wrote:

> >>regmap_get_size(regmap)

> >This is already there.

> Sorry, I can't see any such api atleast in v4.0-rc5 and linux-next? Are you
> referring to another api which does the same job?

regmap_get_val_bytes()

> >>Which would be give eeprom-core the size and stride info, doing this way
> >>would cut down regmap related things from eeprom_config structure to minimal
> >>and also the source of information would come from just regmap apis.

> >Documentation/SubmittingPatches...

> Am not sure what you meant here, Am guessing that you asked me to keep the
> respective maintainers in the loop and follow the guide, when I resend the
> patch?

I'm saying that you should send patches if you want to add features.

--2R+TDOstMAPx/aG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEbTBAAoJECTWi3JdVIfQYTQH/26ravmygSn6ca+VL7Gzsi45
euom6rsVismkzG9kSfwnYG/Tudg75zoAppUVykE/pLyCeXzqj/VNek3mVxt3sDLJ
C1s+vu6DQezqDO0QRXgUILE82EeZKpS1bVx4PbhdFCUFUZRCGNauUx5M0F/DU3ip
6Oi45FRgovGa/0+YuH9Bu8f9hxUO3jYuK6fBF/ssdrN/fajPv5/IWJtItXqlTWxI
f8VMDlPTmfm9ul6/chiomtJ8LoXn33uZ54STrE6ngDd08FYEpkxufIcKVSMu8+gZ
JnP0wvHU35QS05tv59sVsugBBsqMjZawMU9B/Xu4pSeRE6BYBIlWLyWzs/wr73I=
=VzhL
-----END PGP SIGNATURE-----

--2R+TDOstMAPx/aG/--
