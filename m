From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Mon, 14 Mar 2016 18:26:02 +0200
Message-ID: <20160314162602.GA24203@intel.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:
> This patch implements a proxy driver for supporting multiple emulated TPMs
> in a system.
> 
> The driver implements a device /dev/vtpmx that is used to created
> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
> is accessed using a file descriptor returned by an ioctl.
> The device /dev/tpmX is the usual TPM device created by the core TPM
> driver. Applications or kernel subsystems can send TPM commands to it
> and the corresponding server-side file descriptor receives these
> commands and delivers them to an emulated TPM.

Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

My testing procedure was:

* Wine running TPM 2.0 simulator on the host side. [1]
* QEMU running an OS image with this patch. [2]
* Wrote a script for proxying the simulator: tpm2-simulator-vtpm. [3]
* Run some smoke tests: python -m unittest -v tpm2_smoke. [3]

[1] http://research.microsoft.com/en-us/downloads/35116857-e544-4003-8e7b-584182dc6833/
[2] git://git.infradead.org/users/jjs/buildroot-tpmdd.git
[3] git://git.infradead.org/users/jjs/tpm2-scripts.git

/Jarkko

> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> CC: linux-kernel@vger.kernel.org
> CC: linux-doc@vger.kernel.org
> CC: linux-api@vger.kernel.org
> ---
>  drivers/char/tpm/Kconfig          |  10 +
>  drivers/char/tpm/Makefile         |   1 +
>  drivers/char/tpm/tpm_vtpm_proxy.c | 572 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |   1 +
>  include/uapi/linux/vtpm_proxy.h   |  42 +++
>  5 files changed, 626 insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_vtpm_proxy.c
>  create mode 100644 include/uapi/linux/vtpm_proxy.h

/Jarkko
