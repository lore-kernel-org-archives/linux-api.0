From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 29/29] MAINTAINERS: add entry for FPGA DFL drivers
Date: Wed, 13 Jun 2018 06:50:55 -0700
Message-ID: <20180613135055.GA3866@archbook>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-30-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528798243-2029-30-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 06:10:43PM +0800, Wu Hao wrote:
> Add entry for FPGA Device Feature List (DFL) drivers.
> 
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 448957c..98fc5ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5619,6 +5619,14 @@ F:	drivers/fpga/
>  F:	include/linux/fpga/
>  W:	http://www.rocketboards.org
>  
> +FPGA DFL DRIVERS
> +M:	Wu Hao <hao.wu@intel.com>
> +L:	linux-fpga@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/fpga/dfl.txt
> +F:	include/uapi/linux/fpga-dfl.h
> +F:	drivers/fpga/dfl*
> +
>  FPU EMULATOR
>  M:	Bill Metzenthen <billm@melbpc.org.au>
>  W:	http://floatingpoint.sourceforge.net/emulator/index.html
> -- 
> 1.8.3.1
> 

Thanks,
Moritz
