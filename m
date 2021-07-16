Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A439C07E95
	for <linux-api@archiver.kernel.org>; Fri, 16 Jul 2021 16:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D34161289
	for <linux-api@archiver.kernel.org>; Fri, 16 Jul 2021 16:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhGPQL7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 16 Jul 2021 12:11:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52968 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGPQL6 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 16 Jul 2021 12:11:58 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1m4QOb-00BwDX-PT; Fri, 16 Jul 2021 10:09:01 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:59932 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1m4QOZ-00DJJg-2j; Fri, 16 Jul 2021 10:09:01 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Marco Elver <elver@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>
References: <YIpkvGrBFGlB5vNj@elver.google.com>
        <m11rat9f85.fsf@fess.ebiederm.org>
        <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
        <m15z031z0a.fsf@fess.ebiederm.org> <YIxVWkT03TqcJLY3@elver.google.com>
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org> <87a6mnzbx2.fsf_-_@disp2133>
        <YPFybJQ7eviet341@elver.google.com>
Date:   Fri, 16 Jul 2021 11:08:52 -0500
In-Reply-To: <YPFybJQ7eviet341@elver.google.com> (Marco Elver's message of
        "Fri, 16 Jul 2021 13:50:04 +0200")
Message-ID: <87tukuw8a3.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1m4QOZ-00DJJg-2j;;;mid=<87tukuw8a3.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+jrqvcI+IK382ie8tjYdZOnNBk1i6LALk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/6] Final si_trapno bits
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Marco Elver <elver@google.com> writes:

> On Thu, Jul 15, 2021 at 01:09PM -0500, Eric W. Biederman wrote:
>> As a part of a fix for the ABI of the newly added SIGTRAP TRAP_PERF a
>> si_trapno was reduced to an ordinary extention of the _sigfault case
>> of struct siginfo.
>> 
>> When Linus saw the complete set of changes come in as a fix he requested
>> that the set of changes be trimmed down to just what was necessary to
>> fix the SIGTRAP TRAP_PERF ABI.
>> 
>> I had intended to get the rest of the changes into the merge window for
>> v5.14 but I dropped the ball.
>> 
>> I have made the changes to stop using __ARCH_SI_TRAPNO be per
>> architecture so they are easier to review.  In doing so I found one
>> place on alpha where I used send_sig_fault instead of
>> send_sig_fault_trapno(... si_trapno = 0).  That would not have changed
>> the userspace behavior but it did make the kernel code less clear.
>> 
>> My rule in these patches is everywhere that siginfo layout calls
>> for SIL_FAULT_TRAPNO the code uses either force_sig_fault_trapno
>> or send_sig_fault_trapno.
>> 
>> And of course I have rebased and compile tested Marco's compile time
>> assert patches.
>> 
>> Eric
>> 
>> 
>> Eric W. Biederman (3):
>>       signal/sparc: si_trapno is only used with SIGILL ILL_ILLTRP
>>       signal/alpha: si_trapno is only used with SIGFPE and SIGTRAP TRAP_UNK
>>       signal: Remove the generic __ARCH_SI_TRAPNO support
>> 
>> Marco Elver (3):
>>       sparc64: Add compile-time asserts for siginfo_t offsets
>>       arm: Add compile-time asserts for siginfo_t offsets
>>       arm64: Add compile-time asserts for siginfo_t offsets
>
> Nice, thanks for the respin. If I diffed it right, I see this is almost
> (modulo what you mentioned above) equivalent to:
>   https://lore.kernel.org/linux-api/m1tuni8ano.fsf_-_@fess.ebiederm.org/
> + what's already in mainline. It's only missing:
>
> 	signal: Verify the alignment and size of siginfo_t
> 	signal: Rename SIL_PERF_EVENT SIL_FAULT_PERF_EVENT for consistency
>
> Would this be appropriate for this series, or rather separately, or
> dropped completely?

Appropriate I just overlooked them.

Eric

