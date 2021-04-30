Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440C2C43460
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 17:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E7D361462
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 17:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhD3RJT (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Apr 2021 13:09:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47132 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RJT (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 30 Apr 2021 13:09:19 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcWct-003hre-G4; Fri, 30 Apr 2021 11:08:27 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcWcq-0007sZ-Sl; Fri, 30 Apr 2021 11:08:27 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Marco Elver <elver@google.com>,
        Florian Weimer <fweimer@redhat.com>,
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
In-Reply-To: <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 29 Apr 2021 22:48:40 +0200")
References: <YIpkvGrBFGlB5vNj@elver.google.com>
        <m11rat9f85.fsf@fess.ebiederm.org>
        <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 30 Apr 2021 12:08:21 -0500
Message-ID: <m15z031z0a.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcWcq-0007sZ-Sl;;;mid=<m15z031z0a.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Wqofbl5arDNKUOr/+Bhq4oW4Ax0G5pkM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: siginfo_t ABI break on sparc64 from si_addr_lsb move 3y ago
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thu, Apr 29, 2021 at 7:23 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > Which option do you prefer? Are there better options?
>>
>> Personally the most important thing to have is a single definition
>> shared by all architectures so that we consolidate testing.
>>
>> A little piece of me cries a little whenever I see how badly we
>> implemented the POSIX design.  As specified by POSIX the fields can be
>> place in siginfo such that 32bit and 64bit share a common definition.
>> Unfortunately we did not addpadding after si_addr on 32bit to
>> accommodate a 64bit si_addr.
>>
>> I find it unfortunate that we are adding yet another definition that
>> requires translation between 32bit and 64bit, but I am glad
>> that at least the translation is not architecture specific.  That common
>> definition is what has allowed this potential issue to be caught
>> and that makes me very happy to see.
>>
>> Let's go with Option 3.
>>
>> Confirm BUS_MCEERR_AR, BUS_MCEERR_AO, SEGV_BNDERR, SEGV_PKUERR are not
>> in use on any architecture that defines __ARCH_SI_TRAPNO, and then fixup
>> the userspace definitions of these fields.
>>
>> To the kernel I would add some BUILD_BUG_ON's to whatever the best
>> maintained architecture (sparc64?) that implements __ARCH_SI_TRAPNO just
>> to confirm we don't create future regressions by accident.
>>
>> I did a quick search and the architectures that define __ARCH_SI_TRAPNO
>> are sparc, mips, and alpha.  All have 64bit implementations.
>
> I think you (slightly) misread: mips has "#undef __ARCH_SI_TRAPNO", not
> "#define __ARCH_SI_TRAPNO". This means it's only sparc and
> alpha.
>
> I can see that the alpha instance was added to the kernel during linux-2.5,
> but never made it into the glibc or uclibc copy of the struct definition, and
> musl doesn't support alpha or sparc. Debian codesearch only turns up
> sparc (and BSD) references to si_trapno.



>> I did a quick search and the architectures that define __ARCH_SI_TRAPNO
>> are sparc, mips, and alpha.  All have 64bit implementations.  A further
>> quick search shows that none of those architectures have faults that
>> use BUS_MCEERR_AR, BUS_MCEERR_AO, SEGV_BNDERR, SEGV_PKUERR, nor do
>> they appear to use mm/memory-failure.c
>>
>> So it doesn't look like we have an ABI regression to fix.
>
> Even better!
>
> So if sparc is the only user of _trapno and it uses none of the later
> fields in _sigfault, I wonder if we could take even more liberty at
> trying to have a slightly saner definition. Can you think of anything that
> might break if we put _trapno inside of the union along with _perf
> and _addr_lsb?

On sparc si_trapno is only set when SIGILL ILL_TRP is set.  So we can
limit si_trapno to that combination, and it should not be a problem for
a new signal/si_code pair to use that storage.  Precisely because it is
new.

Similarly on alpha si_trapno is only set for:

SIGFPE {FPE_INTOVF, FPE_INTDIV, FPE_FLTOVF, FPE_FLTDIV, FPE_FLTUND,
FPE_FLTINV, FPE_FLTRES, FPE_FLTUNK} and SIGTRAP {TRAP_UNK}.

Placing si_trapno into the union would also make the problem that the
union is pointer aligned a non-problem as then the union immediate
follows a pointer.

I hadn't had a chance to look before but we must deal with this.  The
definition of perf_sigtrap in 42dec9a936e7696bea1f27d3c5a0068cd9aa95fd
is broken on sparc, alpha, and ia64 as it bypasses the code in
kernel/signal.c that ensures the si_trapno or the ia64 special fields
are set.

Not to mention that perf_sigtrap appears to abuse si_errno.

The code is only safe if the analysis that says we can move si_trapno
and perhaps the ia64 fields into the union is correct.  It looks like
ia64 much more actively uses it's signal extension fields including for
SIGTRAP, so I am not at all certain the generic definition of
perf_sigtrap is safe on ia64.

> I suppose in theory sparc64 or alpha might start using the other
> fields in the future, and an application might be compiled against
> mismatched headers, but that is unlikely and is already broken
> with the current headers.

If we localize the use of si_trapno to just a few special cases on alpha
and sparc I think we don't even need to worry about breaking userspace
on any architecture.  It will complicate siginfo_layout, but it is a
complication that reflects reality.

I don't have a clue how any of this affects ia64.  Does perf work on
ia64?  Does perf work on sparc, and alpha?

If perf works on ia64 we need to take a hard look at what is going on
there as well.

Eric
