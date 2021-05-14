Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47D3C43461
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 21:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F095613DE
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 21:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhENVQ7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 May 2021 17:16:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53034 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhENVQ6 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 May 2021 17:16:58 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhf9s-004lat-Tn; Fri, 14 May 2021 15:15:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhf9p-0041DZ-M9; Fri, 14 May 2021 15:15:44 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
        kasan-dev <kasan-dev@googlegroups.com>,
        Marco Elver <elver@google.com>
References: <YIpkvGrBFGlB5vNj@elver.google.com>
        <m11rat9f85.fsf@fess.ebiederm.org>
        <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
        <m15z031z0a.fsf@fess.ebiederm.org> <YIxVWkT03TqcJLY3@elver.google.com>
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
        <m1r1irpc5v.fsf@fess.ebiederm.org>
        <CANpmjNNfiSgntiOzgMc5Y41KVAV_3VexdXCMADekbQEqSP3vqQ@mail.gmail.com>
        <m1czuapjpx.fsf@fess.ebiederm.org>
        <CANpmjNNyifBNdpejc6ofT6+n6FtUw-Cap_z9Z9YCevd7Wf3JYQ@mail.gmail.com>
        <m14kfjh8et.fsf_-_@fess.ebiederm.org>
        <m1tuni8ano.fsf_-_@fess.ebiederm.org>
        <m1a6oxewym.fsf_-_@fess.ebiederm.org>
        <CAHk-=wikDD+gCUECg9NZAVSV6W_FUdyZFHzK4isfrwES_+sH-w@mail.gmail.com>
Date:   Fri, 14 May 2021 16:15:36 -0500
In-Reply-To: <CAHk-=wikDD+gCUECg9NZAVSV6W_FUdyZFHzK4isfrwES_+sH-w@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 14 May 2021 12:14:02 -0700")
Message-ID: <m14kf5aufb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lhf9p-0041DZ-M9;;;mid=<m14kf5aufb.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+VgmiCnNh7t6EwWQgeO8qAQbN162o8ghc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT PULL] siginfo: ABI fixes for v5.13-rc2
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, May 13, 2021 at 9:55 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Please pull the for-v5.13-rc2 branch from the git tree:
>
> I really don't like this tree.
>
> The immediate cause for "no" is the silly
>
>  #if IS_ENABLED(CONFIG_SPARC)
>
> and
>
>  #if IS_ENABLED(CONFIG_ALPHA)
>
> code in kernel/signal.c. It has absolutely zero business being there,
> when those architectures have a perfectly fine arch/*/kernel/signal.c
> file where that code would make much more sense *WITHOUT* any odd
> preprocessor games.

The code is generic it just happens those functions are only used on
sparc and alpha.  Further I really want to make filling out siginfo_t
happen in dedicated functions as much as possible in kernel/signal.c.
The probably of getting it wrong without a helper functions is very
strong.  As the code I am fixing demonstrates.

The IS_ENABLED(arch) is mostly there so we can delete the code if/when
the architectures are retired in another decade or so.

> But there are other oddities too, like the new
>
>     send_sig_fault_trapno(SIGFPE, si_code, (void __user *) regs->pc,
> 0, current);
>
> in the alpha code, which fundamentally seems bogus: using
> send_sig_fault_trapno() with a '0' for trapno seems entirely
> incorrect, since the *ONLY* point of that function is to set si_trapno
> to something non-zero.
>
> So it would seem that a plain send_sig_fault() without that 0 would be
> the right thing to do.

As it happens the floating point emulation code on alpha is inconsistent
with the non floating point emulation code.  When using real floating
point hardware SIGFPE on alpha always set si_trapno.  The floating point
emulation code does not look like it has ever set si_trapno.

I continued to used send_sig_fault_trapno to point out that
inconsistency.

If alpha floating point emulation was in active use I expect we would
care enough to put something other than 0 in there.

> This also mixes in a lot of other stuff than just the fixes. Which
> would have been ok during the merge window, but I'm definitely not
> happy about it now.

If the breakage that came with SIGTRAP TRAP_PERF had not been discovered
during the merge window I would not be sending this now.  It took a
little time to dig to the bottom, then the code needed just a little
extra time to sit, so there were not surprises.

As for mixing things, I am not quite certain what you are referring to.
All of the changes relate to keeping people from shooting themselves
in the foot with when using siginfo.

The most noise comes from send_sig_fault vs send_sig_fault_trapno, and
force_sig_fault vs force_sig_fault_trapno.  That is fundamental to the
siginfo fix as it is there to ensure that is safe to treat si_trapno
as an ordinary _sigfault union member.  Which in turns makes alpha
and sparc no longer special with respect to _sigfault, just a little
eccentric.

I will concede that renaming SIL_PERF_EVENT to SIL_FAULT_PERF_EVENT is
unnecessary, but it certainly makes it clear that we are dealing
with _sigfault and not some other part of siginfo_t.

Eric
