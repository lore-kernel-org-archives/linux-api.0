From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 4/5] arm64: Add support for Spreadtrum's Sharkl64
 Platform in Kconfig and defconfig
Date: Fri, 16 Jan 2015 10:48:42 +0000
Message-ID: <20150116104842.GE21809@leverpostej>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-5-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421402411-3479-5-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel.Schopp@amd.c
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 10:00:10AM +0000, Chunyan Zhang wrote:
> From: Zhizhou Zhang <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> 
> Adds support for Spreadtrum's SoC Platform in the arm64 Kconfig and
> defconfig files.
> 
> Signed-off-by: Zhizhou Zhang <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Signed-off-by: Orson Zhai <orson.zhai-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> ---
>  arch/arm64/Kconfig           |    5 +++++
>  arch/arm64/configs/defconfig |    1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b1f9a20..885c1f4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -153,6 +153,11 @@ config ARCH_SEATTLE
>  	help
>  	  This enables support for AMD Seattle SOC Family
>  
> +config ARCH_SPRD

This should presumably be ARCH_SHARKL64, so you can add other SoC
families later. The other entries in here are already formatted that
way.

I wonder if we should have these of the form ARCH_${VENDOR}_${FAMILY}
(e.g. ARCH_SPRD_SHARKL64) rather than just ARCH_${FAMILY} to save
ourselves from name conflicts in future (and to make it easier to grep
for a particular vendor's config options).

> +	bool "Spreadtrum SoC platform"

bool "Spreadtrun Sharkl64 SoC Family"

> +	help
> +	  Support for Spreadtrum ARM based SoCs


Support for the Spreadtrum Sharkl64 SoC family.

Thanks,
Mark.

> +
>  config ARCH_THUNDER
>  	bool "Cavium Inc. Thunder SoC Family"
>  	help
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index dd301be..c1677ca 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -33,6 +33,7 @@ CONFIG_MODULE_UNLOAD=y
>  # CONFIG_BLK_DEV_BSG is not set
>  # CONFIG_IOSCHED_DEADLINE is not set
>  CONFIG_ARCH_THUNDER=y
> +CONFIG_ARCH_SPRD=y
>  CONFIG_ARCH_VEXPRESS=y
>  CONFIG_ARCH_XGENE=y
>  CONFIG_PCI=y
> -- 
> 1.7.9.5
> 
> 
