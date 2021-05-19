Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EB7C43460
	for <linux-api@archiver.kernel.org>; Wed, 19 May 2021 09:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073DC611B0
	for <linux-api@archiver.kernel.org>; Wed, 19 May 2021 09:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhESJ03 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 May 2021 05:26:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38084 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbhESJ01 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 19 May 2021 05:26:27 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621416306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N5hyyTVe5YeXQBP2XNHi9Lw7C5p053Vt1WVMxgtgO04=;
        b=eM+pft65GXBz9zKZ5JoZ4py64nNDUAWTbpwSP5HCAlcM329XX6KKOqWAwd7vNetHMTloaP
        QRR7awJGvEz3ioTXAyy256ANc3y+H4GoHKFAGbYr6cWmZdwk94D5YUvRbn1dkxtbqLh80S
        DlFy9pNelkWC0OlPGAFLU2BlTZTQvWdO8n8oHdn2emHCuXLyNIWUHC+9UDQhziAlLjSdYK
        Tx/6BQWe68mCISnuJ2LFVqahnLr+0xZ37Q4JMqaAPLdRMMooSLy3eY04WpK/5GpVkFfAMm
        wGgbJsRlPVo7O+XfSL5Oregv3js9P3anVHFuPAVqeQsiWL8vfZX0nJbqYhu/5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621416306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N5hyyTVe5YeXQBP2XNHi9Lw7C5p053Vt1WVMxgtgO04=;
        b=B1J0AbO593COcik+/xDRsqoIuw31G0QRt2dDoVM61Zwu/fH2GwMPWXHNMCe9V+c5pFdvU0
        bZE35ICJP35H0qAQ==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        mingo@kernel.org, luto@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, hjl.tools@gmail.com,
        Dave.Martin@arm.com, jannh@google.com, mpe@ellerman.id.au,
        carlos@redhat.com, tony.luck@intel.com, ravi.v.shankar@intel.com,
        libc-alpha@sourceware.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com
Subject: Re: [PATCH v9 0/6] Improve Minimum Alternate Stack Size
In-Reply-To: <20210518200320.17239-1-chang.seok.bae@intel.com>
References: <20210518200320.17239-1-chang.seok.bae@intel.com>
Date:   Wed, 19 May 2021 11:25:06 +0200
Message-ID: <87sg2jcbyl.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, May 18 2021 at 13:03, Chang S. Bae wrote:
> During signal entry, the kernel pushes data onto the normal userspace
> stack. On x86, the data pushed onto the user stack includes XSAVE state,
> which has grown over time as new features and larger registers have been
> added to the architecture.
>
> MINSIGSTKSZ is a constant provided in the kernel signal.h headers and
> typically distributed in lib-dev(el) packages, e.g. [1]. Its value is
> compiled into programs and is part of the user/kernel ABI. The MINSIGSTKSZ
> constant indicates to userspace how much data the kernel expects to push on
> the user stack, [2][3].
>
> However, this constant is much too small and does not reflect recent
> additions to the architecture. For instance, when AVX-512 states are in
> use, the signal frame size can be 3.5KB while MINSIGSTKSZ remains 2KB.
>
> The bug report [4] explains this as an ABI issue. The small MINSIGSTKSZ can
> cause user stack overflow when delivering a signal.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
