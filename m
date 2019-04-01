From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 01/17] fpga: dfl-fme-mgr: fix FME_PR_INTFC_ID register
 address.
Date: Mon, 1 Apr 2019 12:54:47 -0700
Message-ID: <20190401195447.GA1910@archbook>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-2-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1553483264-5379-2-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Wu,

On Mon, Mar 25, 2019 at 11:07:28AM +0800, Wu Hao wrote:
> FME_PR_INTFC_ID is used as compat_id for fpga manager and region,
> but high 64 bits and low 64 bits of the compat_id are swapped by
> mistake. This patch fixes this problem by fixing register address.
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
>  drivers/fpga/dfl-fme-mgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/fpga/dfl-fme-mgr.c b/drivers/fpga/dfl-fme-mgr.c
> index 76f3770..b3f7eee 100644
> --- a/drivers/fpga/dfl-fme-mgr.c
> +++ b/drivers/fpga/dfl-fme-mgr.c
> @@ -30,8 +30,8 @@
>  #define FME_PR_STS		0x10
>  #define FME_PR_DATA		0x18
>  #define FME_PR_ERR		0x20
> -#define FME_PR_INTFC_ID_H	0xA8
> -#define FME_PR_INTFC_ID_L	0xB0
> +#define FME_PR_INTFC_ID_L	0xA8
> +#define FME_PR_INTFC_ID_H	0xB0

Does this handle endianess correct?
>  
>  /* FME PR Control Register Bitfield */
>  #define FME_PR_CTRL_PR_RST	BIT_ULL(0)  /* Reset PR engine */
> -- 
> 2.7.4
> 

Cheers,
Moritz
