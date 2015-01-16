From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 2/5] Documentation: DT: Add bindings for Spreadtrum
 SoC Platform
Date: Fri, 16 Jan 2015 10:21:35 +0000
Message-ID: <20150116102135.GC21809@leverpostej>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421402411-3479-3-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel.Schopp@amd.c
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 10:00:08AM +0000, Chunyan Zhang wrote:
> Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
> Adds the devicetree binding documentations for Spreadtrum's sc9836-uart
> and SC9836 SoC based on the Sharkl64 Platform which is a 64-bit SoC
> Platform of Spreadtrum.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Signed-off-by: Orson Zhai <orson.zhai-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
>  .../devicetree/bindings/serial/sprd-uart.txt       |    7 +++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  3 files changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
>  create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
> new file mode 100644
> index 0000000..31a629d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/sprd.txt
> @@ -0,0 +1,11 @@
> +Spreadtrum SoC Platforms Device Tree Bindings
> +----------------------------------------------------
> +
> +Sharkl64 is a Spreadtrum's SoC Platform which is based
> +on ARM 64-bit processor.
> +
> +SC9836 openphone board with SC9836 SoC based on the
> +Sharkl64 Platform shall have the following properties.
> +
> +Required root node properties:
> +        - compatible = "sprd,sc9836-openphone", "sprd,sc9836";
> diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> new file mode 100644
> index 0000000..2aff0f2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> @@ -0,0 +1,7 @@
> +* Spreadtrum serial UART
> +
> +Required properties:
> +- compatible: must be "sprd,sc9836-uart"
> +- reg: offset and length of the register set for the device
> +- interrupts: exactly one interrupt specifier
> +- clocks: phandles to input clocks.

The order and relevance of each should be specified. If you have
multiple clocks I would strongly recommend you use clock-names to
distinguish them.

Otherwise this looks fine.

Mark.

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index b1df0ad..0a8384f 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -153,6 +153,7 @@ snps	Synopsys, Inc.
>  solidrun	SolidRun
>  sony	Sony Corporation
>  spansion	Spansion Inc.
> +sprd	Spreadtrum Communications Inc.
>  st	STMicroelectronics
>  ste	ST-Ericsson
>  stericsson	ST-Ericsson
> -- 
> 1.7.9.5
> 
> 
