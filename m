Return-Path: <SRS0=n9Uq=A6=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A22C433DF
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 12:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AFC2080D
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 12:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xmNhNt4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGSMeV (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 19 Jul 2020 08:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGSMeU (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 19 Jul 2020 08:34:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22806C0619D5
        for <linux-api@vger.kernel.org>; Sun, 19 Jul 2020 05:34:20 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j11so17346782ljo.7
        for <linux-api@vger.kernel.org>; Sun, 19 Jul 2020 05:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZIrohiMdali1I9FPYzFLXxnzZ6kbPXecqdfnrEblwU=;
        b=xmNhNt4z0L/5c6tMRxdSOr6Q/WX+tYVe1YiAmkVbL9QC0fBJfCfTMUgH48lOCBgzLd
         jivsrFSafQg1JppTXkVDgNlM8FXS+1YK2o0+wB8LA3N9eiSRrJz4eLxfNnlYnk6tO3SC
         tgmTx7PqVpTzbxxmDkQ2+n8aqG6J+Tjo+wXc48LTd4iZQiXn+ADslsY4FcjkCkd5dnlN
         gv0IOS2XUeZMIb2sg7Tdd3vc9SFlzfVFG4relC9hqb12Xa+W4BUl6JWYPoyVdBSkfJGT
         xVHp/GoW7vcqLpGhDcB74OgI/azIrRvGOg6dT9CeXMcSVqmZACxw6BrTX4v+XvcTEODF
         vhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZIrohiMdali1I9FPYzFLXxnzZ6kbPXecqdfnrEblwU=;
        b=R4gV+SGlYOAi582muxip/5IOhNsF+q5RhrXciopmVyBP5cgUKBhqaRwHdxPPIsVxHR
         xx8KihhkW/SPETEVZ4xYBElYG237fThwRHntWQ+WtlmorxgDoaNKGleu/8C6EVoFxWPi
         kpY6MTEga8BNIj61uvrJjHQ9FkaxlAkLBEmNTXjNTuHuBo+bwr+so43oJ8sj5yx0Or0c
         3i6lFGCUgS5RMs/8SJsa2Q04slceajk/VyZ+18t5B1SA9Fu92V93V1szWvmNaMhGK1Ht
         fkvJFHakEfxo/4CA84sdCEygRI3vjgEu6JhA8UYuAbvkj5PYijphc58Ek9kQGkiMaWpo
         MaYQ==
X-Gm-Message-State: AOAM531rhY4XCevjKHWtg1XysqhcBhOnTvlxgpRSFV7NwLGRw9z3DLtY
        VJ5cWo8DNvQucBGWqmxbInelx8wpFVmx/jXeSDiyPw==
X-Google-Smtp-Source: ABdhPJzRynBTVB1RJzflXo15K9PzSSQ7Win2K87BjL3Kkg3KSM5ahbR1uH7ZPLe4uA7BKjcNcNfJxXiJkvll++c7e/I=
X-Received: by 2002:a2e:9c3:: with SMTP id 186mr8445754ljj.293.1595162058467;
 Sun, 19 Jul 2020 05:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200529072017.2906-1-linus.walleij@linaro.org>
 <CAFEAcA-x0y6ufRXebckRdGSLOBzbdBsk=uw+foK4p+HDeVrA9A@mail.gmail.com> <CACRpkdZk-Pv49PyhtrW7ZQo+iebOapVb7L2T_cxh0SpYtcv5Xw@mail.gmail.com>
In-Reply-To: <CACRpkdZk-Pv49PyhtrW7ZQo+iebOapVb7L2T_cxh0SpYtcv5Xw@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Jul 2020 14:34:07 +0200
Message-ID: <CACRpkdbOiL7=KUNa0==P+H-3SynhMt1=JweCY8ihbEZLK=b78w@mail.gmail.com>
Subject: Re: [PATCH v2] fcntl: Add 32bit filesystem mode
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Jul 6, 2020 at 10:54 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> Ted, can you merge this patch?
>
> It seems QEMU is happy and AFICT it uses the approach you want :)

Gentle ping!

Yours,
Linus Walleij
