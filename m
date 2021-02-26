Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900A1C433DB
	for <linux-api@archiver.kernel.org>; Fri, 26 Feb 2021 12:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3972164D9F
	for <linux-api@archiver.kernel.org>; Fri, 26 Feb 2021 12:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBZMyC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 26 Feb 2021 07:54:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49182 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZMyB (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 26 Feb 2021 07:54:01 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EF4EF580;
        Fri, 26 Feb 2021 13:53:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1614343999;
        bh=LYN1xxISJasdZzU6yYhtZjYnXw5AND9OFkY4FM/4VC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Czdu4Nuo1+9gO0LaVVNAzm6YfbFoe1kadIF2+jliSAM/7PLZ2j9zD1WCKdM6jukhg
         mEBB5Rc+q/ZcK7HhZsEE/UFx/yHQixVij4kD57AZ6w5kwQ45VeSiHBMYmcS2VO6Spq
         dGHr7tdIUY2uAsErcsqXDysN//tf6Px/bVxdLCWs=
Date:   Fri, 26 Feb 2021 14:52:51 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Dirk Behme <Dirk.Behme@de.bosch.com>,
        Peter Erben <Peter.Erben@de.bosch.com>
Subject: Re: [PATCH 7/7] arm64: configs: Add R-Car DAB support
Message-ID: <YDjvI6DTcBfWdA3G@pendragon.ideasonboard.com>
References: <20210225225147.29920-1-fabrizio.castro.jz@renesas.com>
 <20210225225147.29920-8-fabrizio.castro.jz@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210225225147.29920-8-fabrizio.castro.jz@renesas.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Fabrizio,

Thank you for the patch.

On Thu, Feb 25, 2021 at 10:51:47PM +0000, Fabrizio Castro wrote:
> Make sure that the R-Car DAB device driver gets compiled as a
> module since R-Car E3 and R-Car M3-N come with the DAB IP.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

Do we need this in the defconfig ? It's not required to have a bootable
E3 or M3-N with the set of standard features, and would result in all
ARM64 platforms having one module they don't care about.

> ---
>  arch/arm64/configs/defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index d612f633b771..3b9996c7f1fc 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -274,6 +274,7 @@ CONFIG_PCI_ENDPOINT_TEST=m
>  CONFIG_EEPROM_AT24=m
>  CONFIG_EEPROM_AT25=m
>  CONFIG_UACCE=m
> +CONFIG_RCAR_DAB=m
>  # CONFIG_SCSI_PROC_FS is not set
>  CONFIG_BLK_DEV_SD=y
>  CONFIG_SCSI_SAS_ATA=y

-- 
Regards,

Laurent Pinchart
