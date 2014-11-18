From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v7 00/10] TPM 2.0 support
Date: Tue, 18 Nov 2014 08:33:15 +0200
Message-ID: <20141118063314.GA5847@intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

Any feedback?

/Jarkko

On Tue, Nov 11, 2014 at 03:45:03PM +0200, Jarkko Sakkinen wrote:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces.
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
> Opens:
> - What we should do with PPI and BIOS log sysfs attributes?
>   Can we associate them with the character device without
>   breaking anything? Can we postpone this issue after
>   this patch set has been pulled?
> 
> Jarkko Sakkinen (9):
>   tpm: merge duplicate transmit_cmd() functions
>   tpm: two-phase chip management functions
>   tpm: fix multiple race conditions in tpm_ppi.c
>   tpm: rename chip->dev to chip->pdev
>   tpm: device class for tpm
>   tpm: fix: move sysfs attributes to the correct place.
>   tpm: TPM 2.0 baseline support
>   tpm: TPM 2.0 CRB Interface
>   tpm: TPM 2.0 sysfs attributes
> 
> Will Arthur (1):
>   tpm: TPM 2.0 FIFO Interface
> 
>  Documentation/ABI/stable/sysfs-class-tpm2 |  57 +++
>  drivers/char/tpm/Kconfig                  |   9 +
>  drivers/char/tpm/Makefile                 |   3 +-
>  drivers/char/tpm/tpm-chip.c               | 266 ++++++++++++++
>  drivers/char/tpm/tpm-dev.c                |  44 +--
>  drivers/char/tpm/tpm-interface.c          | 261 +++++---------
>  drivers/char/tpm/tpm-sysfs.c              |  46 +--
>  drivers/char/tpm/tpm.h                    | 134 ++++++-
>  drivers/char/tpm/tpm2-cmd.c               | 566 ++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm2-sysfs.c             | 152 ++++++++
>  drivers/char/tpm/tpm_atmel.c              |  25 +-
>  drivers/char/tpm/tpm_crb.c                | 323 +++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c          |  49 +--
>  drivers/char/tpm/tpm_i2c_infineon.c       |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c        |  68 ++--
>  drivers/char/tpm/tpm_i2c_stm_st33.c       |  44 +--
>  drivers/char/tpm/tpm_ibmvtpm.c            |  17 +-
>  drivers/char/tpm/tpm_infineon.c           |  51 +--
>  drivers/char/tpm/tpm_nsc.c                |  34 +-
>  drivers/char/tpm/tpm_ppi.c                | 136 ++++---
>  drivers/char/tpm/tpm_tis.c                | 180 ++++++----
>  drivers/char/tpm/xen-tpmfront.c           |  14 +-
>  22 files changed, 1920 insertions(+), 602 deletions(-)
>  create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
>  create mode 100644 drivers/char/tpm/tpm-chip.c
>  create mode 100644 drivers/char/tpm/tpm2-cmd.c
>  create mode 100644 drivers/char/tpm/tpm2-sysfs.c
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> -- 
> 2.1.0
> 
