Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6317C07E95
	for <linux-api@archiver.kernel.org>; Tue, 13 Jul 2021 14:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC5A608FE
	for <linux-api@archiver.kernel.org>; Tue, 13 Jul 2021 14:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbhGMOFn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 13 Jul 2021 10:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhGMOFm (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 13 Jul 2021 10:05:42 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF025C0613DD;
        Tue, 13 Jul 2021 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qSFD2FiYbEqxI6h5fJ2mcIpTOMalsYT7JNKaXpDY58E=; b=CDYriJnhZwpQn6mou8CszAUrn0
        OjUPAxBcuDlSKNNvz5PSIx8wbOhUFZqI9b6D4FX+opmEoN3+qiG4ojWMmu7RVIrx8sRLWbv6peSzi
        G37dUTQTfE7Xg3nvLliIdh+9XzZwraMv1vzrQoXSn7xiw5mOBmLgpTqp4CiF5Jjj8rxGwQV9J4Id7
        3elRe4nzVVhlTGgmV7y6jE7V45HTrxWiSTvt9GfhF6tWYNHn+CFH5WGEaLcwIcaLJ85TY7TA07EMy
        H49Kv7nuH+m7pxQeTzz7uQiFwTCKZl7m5brZMjB+MoG3YcQQVDijaezFRtV8XQvBRmPJ5ZcLYA8up
        16Qf0ePw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Izc-00HAhl-GN; Tue, 13 Jul 2021 14:02:36 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 52A8D987782; Tue, 13 Jul 2021 16:02:35 +0200 (CEST)
Date:   Tue, 13 Jul 2021 16:02:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Peter Oskolkov <posk@google.com>
Cc:     Thierry Delisle <tdelisle@uwaterloo.ca>, avagin@google.com,
        bsegall@google.com, jannh@google.com, jnewsome@torproject.org,
        joel@joelfernandes.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        mkarsten@uwaterloo.ca, pabuhr@uwaterloo.ca, pjt@google.com,
        posk@posk.io, tglx@linutronix.de
Subject: Re: [RFC PATCH 3/3 v0.2] sched/umcg: RFC: implement UMCG syscalls
Message-ID: <20210713140235.GE4170@worktop.programming.kicks-ass.net>
References: <CAPNVh5f3H7Gor-Dph7=2jAdme-4mRfCCb0gv=wjgHQtd7Cad=Q@mail.gmail.com>
 <acad5960-30b2-3693-9117-e0b054ee97a7@uwaterloo.ca>
 <CAPNVh5cm9LhLEi1Td3rbOWtWH5oCvZTTMRd+p5bu75Epr3mqwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPNVh5cm9LhLEi1Td3rbOWtWH5oCvZTTMRd+p5bu75Epr3mqwA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Jul 12, 2021 at 04:31:01PM -0700, Peter Oskolkov wrote:
> On Mon, Jul 12, 2021 at 2:44 PM Thierry Delisle <tdelisle@uwaterloo.ca> wrote:

> > So what I am asking is: is UMCG_WAIT_WAKE_ONLY needed?
> 
> Because the approach you described has been tried last year and was NACKed:
> https://lore.kernel.org/lkml/20200722234538.166697-1-posk@posk.io/
> 
> In short, futex maintainers do not want to touch the existing futex
> code at all other than for bugfixes. No new futex functionality,
> period. See e.g. futex2 efforts:
> https://lore.kernel.org/lkml/20210603195924.361327-1-andrealmeid@collabora.com/

These are two orthogonal issues. We do not want to make the futex
multiplex monster worse, but that's not the reason for rejecting
FUTEX_SWAP.

The problem with FUTEX_SWAP is that it doesn't even begin to solve the
posed problem, namely N:M threading that natively allows blocking
syscalls (IOW without wrapping all syscalls).

This means we need kernel->user notification of tasks that block and
wakeup, such that the userspace scheduler can adequately react. This is
not something that sanely fits in futex.

It also requires an additional kernel side block point such that tasks
that blocked in-kernel, will not resume userspace when the userspace
scheduler decided to run another task in its stead.

These things are what resulted in UMCG.
