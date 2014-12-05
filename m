From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v9 6/8] tpm: TPM 2.0 baseline support
Date: Fri, 5 Dec 2014 16:13:03 +0200
Message-ID: <20141205141303.GF6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-7-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412050017.40668.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201412050017.40668.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey

is it cool if I prepare a separate set of fixes for all issues
in v9? I do not see any problem that could not be fixed without
major structural changes.

/Jarkko

On Fri, Dec 05, 2014 at 12:17:40AM +0100, Peter H=FCwe wrote:
> Am Donnerstag, 4. Dezember 2014, 06:55:16 schrieb Jarkko Sakkinen:
> > TPM 2.0 devices are separated by adding a field 'flags' to struct
> > tpm_chip and defining a flag TPM_CHIP_FLAG_TPM2 for tagging them.
> >=20
> > This patch adds the following internal functions:
> >=20
> > - tpm2_get_random()
> > - tpm2_get_tpm_pt()
> > - tpm2_pcr_extend()
> > - tpm2_pcr_read()
> > - tpm2_startup()
> >=20
> > Additionally, the following exported functions are implemented for
> > implementing TPM 2.0 device drivers:
> >=20
> > - tpm2_do_selftest()
> > - tpm2_calc_ordinal_durations()
> > - tpm2_gen_interrupt()
> >=20
> > The existing functions that are exported for the use for existing
> > subsystems have been changed to check the flags field in struct
> > tpm_chip and use appropriate TPM 2.0 counterpart if
> > TPM_CHIP_FLAG_TPM2 is est.
> >=20
> > The code for tpm2_calc_ordinal_duration() and tpm2_startup() were
> > originally written by Will Arthur.
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/char/tpm/Makefile        |   2 +-
> >  drivers/char/tpm/tpm-chip.c      |  27 +-
> >  drivers/char/tpm/tpm-interface.c |  24 +-
> >  drivers/char/tpm/tpm.h           |  61 +++++
> >  drivers/char/tpm/tpm2-cmd.c      | 542
> > +++++++++++++++++++++++++++++++++++++++ 5 files changed, 641
> > insertions(+), 15 deletions(-)
> >  create mode 100644 drivers/char/tpm/tpm2-cmd.c
> >=20
> > diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> > index c715596..88848ed 100644
> > --- a/drivers/char/tpm/Makefile
> > +++ b/drivers/char/tpm/Makefile
> > @@ -2,7 +2,7 @@
> >  # Makefile for the kernel tpm device drivers.
> >  #
> >  obj-$(CONFIG_TCG_TPM) +=3D tpm.o
> > -tpm-y :=3D tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
> > +tpm-y :=3D tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-c=
md.o
> >  tpm-$(CONFIG_ACPI) +=3D tpm_ppi.o
> >=20
> >  ifdef CONFIG_ACPI
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chi=
p.c
> > index 7741e28..3f3f2de 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -195,15 +195,18 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  	if (rc)
> >  		return rc;
> >=20
> > -	rc =3D tpm_sysfs_add_device(chip);
> > -	if (rc)
> > -		goto del_misc;
> > +	/* Populate sysfs for TPM1 devices. */
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		rc =3D tpm_sysfs_add_device(chip);
> > +		if (rc)
> > +			goto del_misc;
> >=20
> > -	rc =3D tpm_add_ppi(chip);
> > -	if (rc)
> > -		goto del_sysfs;
> > +		rc =3D tpm_add_ppi(chip);
> > +		if (rc)
> > +			goto del_sysfs;
> >=20
> > -	chip->bios_dir =3D tpm_bios_log_setup(chip->devname);
> > +		chip->bios_dir =3D tpm_bios_log_setup(chip->devname);
> > +	}
> >=20
> >  	/* Make the chip available. */
> >  	spin_lock(&driver_lock);
> > @@ -236,10 +239,12 @@ void tpm_chip_unregister(struct tpm_chip *chi=
p)
> >  	spin_unlock(&driver_lock);
> >  	synchronize_rcu();
> >=20
> > -	if (chip->bios_dir)
> > -		tpm_bios_log_teardown(chip->bios_dir);
> > -	tpm_remove_ppi(chip);
> > -	tpm_sysfs_del_device(chip);
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		if (chip->bios_dir)
> > +			tpm_bios_log_teardown(chip->bios_dir);
> > +		tpm_remove_ppi(chip);
> > +		tpm_sysfs_del_device(chip);
> > +	}
> >=20
> >  	tpm_dev_del_device(chip);
> >  }
> > diff --git a/drivers/char/tpm/tpm-interface.c
> > b/drivers/char/tpm/tpm-interface.c index b6f6b17..8a14887 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -360,7 +360,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, co=
nst char
> > *buf, if (chip->vendor.irq)
> >  		goto out_recv;
> >=20
> > -	stop =3D jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		stop =3D jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
> > +	else
> > +		stop =3D jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> >  	do {
> >  		u8 status =3D chip->ops->status(chip);
> >  		if ((status & chip->ops->req_complete_mask) =3D=3D
> > @@ -483,7 +486,7 @@ static const struct tpm_input_header tpm_startu=
p_header
> > =3D { static int tpm_startup(struct tpm_chip *chip, __be16 startup_=
type) {
> >  	struct tpm_cmd_t start_cmd;
> > -	start_cmd.header.in =3D tpm_startup_header;
> > +
> WHY?!? This renders tpm_startup useless.
>=20
> So NACK for this part.
> >  	start_cmd.params.startup_in.startup_type =3D startup_type;
> >  	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZ=
E,
> >  				"attempting to start the TPM");
>=20
> I'll get you an TPM1.2 :)
>=20
> Thanks
> Peter
