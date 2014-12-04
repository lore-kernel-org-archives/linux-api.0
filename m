From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Thu, 4 Dec 2014 23:28:29 +0100
Message-ID: <201412042328.29578.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com> <201412042318.33889.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201412042318.33889.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 23:18:33 schrieb Peter H=FCwe:
> Hi Jarkko,
>=20
> Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> > From: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2=
=2E0,
> > instead of calling tpm_get_timeouts(), assign duration and timeout
> > values defined in the TPM 2.0 PTP specification.
> >=20
> > Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >=20
> >  drivers/char/tpm/tpm_tis.c | 80
> >=20
> > ++++++++++++++++++++++++++++++++++++++-------- 1 file changed, 67
> > insertions(+), 13 deletions(-)
> >=20
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.=
c
> > index 89e1abb..71cbb2d 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -1,5 +1,6 @@
> >=20
> >  /*
> > =20
> >   * Copyright (C) 2005, 2006 IBM Corporation
> >=20
> > + * Copyright (C) 2014 Intel Corporation
> >=20
> >   *
> >   * Authors:
> >   * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> >=20
> > @@ -44,6 +45,10 @@ enum tis_status {
> >=20
> >  	TPM_STS_DATA_EXPECT =3D 0x08,
> > =20
> >  };
> >=20
> > +enum tis_status3 {
> > +	TPM_STS3_TPM2_FAM =3D 0x04,
> > +};
> > +
> >=20
> >  enum tis_int_flags {
> > =20
> >  	TPM_GLOBAL_INT_ENABLE =3D 0x80000000,
> >  	TPM_INTF_BURST_COUNT_STATIC =3D 0x100,
> >=20
> > @@ -70,6 +75,7 @@ enum tis_defaults {
> >=20
> >  #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
> >  #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
> >  #define	TPM_STS(l)			(0x0018 | ((l) << 12))
> >=20
> > +#define	TPM_STS3(l)			(0x001b | ((l) << 12))
> >=20
> >  #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
> > =20
> >  #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
> >=20
> > @@ -363,6 +369,7 @@ static int tpm_tis_send_main(struct tpm_chip *c=
hip,
> > u8 *buf, size_t len) {
> >=20
> >  	int rc;
> >  	u32 ordinal;
> >=20
> > +	unsigned long dur;
> >=20
> >  	rc =3D tpm_tis_send_data(chip, buf, len);
> >  	if (rc < 0)
> >=20
> > @@ -374,9 +381,14 @@ static int tpm_tis_send_main(struct tpm_chip *=
chip,
> > u8 *buf, size_t len)
> >=20
> >  	if (chip->vendor.irq) {
> >  =09
> >  		ordinal =3D be32_to_cpu(*((__be32 *) (buf + 6)));
> >=20
> > +
> > +		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +			dur =3D tpm2_calc_ordinal_duration(chip, ordinal);
> > +		else
> > +			dur =3D tpm_calc_ordinal_duration(chip, ordinal);
> > +
> >=20
> >  		if (wait_for_tpm_stat
> >=20
> > -		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> > -		     tpm_calc_ordinal_duration(chip, ordinal),
> > +		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
> >=20
> >  		     &chip->vendor.read_queue, false) < 0) {
> >  		=09
> >  			rc =3D -ETIME;
> >  			goto out_err;
> >=20
> > @@ -588,6 +600,7 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, int rc, i, irq_s, irq_e, probe;
> >=20
> >  	struct tpm_chip *chip;
> >  	struct priv_data *priv;
> >=20
> > +	u8 sts3;
> >=20
> >  	priv =3D devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
> >  	if (priv =3D=3D NULL)
> >=20
> > @@ -604,11 +617,28 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, if (!chip->vendor.iobase)
> >=20
> >  		return -EIO;
> >=20
> > +	sts3 =3D ioread8(chip->vendor.iobase + TPM_STS3(1));
> > +	if ((sts3 & TPM_STS3_TPM2_FAM) =3D=3D TPM_STS3_TPM2_FAM)
> > +		chip->flags =3D TPM_CHIP_FLAG_TPM2;
> > +
> >=20
> >  	/* Default timeouts */
> >=20
> > -	chip->vendor.timeout_a =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_b =3D msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > -	chip->vendor.timeout_c =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_d =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > +		chip->vendor.timeout_a =3D usecs_to_jiffies(TPM2_TIMEOUT_A);
> > +		chip->vendor.timeout_b =3D usecs_to_jiffies(TPM2_TIMEOUT_B);
> > +		chip->vendor.timeout_c =3D usecs_to_jiffies(TPM2_TIMEOUT_C);
> > +		chip->vendor.timeout_d =3D usecs_to_jiffies(TPM2_TIMEOUT_D);
> > +		chip->vendor.duration[TPM_SHORT] =3D
> > +			usecs_to_jiffies(TPM2_DURATION_SHORT);
> > +		chip->vendor.duration[TPM_MEDIUM] =3D
> > +			usecs_to_jiffies(TPM2_DURATION_MEDIUM);
> > +		chip->vendor.duration[TPM_LONG] =3D
> > +			usecs_to_jiffies(TPM2_DURATION_LONG);
> > +	} else {
> > +		chip->vendor.timeout_a =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_b =3D msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > +		chip->vendor.timeout_c =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_d =3D msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	}
> >=20
> >  	if (wait_startup(chip, 0) !=3D 0) {
> >  =09
> >  		rc =3D -ENODEV;
> >=20
> > @@ -623,8 +653,8 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, vendor =3D ioread32(chip->vendor.iobas=
e +
> > TPM_DID_VID(0));
> >=20
> >  	chip->vendor.manufacturer_id =3D vendor;
> >=20
> > -	dev_info(dev,
> > -		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
> > +	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> > +		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> >=20
> >  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>=20
> When loading tpm_tis force=3D1 with my tpm1.2 chip on a machine witho=
ut bios
> integration, it fets detected as a TPM2.0 chip :/
>=20
> sudo rmmod tpm_tis
> # modprobe tpm_tis force=3D1
> modprobe: ERROR: could not insert 'tpm_tis': No such device
> # dmesg
> [  263.903828] tpm_tis tpm_tis: 2.0 TPM (device-id 0xB, rev-id 16)
> [  263.948049] tpm_tis tpm_tis: A TPM error (10) occurred continue se=
lftest
> [  263.948120] tpm_tis tpm_tis: TPM self test failed
>=20
>=20
> sts3 is reported as 0xff from my TPM1.2
>=20


Hmm,
my TPM2.0 chip also reports sts3 as 0xff (when loading with force=3D1 o=
n a=20
machine without bios integration)

[  307.095344] sts3 ff
[  307.095366] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
[  307.140047] tpm_tis tpm_tis: A TPM error (256) occurred continue sel=
ftest
[  307.140056] tpm_tis tpm_tis: TPM self test failed




Peter
