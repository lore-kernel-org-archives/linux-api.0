Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF06C433EF
	for <linux-api@archiver.kernel.org>; Fri, 15 Jul 2022 14:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiGOOY2 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 15 Jul 2022 10:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOOY1 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 15 Jul 2022 10:24:27 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EBB1D327
        for <linux-api@vger.kernel.org>; Fri, 15 Jul 2022 07:24:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id n18so8100817lfq.1
        for <linux-api@vger.kernel.org>; Fri, 15 Jul 2022 07:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WPm0ZzjeQSG4jB+LemYLUi+tdAYPlOLiYvMru7anI1k=;
        b=l9v4yHDifEZRLQuLBj/9AbU1vIfSVdPJg4KFxJJ9/Vjw2ypsEWXzJ+/m+0+MqHU8Fi
         31RCqRV3ySiD0Ey8nw7fd8EHbJhhPrnKjhsoWd4VN+FgT93AoQzO1GRjaUds+FCloRgU
         SZaCImUP/xLKXMUkECAHS/zFTjnNw3UCVkv9AlQiGM8mautiJHhlP62Dxp2/9N0reEhe
         tOmrOHe7DgaiVE4MuI66PF5xBAQZeVV14WYXLalMCeUuhVRXxK3AddJoU7SuZ/BedIa7
         Dc05Fc5mNUkYYQhsGFl145A065gOBJLmhNQdzN+rstlqR0Fbo9Ycxp4S9UgVySBDkaTn
         gJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WPm0ZzjeQSG4jB+LemYLUi+tdAYPlOLiYvMru7anI1k=;
        b=Qi2qtG8iSfwxcGPIwRkggxEnNeJmFMtq5UmoUN8ZvAGQ+ikULcDOt0jeu7LmssyMnH
         nU6kc61CfP4XoWj8DESLtNAcKhhriYudYe6CHBp+9T1zc+lXAhWdhqw8mrDFcYEkH2iJ
         Fl9YaGpdlhj1C7gE304TMtGiTwwVs23xow1Kf7xRMUL/D97h4XdzBPiR/9s+edf2ZWeN
         qWFPZAM3sWeOF0Vjz9Q43y4aWYhQb+j47e8DFPovnPE6W8jEw/EZq6EMjxsU0fgLlYia
         ev+y/TDqgWh3+/lNetFncxn9AGiK5xPG9qXvn2ZM7qCxOVVe9M6FkahMCAoS7PMG1Kmg
         Ygag==
X-Gm-Message-State: AJIora+jCjSRHUPdbyKGvGSCM6vls6mt5eJdhP5LVv+t8RStxDIQDDcH
        4oigpQnljhX8hhb/+fX65H4TfXx08Ct+EaHORsEyVg==
X-Google-Smtp-Source: AGRyM1shaL5F7Sjfk0JLZ5Oihzn9bKSRUv0N0yGwlIk3sUTQsQ5Lx6MG9/BadZt/vrXZAYcGzUFLeA6An0SOlz2ZCSg=
X-Received: by 2002:a05:6512:3b9f:b0:489:e009:ae0c with SMTP id
 g31-20020a0565123b9f00b00489e009ae0cmr8738614lfv.213.1657895063386; Fri, 15
 Jul 2022 07:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAB92dJbs0tcXmnQLZ5QKT4MJ+Hfbj4tr_HyFeaL=ySLHEUQxUQ@mail.gmail.com>
In-Reply-To: <CAB92dJbs0tcXmnQLZ5QKT4MJ+Hfbj4tr_HyFeaL=ySLHEUQxUQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 15 Jul 2022 16:23:47 +0200
Message-ID: <CAG48ez3D85x5-eCAQz8Z2Gq=EgDi1-wvYaKig473AaLpUFiDmQ@mail.gmail.com>
Subject: Re: recvmmsg() behaviour with MSG_PEEK flag
To:     Alexander Babayants <babayants.alexander@gmail.com>
Cc:     linux-api@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mtk.manpages@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 15, 2022 at 1:03 PM Alexander Babayants
<babayants.alexander@gmail.com> wrote:
> The behaviour of recvmmsg() with MSG_PEEK flag confuses me. I'd expect
> it to peek multiple messages at once, but it seems to peek only the
> first one, filling each of the provided struct msghdr with a copy of
> the first message. I do not see if it is documented anywhere, is it a
> bug or intended design?
>
> What I want to achieve is to first peek into the socket, get the size
> of each message, then allocate appropriate buffers and read the
> messages with the second recvmmsg() call. This seems to be a
> relatively common pattern for reading single messages via recvmsg(),
> and I naively expected it to work with recvmmsg() too.

You might want to look at SO_PEEK_OFF in the socket.7 manpage. (Or
even better, as suggested before in the thread, rework your code to
not peek at all.)
