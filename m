From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:21:07 +0100
Message-ID: <201412030021.07882.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <201412030016.20268.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201412030016.20268.PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 00:16:19 schrieb Peter H=FCwe:
> Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> > This patch set enables TPM2 protocol and provides drivers for FIFO =
and
> > CRB interfaces. This patch set does not export any sysfs attributes=
 for
> > TPM 2.0 because existing sysfs attributes have three non-trivial is=
sues:
> >=20
> > - They are associated with the platform device instead of character
> >=20
> >   device.
> >=20
> > - They are are not trivial key-value pairs but contain text that is
> >=20
> >   not easily parsed by a computer.
> >=20
> > - Raciness as described in
> >=20
> > http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-cor=
rectly
> > /
> >=20
> > This is too big effort to be included into this patch set and requi=
res
> > more discussion.
> >=20
> > v2:
> > - Improved struct tpm_chip life-cycle by taking advantage of devres
> >=20
> >   API.
> >=20
> > - Refined sysfs attributes as simple key-values thereby not repeati=
ng
> >=20
> >   mistakes in TPM1 sysfs attributes.
> >=20
> > - Documented functions in tpm-chip.c and tpm2-cmd.c.
> > - Documented sysfs attributes.
> >=20
> > v3:
> > - Lots of fixes in calling order in device drivers (thanks to Jason
> >=20
> >   Gunthorpe for pointing these out!).
> >=20
> > - Attach sysfs attributes to the misc device because it represents
> >=20
> >   TPM device to the user space.
> >=20
> > v4:
> > - Disable sysfs attibutes for TPM 2.0 for until we can sort out the
> >=20
> >   best approach for them.
> >=20
> > - Fixed all the style issues found with checkpatch.pl.
> >=20
> > v5:
> > - missing EXPORT_SYMBOL_GPL()
> > - own class for TPM devices used for TPM 2.0 devices and onwards.
> >=20
> > v6:
> > - Non-racy initialization for sysfs attributes using struct device'=
s
> >=20
> >   groups field.
> >=20
> > - The class 'tpm' is used now for all TPM devices. For the first de=
vice
> >=20
> >   node major MISC_MAJOR and minor TPM_MINOR is used in order to ret=
ain
> >   backwards compatability.
> >=20
> > v7:
> > - Release device number and free struct tpm_chip memory inside
> >=20
> >   tpm_dev_release callback.
> >=20
> > - Moved code from tpm-interface.c and tpm_dev.c to tpm-chip.c.
> >=20
> > v8:
> > - Cleaned up unneeded cast from tpm_transmit_cmd().
> > - Cleaned up redundant PPI_VERSION_LEN constant from tpm_ppi.c.
> > - Fixed tpm_tis to use tpm2_calc_ordinal_duration() for TPM2 device=
s.
> > - tpm_crb: in crb_recv, check that count can hold the TPM header at
> >=20
> >   minimum.
> >=20
> > - tpm_crb: add enumerations for bit flags in start and cancel field=
s
> >=20
> >   of the control area.
> >=20
> > - tpm_crb: use ioremap() for command and response buffer because
> >=20
> >   they might be anywhere.
> >=20
> > - tpm_crb: use IO access functions for reading ioremapped buffers
> >=20
> >   because using direct pointers is not portable.
> >=20
> > - tpm_crb: only apply ACPI start if start method reported by the
> >=20
> >   TPM2 ACPI table allows it.
> >=20
> > - In tpm2_pcr_read() just calculate index and bit and get rid of
> >=20
> >   hacky loop.
> >=20
> > - Do not add sysfs attributes for TPM 2.0 devices.
> >=20
> > Jarkko Sakkinen (7):
> >   tpm: merge duplicate transmit_cmd() functions
> >   tpm: two-phase chip management functions
> >   tpm: fix raciness of PPI interface lookup
> >   tpm: rename chip->dev to chip->pdev
> >   tpm: device class for tpm
> >   tpm: TPM 2.0 baseline support
> >   tpm: TPM 2.0 CRB Interface
> >=20
> > Will Arthur (1):
> >   tpm: TPM 2.0 FIFO Interface
> > =20
> >  drivers/char/tpm/Kconfig            |   9 +
> >  drivers/char/tpm/Makefile           |   3 +-
> >  drivers/char/tpm/tpm-chip.c         | 251 ++++++++++++++++
> >  drivers/char/tpm/tpm-dev.c          |  42 +--
> >  drivers/char/tpm/tpm-interface.c    | 261 ++++++----------
> >  drivers/char/tpm/tpm-sysfs.c        |  29 +-
> >  drivers/char/tpm/tpm.h              | 113 ++++++-
> >  drivers/char/tpm/tpm2-cmd.c         | 571
> >=20
> > ++++++++++++++++++++++++++++++++++++ drivers/char/tpm/tpm_atmel.c  =
    =20
> > |
> >=20
> >  25 +-
> >  drivers/char/tpm/tpm_crb.c          | 356 ++++++++++++++++++++++
> >  drivers/char/tpm/tpm_i2c_atmel.c    |  49 ++--
> >  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
> >  drivers/char/tpm/tpm_i2c_nuvoton.c  |  68 ++---
>=20
> When applying to linux-v3.18-rc6 I get this new coccinelle warning:
> drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can =
be
> simpified
>=20
>=20
> make -C ../../../linux/ M=3D$(pwd) coccicheck
>=20
Consider folding this patch to remove the warning

----

=46rom cb1b82859ba98f8573624905d2b3cc8d10f456b2 Mon Sep 17 00:00:00 200=
1
=46rom: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Date: Wed, 3 Dec 2014 00:18:52 +0100
Subject: [PATCH] tpm:tpm_i2c_nuvoton: simpyl return statements

if !rc evals to false it is 0
-> we can return rc in both cases

Signed-off-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_=
i2c_nuvoton.c
index 14246e2..79f4fef 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -605,10 +605,8 @@ static int i2c_nuvoton_probe(struct i2c_client *cl=
ient,
 		return -ENODEV;
=20
 	rc =3D tpm_chip_register(chip);
-	if (rc)
-		return rc;
=20
-	return 0;
+	return rc;
 }
=20
 static int i2c_nuvoton_remove(struct i2c_client *client)
--=20
2.0.4
