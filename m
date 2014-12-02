From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH v8 7/8] tpm: TPM 2.0 CRB Interface
Date: Wed, 3 Dec 2014 00:10:33 +0100
Message-ID: <201412030010.33869.PeterHuewe@gmx.de>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417559480-13757-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

Am Dienstag, 2. Dezember 2014, 23:31:19 schrieb Jarkko Sakkinen:
> tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Interface
> as defined in PC Client Platform TPM Profile (PTP) Specification.
> 
> Only polling and single locality is supported as these are the limitations
> of the available hardware, Platform Trust Techonlogy (PTT) in Haswell
> CPUs.
> 
> The driver always applies CRB with ACPI start because PTT reports using
> only ACPI start as start method but as a result of my testing it requires
> also CRB start.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---

If I apply it on top of security/next or linux-3.18-rc6 I get the following 
compile error:

drivers/char/tpm/tpm_crb.c: In function 'crb_acpi_add':
drivers/char/tpm/tpm_crb.c:271:6: error: too many arguments to function 
'acpi_device_hid'
In file included from include/linux/acpi.h:43:0,
                 from drivers/char/tpm/tpm_crb.c:18:
include/acpi/acpi_bus.h:253:13: note: declared here
drivers/char/tpm/tpm_crb.c:271:6: error: too few arguments to function 
'strcmp'
scripts/Makefile.build:263: recipe for target 'drivers/char/tpm/tpm_crb.o' 
failed
make[3]: *** [drivers/char/tpm/tpm_crb.o] Error 1
scripts/Makefile.build:402: recipe for target 'drivers/char/tpm' failed
make[2]: *** [drivers/char/tpm] Error 2
scripts/Makefile.build:402: recipe for target 'drivers/char' failed
make[1]: *** [drivers/char] Error 2
Makefile:937: recipe for target 'drivers' failed


Please compile test your stuff.

;-(
Peter
