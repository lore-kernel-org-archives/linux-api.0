Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E984C433ED
	for <linux-api@archiver.kernel.org>; Sat,  1 May 2021 15:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4204D61462
	for <linux-api@archiver.kernel.org>; Sat,  1 May 2021 15:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhEAPR4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 1 May 2021 11:17:56 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51592 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhEAPRz (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 1 May 2021 11:17:55 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcrMc-00DX9j-SQ; Sat, 01 May 2021 09:17:03 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcrMb-008qNO-TS; Sat, 01 May 2021 09:17:02 -0600
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
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
        <m1r1irpc5v.fsf@fess.ebiederm.org>
        <CANpmjNNfiSgntiOzgMc5Y41KVAV_3VexdXCMADekbQEqSP3vqQ@mail.gmail.com>
Date:   Sat, 01 May 2021 10:16:58 -0500
In-Reply-To: <CANpmjNNfiSgntiOzgMc5Y41KVAV_3VexdXCMADekbQEqSP3vqQ@mail.gmail.com>
        (Marco Elver's message of "Sat, 1 May 2021 02:37:22 +0200")
Message-ID: <m1czuapjpx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcrMb-008qNO-TS;;;mid=<m1czuapjpx.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18DzHMcLYDrGj+W7oEcRW3RY5bEckDfeoo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC][PATCH 0/3] signal: Move si_trapno into the _si_fault union
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Marco Elver <elver@google.com> writes:

> On Sat, 1 May 2021 at 01:48, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Well with 7 patches instead of 3 that was a little more than I thought
>> I was going to send.
>>
>> However that does demonstrate what I am thinking, and I think most of
>> the changes are reasonable at this point.
>>
>> I am very curious how synchronous this all is, because if this code
>> is truly synchronous updating signalfd to handle this class of signal
>> doesn't really make sense.
>>
>> If the code is not synchronous using force_sig is questionable.
>>
>> Eric W. Biederman (7):
>>       siginfo: Move si_trapno inside the union inside _si_fault
>>       signal: Implement SIL_FAULT_TRAPNO
>>       signal: Use dedicated helpers to send signals with si_trapno set
>>       signal: Remove __ARCH_SI_TRAPNO
>>       signal: Rename SIL_PERF_EVENT SIL_FAULT_PERF_EVENT for consistency
>>       signal: Factor force_sig_perf out of perf_sigtrap
>>       signal: Deliver all of the perf_data in si_perf
>
> Thank you for doing this so quickly -- it looks much cleaner. I'll
> have a more detailed look next week and also run some tests myself.
>
> At a first glance, you've broken our tests in
> tools/testing/selftests/perf_events/ -- needs a
> s/si_perf/si_perf.data/, s/si_errno/si_perf.type/

Yeah.  I figured I did, but I couldn't figure out where the tests were
and I didn't have a lot of time.  I just wanted to get this out so we
can do as much as reasonable before the ABI starts being actively used
by userspace and we can't change it.

Eric
