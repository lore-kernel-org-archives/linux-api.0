Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93240E732DB
	for <linux-api@archiver.kernel.org>; Thu, 28 Sep 2023 14:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjI1Onc (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjI1Onb (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 28 Sep 2023 10:43:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE9F9;
        Thu, 28 Sep 2023 07:43:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C8C433C8;
        Thu, 28 Sep 2023 14:43:24 +0000 (UTC)
Date:   Thu, 28 Sep 2023 10:43:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Florian Weimer <fw@deneb.enyo.de>, David.Laight@aculab.com,
        carlos@redhat.com, Peter Oskolkov <posk@posk.io>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Chris Kennelly <ckennelly@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
        libc-alpha@sourceware.org, Jonathan Corbet <corbet@lwn.net>,
        Noah Goldstein <goldstein.w.n@gmail.com>,
        Daniel Colascione <dancol@google.com>, longman@redhat.com,
        Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v2 1/4] rseq: Add sched_state field to struct rseq
Message-ID: <20230928104321.490782a7@rorschach.local.home>
In-Reply-To: <20230928103926.GI9829@noisy.programming.kicks-ass.net>
References: <20230529191416.53955-1-mathieu.desnoyers@efficios.com>
        <20230529191416.53955-2-mathieu.desnoyers@efficios.com>
        <20230928103926.GI9829@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, 28 Sep 2023 12:39:26 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> As always, are syscalls really *that* expensive? Why can't we busy wait
> in the kernel instead?

Yes syscalls are that expensive. Several years ago I had a good talk
with Robert Haas (one of the PostgreSQL maintainers) at Linux Plumbers,
and I asked him if they used futexes. His answer was "no". He told me
how they did several benchmarks and it was a huge performance hit (and
this was before Spectre/Meltdown made things much worse). He explained
to me that most locks are taken just to flip a few bits. Going into the
kernel and coming back was orders of magnitude longer than the critical
sections. By going into the kernel, it caused a ripple effect and lead
to even more contention. There answer was to implement their locking
completely in user space without any help from the kernel.

This is when I thought that having an adaptive spinner that could get
hints from the kernel via memory mapping would be extremely useful.

The obvious problem with their implementation is that if the owner is
sleeping, there's no point in spinning. Worse, the owner may even be
waiting for the spinner to get off the CPU before it can run again. But
according to Robert, the gain in the general performance greatly
outweighed the few times this happened in practice.

But still, if userspace could figure out if the owner is running on
another CPU or not, to act just like the adaptive mutexes in the
kernel, that would prevent the problem of a spinner keeping the owner
from running.

-- Steve
