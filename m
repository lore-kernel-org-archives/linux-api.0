Return-Path: <SRS0=Nix3=7A=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96B1C433DF
	for <linux-api@archiver.kernel.org>; Mon, 18 May 2020 14:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C1D206D4
	for <linux-api@archiver.kernel.org>; Mon, 18 May 2020 14:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NnbKbGQl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEROnt (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 18 May 2020 10:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgEROns (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 18 May 2020 10:43:48 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D7C061A0C
        for <linux-api@vger.kernel.org>; Mon, 18 May 2020 07:43:48 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so10160434ljd.3
        for <linux-api@vger.kernel.org>; Mon, 18 May 2020 07:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vmKMl5YPAbtYvThGAufK7+pRDXytMF6DEwy6+OdOT6c=;
        b=NnbKbGQluk5lNt1OMh91AzLf43ctbuCx11Qrf3/SH8c37zea2KCW1nBzzZxOP6eBMJ
         mNikiWnBzqw1Qh5gemWUCvWkJrCIW8yDSnkDx8R6ZYBzKq+OLJjZPeFz2G9mgUvlkVTM
         dm8UA+SmF8OQXRg6DdCXiTcqKrEVyEYP7SLPKT2yHm+RCB4cGu3cFPb2AjVfi0QY5rUq
         qAGDKXTutca8F5XEP0TqE545HEJbER9IgNbvIFzIa9jPi0OuqeYk/x+vJdTSoeTUygoI
         8E5aJEpfXrwXeNyCuMqf4Iw1FJkWkKCQGV1kAlYV1sACiLyt3C6WFh/ySD2nZG5gBeFu
         wwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vmKMl5YPAbtYvThGAufK7+pRDXytMF6DEwy6+OdOT6c=;
        b=jsiSgoMKr0dh0p/rH1HiyiBzhnuKjNmxHGSMOiPQH7lXicqAhdjmpbVGShy0YyT+Ly
         cJJNQ96U07JbBG/Ox0uaNOsiFZ0lmAuRinaBB406MxmQLB0HksOEHuR33uJGy1jVf44v
         DLNriz+R9SG0js+55GAFRiaP6YquHBYkWXrTDdez70zWek1UNIKgxlLjI9drjqLF+8wE
         QoFqUsUWdvkWqBfGz/4ruXFqZXciV4/TU82mqnv/JqJ4pwgVbjEo1YOjcZ09JcomCUV8
         LjlOyF3Di49udQlg4lXmbLmm9On7fc7qCXDfK10Hscnu1KiKvMSEnmOR58EuCjlWL6Xe
         GFxA==
X-Gm-Message-State: AOAM533rMZ/E1L9fUW4gF/bO5ENVCFwGtQf7nJ/081kAi1PG97O52IcH
        sgPGk+QnsYab/f5W6cYw3AT+nICBqnrrT7wGnsLiyg==
X-Google-Smtp-Source: ABdhPJxtr0BKnKjn6pCHBXg0CBH0lcE95cP/SI2TsQx+b5KMUXKtBPY9ZvGp2Yty+kEdByTnUauiLd0kc/yHpxl0ygk=
X-Received: by 2002:a2e:8e8c:: with SMTP id z12mr2985329ljk.221.1589813026603;
 Mon, 18 May 2020 07:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200518055457.12302-1-keescook@chromium.org> <20200518055457.12302-2-keescook@chromium.org>
 <20200518130251.zih2s32q2rxhxg6f@wittgenstein>
In-Reply-To: <20200518130251.zih2s32q2rxhxg6f@wittgenstein>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 18 May 2020 16:43:20 +0200
Message-ID: <CAG48ez1FspvvypJSO6badG7Vb84KtudqjRk1D7VyHRm06AiEbQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] exec: Change uselib(2) IS_SREG() failure to EACCES
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Biggers <ebiggers3@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, May 18, 2020 at 3:03 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> Also - gulp (puts on flame proof suit) - may I suggest we check if there
> are any distros out there that still set CONFIG_USELIB=y

Debian seems to have it enabled on x86...

https://salsa.debian.org/kernel-team/linux/-/blob/master/debian/config/kernelarch-x86/config#L1896

A random Ubuntu 19.10 VM I have here has it enabled, too.
