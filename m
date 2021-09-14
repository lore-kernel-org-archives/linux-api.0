Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B243C433EF
	for <linux-api@archiver.kernel.org>; Tue, 14 Sep 2021 18:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CE9610A6
	for <linux-api@archiver.kernel.org>; Tue, 14 Sep 2021 18:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhINSGf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 14 Sep 2021 14:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhINSGf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 14 Sep 2021 14:06:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA657C061574;
        Tue, 14 Sep 2021 11:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gMy2+2YWwBU6udZmmpCVgiIhEGB2VyMMA5rTE2/ZjAM=; b=BsPNYN0z0NtpnDm1PpS+NWvkw1
        12FXzjO0A/AzqkQrfcBkR2+ExWQOUIyet0gfyT6fVQGKRMSAWyL+1R0ZuFYOvsraeX0kgnWr9Cftg
        0zXm+XipQlDLQp1JaeqNMcA09ISqNP1ScF/fzhzYNvuu4XXjyglM/P72b8RDPdHEXb6WKDUo/igEE
        t08Z1G4N9PM2yPr3zuvwpTNS8VbESDshuYYCqCOtaQ9EfSFiPBapA3NDcFvryLjibxBEBOYPqH4o1
        Z6Igk0EAZlypbBht7xqwlIrp/bCx10/OLddUo2QUpTqwTMOjVMDUOwnz5pwL6oWfFl2c1G+FOWg7p
        BYpK5wPQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQCnf-003BW4-Rr; Tue, 14 Sep 2021 18:04:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2C9143001C7;
        Tue, 14 Sep 2021 20:04:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1236A2D4E15B4; Tue, 14 Sep 2021 20:04:55 +0200 (CEST)
Date:   Tue, 14 Sep 2021 20:04:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Peter Oskolkov <posk@google.com>
Cc:     Jann Horn <jannh@google.com>, Peter Oskolkov <posk@posk.io>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>,
        Andrei Vagin <avagin@google.com>,
        Thierry Delisle <tdelisle@uwaterloo.ca>
Subject: Re: [PATCH 2/4 v0.5] sched/umcg: RFC: add userspace atomic helpers
Message-ID: <YUDkR8YtekMkuaBH@hirez.programming.kicks-ass.net>
References: <20210908184905.163787-1-posk@google.com>
 <20210908184905.163787-3-posk@google.com>
 <CAG48ez2LyLNkH4iVbeKJUuH=oh57WECkKYCW+G9mtheoh7Fsvg@mail.gmail.com>
 <CAPNVh5eaW7r_Nv-wHEyxQiFkXngmONwPyZSFvtTEhk3TxJ+iMA@mail.gmail.com>
 <YUBYJLCYpy3yJO5F@hirez.programming.kicks-ass.net>
 <CAPNVh5chP3Zz+ww8WLb9bUYNikW-1PyOV=3==BM-92BgogaB3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPNVh5chP3Zz+ww8WLb9bUYNikW-1PyOV=3==BM-92BgogaB3w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Sep 14, 2021 at 09:29:00AM -0700, Peter Oskolkov wrote:
> In the version of the patchset that I'm preparing to send I've decided
> to punt on the issue and just ask the userspace to deal with locking
> the memory as it sees fit: mlock() is available and as far as I can

Sadly mlock() does not imply no faults. Someone had a too literal
reading of the POSIX-RT spec (of which mlock is part) and figured that
all that was required was to keep the page in memory, not avoid faults.

Linux has had this bahviour for ages, PREEMPT_RT has tried to change
this, but so far to no avail. At some point sys_mpin() was proposed to
meet the original POSIX-RT intent, but afaict that never actually
happened.

In short, mlock() does not avoid minor faults, or even migration faults,
which can take a fair while to resolve.
