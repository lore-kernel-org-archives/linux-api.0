From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/5] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Tue, 25 Nov 2014 13:52:42 +0100
Message-ID: <2672926.PUHDU64fHa@wuerfel>
References: <1416917818-10506-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1416917818-10506-3-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com, gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net, broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday 25 November 2014 20:16:55 Chunyan Zhang wrote:
> diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> new file mode 100644
> index 0000000..54e532f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> @@ -0,0 +1,6 @@
> +* Spreadtrum serial UART
> +
> +Required properties:
> +- compatible: must be "sprd,sc9836-uart"
> +- reg: offset and length of the register set for the device
> +- interrupts: exactly one interrupt specifier
> 

The driver uses a clock, and the dts file lists a clock
property, so it should be documented here, either as optional
or mandatory, and with a description what this clock refers to.

	Arnd
