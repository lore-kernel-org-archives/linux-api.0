Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8C2C2D0E4
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 21:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B665520721
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 21:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YcNnH80O";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mMt/hU8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbgKWVsE (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 23 Nov 2020 16:48:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38558 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730108AbgKWVsE (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 23 Nov 2020 16:48:04 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606168081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1uCKrC/JVnFefj87bZYqeaIDv0yyNdd4LhM7mGuDJM=;
        b=YcNnH80Owhk67icq+BuAaMvftswTwmhM+6euUdaRP7WH3T+rzPpJstyMnAnylH/NUwzqUo
        ZQrS0RmAPYvBjjLnr4LpGTm8v0sSlD18iq5nCw2lZx3WXOpAS63Tp+BfZtPdNM1BD34108
        VYnzKJh/bF9SujydFoFCIzQwqCgIgfLg4x+BX4gNkGtjk3nOeaPEpSeeJw6e9WybLoupX3
        m5NVmypPWg1ykY9tZ+MmwxOcGBWUa2LBVQwce5TSLeeJ5Ny1hRHS4DTFHrKRmCX+TsDn+4
        cq1ml6AdNowL6NbKTl1jWudmP4lGWwmBUrYSykWVmMgRuDWnvIQdK+hmUDGWGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606168081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1uCKrC/JVnFefj87bZYqeaIDv0yyNdd4LhM7mGuDJM=;
        b=mMt/hU8u/OTPxDuQKILiP1HhdRxZ4zvs1L8KKoZmzhLl6g612jVzcISf+J/GJPD6Y6RT8s
        rYLoGs+JkPIjWpCA==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "trix\@redhat.com" <trix@redhat.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx\@redhat.com" <peterx@redhat.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "will\@kernel.org" <will@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "leon\@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld\@redhat.com" <pauld@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 1/9] task_isolation: vmstat: add quiet_vmstat_sync function
In-Reply-To: <0e07e5bf6f65dc89d263683c81b4a19bcc6d4b60.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com> <0e07e5bf6f65dc89d263683c81b4a19bcc6d4b60.camel@marvell.com>
Date:   Mon, 23 Nov 2020 22:48:01 +0100
Message-ID: <87eekjn3se.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Alex,

On Mon, Nov 23 2020 at 17:56, Alex Belits wrote:

why are you insisting on adding 'task_isolation: ' as prefix to every
single patch? That's wrong as I explained before.

The prefix denotes the affected subsystem and 'task_isolation' is _NOT_
a subsystem. It's the project name you are using but the affected code
belongs to the memory management subsystem and if you run

 git log mm/vmstat.c

you might get a hint what the proper prefix is, i.e. 'mm/vmstat: '

> In commit f01f17d3705b ("mm, vmstat: make quiet_vmstat lighter")
> the quiet_vmstat() function became asynchronous, in the sense that
> the vmstat work was still scheduled to run on the core when the
> function returned.  For task isolation, we need a synchronous

This changelog is useless because how should someone not familiar with
the term 'task isolation' figure out what that means?

It's not the reviewers job to figure that out. Again: Go read and adhere
to Documentation/process/*

Aside of that your patches are CR/LF inflicted. Please fix your work
flow and tools.

Thanks,

        tglx



