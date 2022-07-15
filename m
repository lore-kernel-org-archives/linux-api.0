Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF4EC43334
	for <linux-api@archiver.kernel.org>; Fri, 15 Jul 2022 12:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiGOMSM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 15 Jul 2022 08:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGOMSL (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 15 Jul 2022 08:18:11 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A2F7B372
        for <linux-api@vger.kernel.org>; Fri, 15 Jul 2022 05:18:10 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z25so7542963lfr.2
        for <linux-api@vger.kernel.org>; Fri, 15 Jul 2022 05:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PkYnoGbDzaIuUX53fmOnOuZf4pSDEt2LKROZabmGh+0=;
        b=lmzGZ30QUDhp0qWKbkWPamM1ImgvGnxW/luHPgfq3LbU7fyKbTFWODoI7kmdcxqCgh
         C00B3Y/76K8UfLyfAkaOj8EBvEBdd73Vk6kTnAouCTlo9t7Ga/OMxELBmoFXzaDkz0Ij
         ElftRXYzzSggMEXb4UG9VfmqTEhMts+F+zsZyiiRCvQfVNdj2UrQF/McHN9qVVqN4pxF
         8JnEIwLJDUBpkGaXEedKQIA08PMNnsqBnVeW/VERPNgrJS1NZbT3DvB+155BmpTiuKKc
         Yv7wbDggRAE+dW3DACYjEGVP5/CtaGjVgvmpfMJBVjaBPISLdGslO0rEkT9vWpNrys/S
         JzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PkYnoGbDzaIuUX53fmOnOuZf4pSDEt2LKROZabmGh+0=;
        b=y5WdBOT8CpfEFwkYj/pz6fjU8HGIg8cQxCLVyFM87GWrQUo9T4ErOKZ3nOwqTxnjy3
         /26QKCWTjwaB2fCQxNuRUFLvphfeKdp5RlBF0Dke1EetQ6i7XFq9xTZhgriiN4krPx8J
         lLdj4tRV+yycEsfPNSlo5YYku4OxVByNNKkr8Gz0hyNx0nS/0O3Q7RRr7rW7AMnZjmla
         c2SvR3PhISynRZZppgem9NUUypfMhF3glh6lmvelTR6VjCLwUzpg9HLb58QG5Tfxj6JL
         63TbEYVi5EC5HoS1ocUyQJ4CqRdnZXs+mavc3Vit7jFD+ohjM98k0RJomQFGYb5cnB3I
         PThg==
X-Gm-Message-State: AJIora8mSNARhCeZ1a0yiXGoVgEubsh/o2HJB4ySx4PDqbg77k1dIMYy
        IlF7/qY1G2NBZ3YiKdXEsCRenOK/jcDJU+2igwQ=
X-Google-Smtp-Source: AGRyM1tHLknytt75XwZ5Bm3YXcWgG04upJO7zgY9RjB8HnkkB32AhxMoQ6M9b/0KU4BZcsBWZIsLl0gJYjAKxBodvvE=
X-Received: by 2002:ac2:5e2d:0:b0:489:f9b9:a5b7 with SMTP id
 o13-20020ac25e2d000000b00489f9b9a5b7mr7719299lfg.381.1657887488491; Fri, 15
 Jul 2022 05:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAB92dJbs0tcXmnQLZ5QKT4MJ+Hfbj4tr_HyFeaL=ySLHEUQxUQ@mail.gmail.com>
 <CANn89iJ0yB97TJ90MjuTx9UwuTKMM5qVgTaEhhwWboHOOb69Fg@mail.gmail.com>
In-Reply-To: <CANn89iJ0yB97TJ90MjuTx9UwuTKMM5qVgTaEhhwWboHOOb69Fg@mail.gmail.com>
From:   Alexander Babayants <babayants.alexander@gmail.com>
Date:   Fri, 15 Jul 2022 15:17:57 +0300
Message-ID: <CAB92dJbK5vUGD_OBdtF-dKGLpsHLyOK=HjFUnzLfx7EBhgFJ5A@mail.gmail.com>
Subject: Re: recvmmsg() behaviour with MSG_PEEK flag
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux API <linux-api@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, mtk.manpages@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Thanks for the prompt reply!

On Fri, Jul 15, 2022 at 14:21, Eric Dumazet <edumazet@google.com>:
>
...
> MSG_PEEK is a mistake really, it considerably increases the cost of
> receiving packets,
> because you need twice more system calls.

Sure, but I don't know the size of packets in advance, and I don't
control the sending side. So for me it's the choice between multiple
bad options -- either allocate some reasonable sized buffers and
truncate/drop packets that do not fit, or allocate 64k buffer for each
packet (UDP max packet size), or do two syscalls at a time. I thought
I could compensate for the cost of doing two syscalls by reading
multiple packets by syscall, but it seems that it's not possible with
the current implementation. Maybe I'm missing something and there are
other options?

> It also increases costs in the kernel, having to deal with it, even if
> not used by fast applications.
>
> Adding proper MSG_PEEK support to recvmmsg() is tricky, do_recvmmsg()
> would probably have
> to be completely reimplemented to not call ___sys_recvmsg(), or risk
> some quadratic behavior
> if each ___sys_recvmsg() has to skip over N datagrams

If there is no intention to fix the current behaviour, will it be OK
to submit a patch to man-pages with a note about it to the BUGS
section?

-- 
Regards,
Alexander Babayants.
