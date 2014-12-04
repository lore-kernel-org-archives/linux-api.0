From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH v9 7/8] tpm: TPM 2.0 CRB Interface
Date: Thu, 4 Dec 2014 21:19:21 +0100
Message-ID: <201412042119.21493.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:17 schrieb Jarkko Sakkinen:
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

:(

 make -C /data/data-old/linux-2.6/ M=$(pwd) modules C=1 CHECK=sparse
make: Entering directory '/data/data-old/linux-2.6'
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:99:5: warning: symbol 'crb_suspend' was not declared. Should it be static?
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63: warning: incorrect type in argument 2 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56: warning: incorrect type in argument 2 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27: warning: incorrect type in argument 2 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:277:22: warning: cast removes address space of expression
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33: warning: incorrect type in argument 2 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    expected void const volatile [noderef] <asn:2>*src
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    got unsigned long long *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19: warning: incorrect type in assignment (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    expected unsigned char [usertype] *cmd
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    got void [noderef] <asn:2>*
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33: warning: incorrect type in argument 2 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    expected void const volatile [noderef] <asn:2>*src
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    got unsigned long long *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56: warning: incorrect type in argument 1 (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    expected void [noderef] <asn:2>*<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    got unsigned int *<noident>
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19: warning: incorrect type in assignment (different address spaces)
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    expected unsigned char [usertype] *rsp
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    got void [noderef] <asn:2>*
/data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:325:5: warning: symbol 'crb_acpi_remove' was not declared. Should it be static?
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.o

:(
Peter
