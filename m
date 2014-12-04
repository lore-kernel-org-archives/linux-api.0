From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 0/8] TPM 2.0 support
Date: Thu, 4 Dec 2014 07:57:34 +0200
Message-ID: <20141204055734.GA5379@intel.com>
References: <1417672167-3489-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417672167-3489-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

Please ignore this one. Sent another one with v9 prefixes. Sorry!

/Jarkko

On Thu, Dec 04, 2014 at 07:49:19AM +0200, Jarkko Sakkinen wrote:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces. This patch set does not export any sysfs attributes for
> TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> 
> - They are associated with the platform device instead of character
>   device.
> - They are are not trivial key-value pairs but contain text that is
>   not easily parsed by a computer.
> - Raciness as described in
>   http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
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
> v9:
> - Fixed compilation issues in v8 (sorry for not using the correct
>   tree).
> - Just do "return tpm_chip_register();" instead of copying return
>   value to a variable.
> - Removed unused tpm2_startup().
> - In the CRB driver ACPI TPM2 table could contain platform specific
>   and therefore inequality test does not work. Changed check whether
>   buffer size is less than mandatory fields in the ACPI TPM2 table.
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
>  drivers/char/tpm/tpm-chip.c         | 251 +++++++++++++++++
>  drivers/char/tpm/tpm-dev.c          |  42 +--
>  drivers/char/tpm/tpm-interface.c    | 261 ++++++-----------
>  drivers/char/tpm/tpm-sysfs.c        |  29 +-
>  drivers/char/tpm/tpm.h              | 107 +++++--
>  drivers/char/tpm/tpm2-cmd.c         | 542 ++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_atmel.c        |  25 +-
>  drivers/char/tpm/tpm_crb.c          | 356 +++++++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c    |  55 ++--
>  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |  71 ++---
>  drivers/char/tpm/tpm_i2c_stm_st33.c |  28 +-
>  drivers/char/tpm/tpm_ibmvtpm.c      |  17 +-
>  drivers/char/tpm/tpm_infineon.c     |  51 ++--
>  drivers/char/tpm/tpm_nsc.c          |  34 ++-
>  drivers/char/tpm/tpm_ppi.c          | 137 +++++----
>  drivers/char/tpm/tpm_tis.c          | 192 ++++++++-----
>  drivers/char/tpm/xen-tpmfront.c     |  14 +-
>  20 files changed, 1689 insertions(+), 578 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-chip.c
>  create mode 100644 drivers/char/tpm/tpm2-cmd.c
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> -- 
> 2.1.0
> 
