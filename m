Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789D5C43460
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 22:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB94613BB
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 22:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhENWjs (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 May 2021 18:39:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42680 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhENWjs (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 May 2021 18:39:48 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhgS0-004tzQ-9N; Fri, 14 May 2021 16:38:32 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhgRz-004D3L-AH; Fri, 14 May 2021 16:38:31 -0600
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
        <m14kf5aufb.fsf@fess.ebiederm.org>
Date:   Fri, 14 May 2021 17:38:25 -0500
In-Reply-To: <m14kf5aufb.fsf@fess.ebiederm.org> (Eric W. Biederman's message
        of "Fri, 14 May 2021 16:15:36 -0500")
Message-ID: <m1tun57xge.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lhgRz-004D3L-AH;;;mid=<m1tun57xge.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19odSp5HEfI42QhPUSRdilH+u4toHAL8FY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT PULL] siginfo: ABI fixes for v5.13-rc2
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> On Thu, May 13, 2021 at 9:55 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> Please pull the for-v5.13-rc2 branch from the git tree:
>>
>> I really don't like this tree.
>>
>> The immediate cause for "no" is the silly
>>
>>  #if IS_ENABLED(CONFIG_SPARC)
>>
>> and
>>
>>  #if IS_ENABLED(CONFIG_ALPHA)
>>
>> code in kernel/signal.c. It has absolutely zero business being there,
>> when those architectures have a perfectly fine arch/*/kernel/signal.c
>> file where that code would make much more sense *WITHOUT* any odd
>> preprocessor games.
>
> The code is generic it just happens those functions are only used on
> sparc and alpha.  Further I really want to make filling out siginfo_t
> happen in dedicated functions as much as possible in kernel/signal.c.
> The probably of getting it wrong without a helper functions is very
> strong.  As the code I am fixing demonstrates.
>
> The IS_ENABLED(arch) is mostly there so we can delete the code if/when
> the architectures are retired in another decade or so.

There is also the question of why alpha allows userspace to block
SIGFPE.

If it turns out that alpha is just silly by allowing synchronous
exceptions to be blocked, then the code really becomes generic and
shared shared between sparc and alpha.

Which is really why the code does not make sense in some architecture
specific version of signal.c.  That and the fact the two functions
are almost identical.

If you want I can remove the #ifdefs and we can take up slightly more
space until someone implements -ffunction-sections.

Do you know if alpha will be stuck triggering the same floating point
error if the SIGFPE is blocked or can alpha somehow continue past it?

If alpha using send_sig instead of force_sig is historical and does not
reflect the reality of the hardware alpha can be converted and several
of the send_sig variants can be removed.  Otherwise alpha remains the
odd man out, and the code can remain until all of the alpha hardware
dies.  (I don't think anyone is manufacturing alpha hardware anymore).

I would look it up but I have lost access to whatever alpha
documentation I had.

Eric
