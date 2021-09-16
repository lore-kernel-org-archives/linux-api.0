Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E809C433FE
	for <linux-api@archiver.kernel.org>; Thu, 16 Sep 2021 13:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9E761244
	for <linux-api@archiver.kernel.org>; Thu, 16 Sep 2021 13:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhIPNip (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240091AbhIPNio (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 16 Sep 2021 09:38:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 957D26120F;
        Thu, 16 Sep 2021 13:37:22 +0000 (UTC)
Date:   Thu, 16 Sep 2021 09:37:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Collabora kernel ML <kernel@collabora.com>,
        Linux API <linux-api@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v3 2/6] futex2: Implement vectorized wait
Message-ID: <20210916093721.4508a5b3@gandalf.local.home>
In-Reply-To: <CAK8P3a3Bka5R4dmHE_+xuKTCtMaSZEYvT9jAz7QbgnF_CkeoNQ@mail.gmail.com>
References: <20210913175249.81074-1-andrealmeid@collabora.com>
        <20210913175249.81074-3-andrealmeid@collabora.com>
        <875yv4ge83.fsf@collabora.com>
        <58536544-e032-1954-ce30-d131869dc95e@collabora.com>
        <8735q5dutq.fsf@collabora.com>
        <YUMofqnG6zE4BrnR@hirez.programming.kicks-ass.net>
        <CAK8P3a3Bka5R4dmHE_+xuKTCtMaSZEYvT9jAz7QbgnF_CkeoNQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, 16 Sep 2021 13:50:14 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> Similar logic applies to cloud instances or containers. Running a 32-bit
> Alpine Linux in a container means you can often go to a lower memory
> instance on the host compared to a full 64-bit distro.

I also found that running a 32 bit version of Chrome or FireFox keeps them
from taking up all the memory in your system ;-)  The most they can use is
4 gigs.

-- Steve
