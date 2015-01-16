From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 16 Jan 2015 10:35:59 +0000
Message-ID: <20150116103558.GD21809@leverpostej>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-4-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421402411-3479-4-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel.Schopp@amd.c
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 10:00:09AM +0000, Chunyan Zhang wrote:
> From: Zhizhou Zhang <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> 
> Adds the device tree support for Spreadtrum SC9836 SoC which is based on
> Sharkl64 platform.
> 
> Sharkl64 platform contains the common nodes of Spreadtrum's arm64-based SoCs.
> 
> Signed-off-by: Zhizhou Zhang <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Signed-off-by: Orson Zhai <orson.zhai-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> ---
>  arch/arm64/boot/dts/Makefile                  |    1 +
>  arch/arm64/boot/dts/sprd/Makefile             |    5 ++
>  arch/arm64/boot/dts/sprd/sc9836-openphone.dts |   49 +++++++++++++++++
>  arch/arm64/boot/dts/sprd/sc9836.dtsi          |   73 +++++++++++++++++++++++++
>  arch/arm64/boot/dts/sprd/sharkl64.dtsi        |   67 +++++++++++++++++++++++
>  5 files changed, 195 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/sprd/Makefile
>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
>  create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
>  create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi

[...]

> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53", "arm,armv8";
> +			reg = <0x0 0x0>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu@1 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53", "arm,armv8";
> +			reg = <0x0 0x1>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu@2 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53", "arm,armv8";
> +			reg = <0x0 0x2>;
> +			enable-method = "psci";
> +		};
> +
> +		cpu@3 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a53", "arm,armv8";
> +			reg = <0x0 0x3>;
> +			enable-method = "psci";
> +		};
> +	};

Just to check, all CPUs may be hotplugged off and on, yes?

Including CPU0?

How is your implementation tested?

You boot CPUs at EL2?

> +
> +	gic: interrupt-controller@12001000 {
> +		compatible = "arm,gic-400";
> +		#interrupt-cells = <3>;
> +		interrupt-controller;
> +		reg = <0 0x12001000 0 0x1000>,
> +		      <0 0x12002000 0 0x2000>,
> +		      <0 0x12004000 0 0x2000>,
> +		      <0 0x12006000 0 0x2000>;
> +	};

You're missing the maintenance interrupt here.

[...]

> diff --git a/arch/arm64/boot/dts/sprd/sharkl64.dtsi b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> new file mode 100644
> index 0000000..b08989d
> --- /dev/null
> +++ b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
> @@ -0,0 +1,67 @@
> +/*
> + * Spreadtrum Sharkl64 platform DTS file
> + *
> + * Copyright (C) 2014, Spreadtrum Communications Inc.
> + *
> + * This file is licensed under a dual GPLv2 or X11 license.
> + */
> +
> +/ {
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	soc {
> +		compatible = "simple-bus";
> +		reg = <0x0 0x0 0x0 0x80000000>;

What is this reg for? It's not required by simple-bus.

If you want to encode that this covers a particular portion of the
address space, do so with the ranges proeprty.

> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +
> +		ap_apb: apb@70000000 {
> +			compatible = "simple-bus";
> +			reg = <0x0 0x70000000 0x0 0x10000000>;

Likewise here.

Thanks,
Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
