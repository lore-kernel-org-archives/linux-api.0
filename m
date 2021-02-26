Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D04C433E0
	for <linux-api@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C6A764F17
	for <linux-api@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBZImC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:42:02 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:40973 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhBZImA (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 26 Feb 2021 03:42:00 -0500
Received: by mail-oi1-f175.google.com with SMTP id o3so8993518oic.8;
        Fri, 26 Feb 2021 00:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVIlOjFdfdlIAo37nsDj9r1mNIwZgWtxa0P3cDr2L2s=;
        b=IPZ+4PTh+/kRFCrE7OgfyGes0FcJ72kAxJ9hq1ZcZ4IAsrGK/g7YQogYNH80na8jem
         Vue6luxUZNe9MwCFi3SbXGB1+fC4LgDnSLEvsWwI/idr1Nxfz4WR4xinq+X0Ff6rS3Dt
         NkBEr3YxMr71Ex/c0hTCJ54O/DQMeHskO/Lmq6QHz1oNKst3b5sqVDP5ECg8euH1ybCZ
         5aRkZt/X3gKeuqoO/I77xhSy4o7jWxqiQx0jLk0jJ/XeJnck7TW51cq2gANYRlBmJFfX
         4HRhl4RvLb+Q0CWFesjLTiAGLe5RclOaY4BSSClv8z3GfpOMQhi+35PANavqrTmMSFVR
         6r4g==
X-Gm-Message-State: AOAM530Ex0oUVZs53TT/0FqcDfUZuKVftWQ0kYmImTRgaASx/pzQ6VQE
        9FsErB6/kFjqojaA5urEZADviGW+v/SyyC4w1jI=
X-Google-Smtp-Source: ABdhPJziogIh89bFNrujKWMKLHuJQD4M+ywP+1FTr1A/W6sEvCmcYXfVIoEbpR4cmvwqyP/MQN+7EY7y2LGsN8I1124=
X-Received: by 2002:aca:d908:: with SMTP id q8mr1282749oig.148.1614328879281;
 Fri, 26 Feb 2021 00:41:19 -0800 (PST)
MIME-Version: 1.0
References: <20210225225147.29920-1-fabrizio.castro.jz@renesas.com> <20210225225147.29920-4-fabrizio.castro.jz@renesas.com>
In-Reply-To: <20210225225147.29920-4-fabrizio.castro.jz@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 26 Feb 2021 09:41:07 +0100
Message-ID: <CAMuHMdURsd5bvHNTOqJGbVQBc4FFo=jLr=Xf2GZntO-Crh1R-A@mail.gmail.com>
Subject: Re: [PATCH 3/7] dt-bindings: misc: Add binding for R-Car DAB
To:     Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Dirk Behme <Dirk.Behme@de.bosch.com>,
        Peter Erben <Peter.Erben@de.bosch.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Fabrizio,

On Thu, Feb 25, 2021 at 11:53 PM Fabrizio Castro
<fabrizio.castro.jz@renesas.com> wrote:
> Document bindings for R-Car DAB hardware accelerator, currently
> found on the r8a77990 SoC (a.k.a. R-Car E3) and on the r8a77965
> SoC (a.k.a. R-Car M3-N).
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/renesas,dab.yaml

> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - renesas,dab-r8a77965     # R-Car M3-N
> +          - renesas,dab-r8a77990     # R-Car E3

Please use the recommended order for new bindings:

    renesas,r8a77965-dab
    renesas,r8a77990-dab

> +      - const: renesas,rcar-gen3-dab # Generic fallback for R-Car Gen3 devices
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: dab

fck?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
