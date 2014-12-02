From: Joe Perches <joe@perches.com>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Tue, 02 Dec 2014 15:48:35 -0800
Message-ID: <1417564115.2902.8.camel@perches.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <201412030021.07882.PeterHuewe@gmx.de>
	 <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
	 <201412030033.56705.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201412030033.56705.PeterHuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, tpmdd-devel@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, christophe.ricard@gmail.com, josh.triplett@intel.com, linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org, jason.gunthorpe@obsidianresearch.com, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Wed, 2014-12-03 at 00:33 +0100, Peter H=FCwe wrote:
> Am Mittwoch, 3. Dezember 2014, 00:24:43 schrieb Aaro Koskinen:
> > On Wed, Dec 03, 2014 at 12:21:07AM +0100, Peter H=FCwe wrote:
> > > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > > @@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_clie=
nt
> > > *client,
> > >=20
> > >  		return -ENODEV;
> > >  =09
> > >  	rc =3D tpm_chip_register(chip);
> > >=20
> > > -	if (rc)
> > > -		return rc;
> > >=20
> > > -	return 0;
> > > +	return rc;
> >=20
> > Maybe just return tpm_chip_register(chip)?
>=20
> Even better.

The pattern:

	foo =3D bar();
	if (foo)
		return foo;

	return 0;

is fairly common.

There are a few hundred in the kernel.

$ grep-2.5.4 -nrP --include=3D*.[ch] "\b(\w+)\s*=3D\s*[^;]*;\s*if\s*\(\=
s*\1\s*\)\s*return\s*\1\s*;\s*return\s*0;" * | \
  grep -oP '^.+:\d+:' | \
  wc -l
308
