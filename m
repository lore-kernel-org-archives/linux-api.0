From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Fri, 5 Dec 2014 15:05:33 +0200
Message-ID: <20141205130533.GA6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.11.1412041459470.5705@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412041459470.5705-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 04, 2014 at 03:25:12PM +0000, Scot Doyle wrote:
> Hi Jarkko,
> 
> On Thu, 4 Dec 2014, Jarkko Sakkinen wrote:
> > From: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> > instead of calling tpm_get_timeouts(), assign duration and timeout
> > values defined in the TPM 2.0 PTP specification.
> > 
> > Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_tis.c | 80 ++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 67 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index 89e1abb..71cbb2d 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -1,5 +1,6 @@
> >  /*
> >   * Copyright (C) 2005, 2006 IBM Corporation
> > + * Copyright (C) 2014 Intel Corporation
> >   *
> >   * Authors:
> >   * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> > @@ -44,6 +45,10 @@ enum tis_status {
> >  	TPM_STS_DATA_EXPECT = 0x08,
> >  };
> >  
> > +enum tis_status3 {
> > +	TPM_STS3_TPM2_FAM = 0x04,
> > +};
> > +
> >  enum tis_int_flags {
> >  	TPM_GLOBAL_INT_ENABLE = 0x80000000,
> >  	TPM_INTF_BURST_COUNT_STATIC = 0x100,
> > @@ -70,6 +75,7 @@ enum tis_defaults {
> >  #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
> >  #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
> >  #define	TPM_STS(l)			(0x0018 | ((l) << 12))
> > +#define	TPM_STS3(l)			(0x001b | ((l) << 12))
> >  #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
> >  
> >  #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
> > @@ -363,6 +369,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
> >  {
> >  	int rc;
> >  	u32 ordinal;
> > +	unsigned long dur;
> >  
> >  	rc = tpm_tis_send_data(chip, buf, len);
> >  	if (rc < 0)
> > @@ -374,9 +381,14 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
> >  
> >  	if (chip->vendor.irq) {
> >  		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > +
> > +		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +			dur = tpm2_calc_ordinal_duration(chip, ordinal);
> > +		else
> > +			dur = tpm_calc_ordinal_duration(chip, ordinal);
> > +
> >  		if (wait_for_tpm_stat
> > -		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> > -		     tpm_calc_ordinal_duration(chip, ordinal),
> > +		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
> >  		     &chip->vendor.read_queue, false) < 0) {
> >  			rc = -ETIME;
> >  			goto out_err;
> > @@ -588,6 +600,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> >  	int rc, i, irq_s, irq_e, probe;
> >  	struct tpm_chip *chip;
> >  	struct priv_data *priv;
> > +	u8 sts3;
> >  
> >  	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
> >  	if (priv == NULL)
> > @@ -604,11 +617,28 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> >  	if (!chip->vendor.iobase)
> >  		return -EIO;
> >  
> > +	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> > +	if ((sts3 & TPM_STS3_TPM2_FAM) == TPM_STS3_TPM2_FAM)
> > +		chip->flags = TPM_CHIP_FLAG_TPM2;
> > +
> >  	/* Default timeouts */
> > -	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > -	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > +		chip->vendor.timeout_a = usecs_to_jiffies(TPM2_TIMEOUT_A);
> > +		chip->vendor.timeout_b = usecs_to_jiffies(TPM2_TIMEOUT_B);
> > +		chip->vendor.timeout_c = usecs_to_jiffies(TPM2_TIMEOUT_C);
> > +		chip->vendor.timeout_d = usecs_to_jiffies(TPM2_TIMEOUT_D);
> > +		chip->vendor.duration[TPM_SHORT] =
> > +			usecs_to_jiffies(TPM2_DURATION_SHORT);
> > +		chip->vendor.duration[TPM_MEDIUM] =
> > +			usecs_to_jiffies(TPM2_DURATION_MEDIUM);
> > +		chip->vendor.duration[TPM_LONG] =
> > +			usecs_to_jiffies(TPM2_DURATION_LONG);
> > +	} else {
> > +		chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > +		chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	}
> >  
> >  	if (wait_startup(chip, 0) != 0) {
> >  		rc = -ENODEV;
> > @@ -623,8 +653,8 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> >  	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> >  	chip->vendor.manufacturer_id = vendor;
> >  
> > -	dev_info(dev,
> > -		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
> > +	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> > +		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> >  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
> >  
> >  	if (!itpm) {
> > @@ -665,6 +695,23 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> >  	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
> >  		dev_dbg(dev, "\tData Avail Int Support\n");
> >  
> > +	/* get the timeouts before testing for irqs */
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2) && tpm_get_timeouts(chip)) {
> > +		dev_err(dev, "Could not get TPM timeouts and durations\n");
> > +		rc = -ENODEV;
> > +		goto out_err;
> > +	}
> > +
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		rc = tpm2_do_selftest(chip);
> > +	else
> > +		rc = tpm_do_selftest(chip);
> > +	if (rc) {
> > +		dev_err(dev, "TPM self test failed\n");
> > +		rc = -ENODEV;
> > +		goto out_err;
> > +	}
> > +
> >  	/* INTERRUPT Setup */
> >  	init_waitqueue_head(&chip->vendor.read_queue);
> >  	init_waitqueue_head(&chip->vendor.int_queue);
> 
> In Peter's for-james branch, commit 0e6cb01, the v1.2 calls to
> tpm_get_timeouts and tpm_do_selftest were moved toward the end of 
> tpm_tis_init.

Right. My bad. Could this be reverted with a separate fix or do
I prepare a new patch set? I would propose the former...

> > @@ -720,7 +767,10 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> >  			chip->vendor.probed_irq = 0;
> >  
> >  			/* Generate Interrupts */
> > -			tpm_gen_interrupt(chip);
> > +			if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +				tpm2_gen_interrupt(chip);
> > +			else
> > +				tpm_gen_interrupt(chip);
> >  
> >  			chip->vendor.irq = chip->vendor.probed_irq;
> >  
> > @@ -808,14 +858,18 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> >  static int tpm_tis_resume(struct device *dev)
> >  {
> >  	struct tpm_chip *chip = dev_get_drvdata(dev);
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	if (chip->vendor.irq)
> >  		tpm_tis_reenable_interrupts(chip);
> >  
> > -	ret = tpm_pm_resume(dev);
> > -	if (!ret)
> > -		tpm_do_selftest(chip);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		tpm2_do_selftest(chip);
> > +	else {
> > +		ret = tpm_pm_resume(dev);
> > +		if (!ret)
> > +			tpm_do_selftest(chip);
> > +	}
> >  
> >  	return ret;
> >  }
> > -- 
> > 2.1.0
> > 

/Jarkko
