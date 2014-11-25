From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Tue, 25 Nov 2014 13:59:42 +0100
Message-ID: <5003189.80rNq67D5Z@wuerfel>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com, gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net, broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday 25 November 2014 20:16:53 Chunyan Zhang wrote:
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
> 
> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
> standards based on ARMv8 multiple core architecture.Now we have only one
> SoC(SC9836) based on this Platform in developing.
> 
> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
> of SC9836-UART.
> 
> This patchset also has patches which address "sprd" prefix and DT compatible
> strings for nodes which appear un-documented.
> 
> This version code was tesed on Fast Mode.
> We use boot-wrapper-aarch64 as the bootloader.

Looks very good overall. I have two small comments to individual patches,
but I think we can still merge them for 3.19. Please send the serial
driver to Greg for inclusion, unless you get further comments, and send
the updated version of the other patches to arm@kernel.org and ask
for including them in the cover letter.

	Arnd
