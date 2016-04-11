From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 2/4] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Mon, 11 Apr 2016 11:43:58 +0300
Message-ID: <20160411084358.GB11322@intel.com>
References: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1459275554-12915-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160407123539.GA17489@intel.com>
 <57068198.6050407@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57068198.6050407@linux.vnet.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 11:49:44AM -0400, Stefan Berger wrote:
> On 04/07/2016 08:35 AM, Jarkko Sakkinen wrote:
> >On Tue, Mar 29, 2016 at 02:19:12PM -0400, Stefan Berger wrote:
> >>This patch implements a proxy driver for supporting multiple emulated TPMs
> >>in a system.
> >>
> >>The driver implements a device /dev/vtpmx that is used to created
> >>a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
> >>is accessed using a file descriptor returned by an ioctl.
> >>The device /dev/tpmX is the usual TPM device created by the core TPM
> >>driver. Applications or kernel subsystems can send TPM commands to it
> >>and the corresponding server-side file descriptor receives these
> >>commands and delivers them to an emulated TPM.
> >>
> >>Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> >>CC: linux-kernel@vger.kernel.org
> >>CC: linux-doc@vger.kernel.org
> >>CC: linux-api@vger.kernel.org
> >Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Thanks. So I can post a v10 where I have to re-introduce the priv field but
> put it into the tpm_chip struct. Obviously it needs this field. I am not
> sure whether you'll let me take the Reviewed-by and Tested-by, though?

Lets hold for them then. I'll do retest when I get the new series.

>    Stefan

/Jarkko
