From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Thu, 4 Dec 2014 22:46:25 +0100
Message-ID: <201412042246.25662.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Will Arthur <will.c.arthur@intel.com>
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> From: Will Arthur <will.c.arthur@intel.com>
> 
> Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> instead of calling tpm_get_timeouts(), assign duration and timeout
> values defined in the TPM 2.0 PTP specification.
> 
> Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
Should we change the KConfig string?
 TPM Interface Specification 1.2 Interface
is not quite accurate anymore after applying this patch.

Thanks,
Peter
