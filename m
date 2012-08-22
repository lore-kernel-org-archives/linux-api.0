From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 0/2] Add PPI support in tpm driver
Date: Wed, 22 Aug 2012 16:41:30 -0500
Message-ID: <20120822214130.GA13519@linux.vnet.ibm.com>
References: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
To: xiaoyan.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, joseph.cihula@intel.com, gang.wei@intel.com, tpmdd-devel@lists.sourceforge.net, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com, shpedoikal@gmail.com, linux-security-module@vger.kernel.org, james.l.morris@oracle.com, hpa@zytor.com, linux-api@vger.kernel.org, yoder1@us.ibm.com
List-Id: linux-api@vger.kernel.org

On Wed, Aug 22, 2012 at 06:47:20PM +0800, xiaoyan.zhang@intel.com wrote:
> From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> 
> The Physical Presence Interface enables the OS and the BIOS to cooperate to
> provide a simple and straightforward platform user experience for
> administering the TPM without sacrificing security.

  Thanks Xiaoyan, I'm including this in my next pull request to James.

Kent

> Xiaoyan Zhang (2):
>   Documentation: sysfs for Physical Presence Interface
>   driver: add PPI support in tpm driver
> 
>  Documentation/ABI/testing/sysfs-driver-ppi |   70 +++++
>  drivers/char/tpm/Makefile                  |    2 +-
>  drivers/char/tpm/tpm.c                     |    5 +
>  drivers/char/tpm/tpm.h                     |    9 +
>  drivers/char/tpm/tpm_ppi.c                 |  460 ++++++++++++++++++++++++++++
>  5 files changed, 545 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi
>  create mode 100644 drivers/char/tpm/tpm_ppi.c
> 
> -- 
> 1.7.7.6
> 

