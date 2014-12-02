From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Date: Wed, 3 Dec 2014 00:16:19 +0100
Message-ID: <201412030016.20268.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417559480-13757-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces. This patch set does not export any sysfs attributes for
> TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> 
> - They are associated with the platform device instead of character
>   device.
> - They are are not trivial key-value pairs but contain text that is
>   not easily parsed by a computer.
> - Raciness as described in
>  
> http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
> 
> This is too big effort to be included into this patch set and requires
> more discussion.
> 
> v2:
> - Improved struct tpm_chip life-cycle by taking advantage of devres
>   API.
> - Refined sysfs attributes as simple key-values thereby not repeating
>   mistakes in TPM1 sysfs attributes.
> - Documented functions in tpm-chip.c and tpm2-cmd.c.
> - Documented sysfs attributes.
> 
> v3:
> - Lots of fixes in calling order in device drivers (thanks to Jason
>   Gunthorpe for pointing these out!).
> - Attach sysfs attributes to the misc device because it represents
>   TPM device to the user space.
> 
> v4:
> - Disable sysfs attibutes for TPM 2.0 for until we can sort out the
>   best approach for them.
> - Fixed all the style issues found with checkpatch.pl.
> 
> v5:
> - missing EXPORT_SYMBOL_GPL()
> - own class for TPM devices used for TPM 2.0 devices and onwards.
> 
> v6:
> - Non-racy initialization for sysfs attributes using struct device's
>   groups field.
> - The class 'tpm' is used now for all TPM devices. For the first device
>   node major MISC_MAJOR and minor TPM_MINOR is used in order to retain
>   backwards compatability.
> 
> v7:
> - Release device number and free struct tpm_chip memory inside
>   tpm_dev_release callback.
> - Moved code from tpm-interface.c and tpm_dev.c to tpm-chip.c.
> 
> v8:
> - Cleaned up unneeded cast from tpm_transmit_cmd().
> - Cleaned up redundant PPI_VERSION_LEN constant from tpm_ppi.c.
> - Fixed tpm_tis to use tpm2_calc_ordinal_duration() for TPM2 devices.
> - tpm_crb: in crb_recv, check that count can hold the TPM header at
>   minimum.
> - tpm_crb: add enumerations for bit flags in start and cancel fields
>   of the control area.
> - tpm_crb: use ioremap() for command and response buffer because
>   they might be anywhere.
> - tpm_crb: use IO access functions for reading ioremapped buffers
>   because using direct pointers is not portable.
> - tpm_crb: only apply ACPI start if start method reported by the
>   TPM2 ACPI table allows it.
> - In tpm2_pcr_read() just calculate index and bit and get rid of
>   hacky loop.
> - Do not add sysfs attributes for TPM 2.0 devices.
> 
> Jarkko Sakkinen (7):
>   tpm: merge duplicate transmit_cmd() functions
>   tpm: two-phase chip management functions
>   tpm: fix raciness of PPI interface lookup
>   tpm: rename chip->dev to chip->pdev
>   tpm: device class for tpm
>   tpm: TPM 2.0 baseline support
>   tpm: TPM 2.0 CRB Interface
> 
> Will Arthur (1):
>   tpm: TPM 2.0 FIFO Interface
> 
>  drivers/char/tpm/Kconfig            |   9 +
>  drivers/char/tpm/Makefile           |   3 +-
>  drivers/char/tpm/tpm-chip.c         | 251 ++++++++++++++++
>  drivers/char/tpm/tpm-dev.c          |  42 +--
>  drivers/char/tpm/tpm-interface.c    | 261 ++++++----------
>  drivers/char/tpm/tpm-sysfs.c        |  29 +-
>  drivers/char/tpm/tpm.h              | 113 ++++++-
>  drivers/char/tpm/tpm2-cmd.c         | 571
> ++++++++++++++++++++++++++++++++++++ drivers/char/tpm/tpm_atmel.c        |
>  25 +-
>  drivers/char/tpm/tpm_crb.c          | 356 ++++++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c    |  49 ++--
>  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |  68 ++---

When applying to linux-v3.18-rc6 I get this new coccinelle warning:
drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can be 
simpified


make -C ../../../linux/ M=$(pwd) coccicheck

Peter
