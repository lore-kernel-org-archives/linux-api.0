From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm, tpm_tis: fix TPM 2.0 probing
Date: Mon, 9 Feb 2015 10:39:47 +0200
Message-ID: <20150209083947.GC29987@intel.com>
References: <1423059669-31734-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201502090008.47986.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502090008.47986.PeterHuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh@joshtriplett.org, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Mon, Feb 09, 2015 at 12:08:46AM +0100, Peter H=FCwe wrote:
> Am Mittwoch, 4. Februar 2015, 15:21:09 schrieb Jarkko Sakkinen:
> > If during transmission system error was returned, the logic was to
> > incorrectly deduce that chip is a TPM 1.x chip. This patch fixes th=
is
> > issue. Also, this patch changes probing so that message tag is used=
 as the
> > measure for TPM 2.x, which should be much more stable.
> Is it aware that some TPMs may respond with 0x00C1 as TAG for TPM1.2 =
commands?

I guess none of the TPM 1.2 command answer with the tag 0x8002?

> > A separate function
> > called tpm2_probe() is encapsulated because it can be used with any
> > chipset.
>=20
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm.h      |  3 ++-
> >  drivers/char/tpm/tpm2-cmd.c | 40 +++++++++++++++++++++++++++++++++=
-------
> >  drivers/char/tpm/tpm_tis.c  | 11 ++++-------
> >  3 files changed, 39 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 7b0727c..a4b0f5e 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -435,4 +435,5 @@ extern int tpm2_startup(struct tpm_chip *chip, =
u16
> > startup_type); extern int tpm2_shutdown(struct tpm_chip *chip, u16
> > shutdown_type); extern unsigned long tpm2_calc_ordinal_duration(str=
uct
> > tpm_chip *, u32); extern int tpm2_do_selftest(struct tpm_chip *chip=
);
> > -extern int tpm2_gen_interrupt(struct tpm_chip *chip, bool quiet);
> > +extern int tpm2_gen_interrupt(struct tpm_chip *chip);
> > +extern int tpm2_probe(struct tpm_chip *chip);
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cm=
d.c
> > index 1abe650..49cd354 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -598,20 +598,46 @@ EXPORT_SYMBOL_GPL(tpm2_do_selftest);
> >  /**
> >   * tpm2_gen_interrupt() - generate an interrupt
> >   * @chip: TPM chip to use
> > - * @quiet: surpress the error message
> >   *
> >   * 0 is returned when the operation is successful. If a negative n=
umber is
> >   * returned it remarks a POSIX error code. If a positive number is
> > returned * it remarks a TPM error.
> >   */
> > -int tpm2_gen_interrupt(struct tpm_chip *chip, bool quiet)
> > +int tpm2_gen_interrupt(struct tpm_chip *chip)
> >  {
> > -	const char *desc =3D NULL;
> >  	u32 dummy;
> >=20
> > -	if (!quiet)
> > -		desc =3D "attempting to generate an interrupt";
> > -
> > -	return tpm2_get_tpm_pt(chip, TPM2_CAP_TPM_PROPERTIES, &dummy, des=
c);
> > +	return tpm2_get_tpm_pt(chip, 0x100, &dummy,
> > +			       "attempting to generate an interrupt");
> Why the change from TPM2_CAP_TPM_PROPERTIES =3D 6 to 0x100 and what d=
oes 0x100=20
> stand for?

In TPM 2.0 there are two levels: capabilities and properties. Using
capability ID of "TPM properties" property set was a sloppy mistake
although it didn't matter because interrupt is still generate.

The properties in the "TPM properties" property set start with the
index 0x100.

> >  }
> >  EXPORT_SYMBOL_GPL(tpm2_gen_interrupt);
> > +
> > +/**
> > + * tpm2_probe() - probe TPM 2.0
> > + * @chip: TPM chip to use
> > + *
> > + * Send idempotent TPM 2.0 command and see whether TPM 2.0 chip re=
plied
> > based on + * the reply tag.
> > + */
> > +int tpm2_probe(struct tpm_chip *chip)
> > +{
> > +	struct tpm2_cmd cmd;
> > +	int rc;
> > +
> > +	cmd.header.in =3D tpm2_get_tpm_pt_header;
> > +	cmd.params.get_tpm_pt_in.cap_id =3D cpu_to_be32(TPM2_CAP_TPM_PROP=
ERTIES);
> > +	cmd.params.get_tpm_pt_in.property_id =3D cpu_to_be32(0x100);
> > +	cmd.params.get_tpm_pt_in.property_cnt =3D cpu_to_be32(1);
> > +
> > +	rc =3D tpm_transmit(chip, (const char *) &cmd, sizeof(cmd));
> > +	if (rc <  0)
> > +		return rc;
> > +	else if (rc < TPM_HEADER_SIZE)
> > +		return -EFAULT;
> > +
> > +	if (be16_to_cpu(cmd.header.out.tag) =3D=3D TPM2_ST_NO_SESSIONS)
> > +		chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(tpm2_probe);
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.=
c
> > index 6725bef..ee6e0bd 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -639,12 +639,9 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, goto out_err;
> >  	}
> >=20
> > -	/* Every TPM 2.x command has a higher ordinal than TPM 1.x comman=
ds.
> > -	 * Therefore, we can use an idempotent TPM 2.x command to probe T=
PM 2.x.
> > -	 */
> > -	rc =3D tpm2_gen_interrupt(chip, true);
> > -	if (rc =3D=3D 0 || rc =3D=3D TPM2_RC_INITIALIZE)
> > -		chip->flags |=3D TPM_CHIP_FLAG_TPM2;
> > +	rc =3D tpm2_probe(chip);
> > +	if (rc)
> > +		goto out_err;
> >=20
> >  	vendor =3D ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> >  	chip->vendor.manufacturer_id =3D vendor;
> > @@ -747,7 +744,7 @@ static int tpm_tis_init(struct device *dev, acp=
i_handle
> > acpi_dev_handle,
> >=20
> >  			/* Generate Interrupts */
> >  			if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > -				tpm2_gen_interrupt(chip, false);
> > +				tpm2_gen_interrupt(chip);
> >  			else
> >  				tpm_gen_interrupt(chip);

/Jarkko
