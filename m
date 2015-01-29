From: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH v2] tpm: fix suspend/resume paths for TPM 2.0
Date: Thu, 29 Jan 2015 18:43:12 +0000 (UTC)
Message-ID: <alpine.DEB.2.11.1501291832460.1678@localhost.localdomain>
References: <1422510227-23256-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1048875714-1422556658=:1678"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422510227-23256-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-ID: <alpine.DEB.2.11.1501291838020.1678@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh@joshtriplett.org, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1048875714-1422556658=:1678
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.11.1501291838021.1678@localhost.localdomain>

On Thu, 29 Jan 2015, Jarkko Sakkinen wrote:
> Fixed suspend/resume paths for TPM 2.0 and consolidated all the
> associated code to the tpm_pm_suspend() and tpm_pm_resume()
> functions. Resume path should be handled by the firmware, i.e.
> Startup(CLEAR) for hibernate and Startup(STATE) for suspend.
> 
> There might be some non-PC embedded devices in the future where
> Startup() is not the handled by the FW but fixing the code for
> those IMHO should be postponed until there is hardware available
> to test the fixes although extra Startup in the driver code is
> essentially a NOP.
> 
> Added Shutdown(CLEAR) to the remove paths of TIS and CRB drivers.
> Changed tpm2_shutdown() to a void function because there isn't
> much you can do except print an error message if this fails with
> a system error.
> 
> Reported-by: Peter Hüwe <PeterHuewe@gmx.de>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-interface.c |  6 ++++--
>  drivers/char/tpm/tpm.h           |  2 +-
>  drivers/char/tpm/tpm2-cmd.c      | 19 +++++++++++--------
>  drivers/char/tpm/tpm_crb.c       | 20 +++++---------------
>  drivers/char/tpm/tpm_tis.c       | 26 +++++++++++++-------------
>  5 files changed, 34 insertions(+), 39 deletions(-)

Resume still functions on TPM 1.2 chip, with and without CONFIG_TCG_CRB.

Tested-by: Scot Doyle <lkml14@scotdoyle.com>
--8323328-1048875714-1422556658=:1678--
