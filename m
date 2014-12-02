From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:33:56 +0100
Message-ID: <201412030033.56705.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030021.07882.PeterHuewe@gmx.de> <20141202232442.GB14524@fuloong-minipc.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141202232442.GB14524-+UqvGBo8NkiJ/SmVcN9c7yH8jP4CeeTLqBW4ids5wwA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 00:24:43 schrieb Aaro Koskinen:
> Hi,
>=20
> On Wed, Dec 03, 2014 at 12:21:07AM +0100, Peter H=FCwe wrote:
> > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > @@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client
> > *client,
> >=20
> >  		return -ENODEV;
> >  =09
> >  	rc =3D tpm_chip_register(chip);
> >=20
> > -	if (rc)
> > -		return rc;
> >=20
> > -	return 0;
> > +	return rc;
>=20
> Maybe just return tpm_chip_register(chip)?

Even better.

(I should go to bed now ;)
Peter
