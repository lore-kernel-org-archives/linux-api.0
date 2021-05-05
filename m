Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34468C433ED
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AAB613C7
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhEEON5 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 5 May 2021 10:13:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43334 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbhEEONl (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 5 May 2021 10:13:41 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIGa-00CGlJ-DX; Wed, 05 May 2021 08:12:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIGX-002GvZ-Te; Wed, 05 May 2021 08:12:43 -0600
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
        <m1czuapjpx.fsf@fess.ebiederm.org>
        <CANpmjNNyifBNdpejc6ofT6+n6FtUw-Cap_z9Z9YCevd7Wf3JYQ@mail.gmail.com>
        <m14kfjh8et.fsf_-_@fess.ebiederm.org>
        <m1tuni8ano.fsf_-_@fess.ebiederm.org>
        <CANpmjNM5sYihM_9P5YHx06BooqLDhK96cMHGKaf61nCcoDJBdw@mail.gmail.com>
Date:   Wed, 05 May 2021 09:12:38 -0500
In-Reply-To: <CANpmjNM5sYihM_9P5YHx06BooqLDhK96cMHGKaf61nCcoDJBdw@mail.gmail.com>
        (Marco Elver's message of "Wed, 5 May 2021 00:05:00 +0200")
Message-ID: <m1o8dp8e21.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1leIGX-002GvZ-Te;;;mid=<m1o8dp8e21.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19By7EuCGlSC+Hrh/+dmLFpw1rmZv8aoeM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3 00/12] signal: sort out si_trapno and si_perf
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Marco Elver <elver@google.com> writes:

> On Tue, 4 May 2021 at 23:13, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> This set of changes sorts out the ABI issues with SIGTRAP TRAP_PERF, and
>> hopefully will can get merged before any userspace code starts using the
>> new ABI.
>>
>> The big ideas are:
>> - Placing the asserts first to prevent unexpected ABI changes
>> - si_trapno becomming ordinary fault subfield.
>> - struct signalfd_siginfo is almost full
>>
>> This set of changes starts out with Marco's static_assert changes and
>> additional one of my own that enforces the fact that the alignment of
>> siginfo_t is also part of the ABI.  Together these build time
>> checks verify there are no unexpected ABI changes in the changes
>> that follow.
>>
>> The field si_trapno is changed to become an ordinary extension of the
>> _sigfault member of siginfo.
>>
>> The code is refactored a bit and then si_perf_type is added along side
>> si_perf_data in the _perf subfield of _sigfault of siginfo_t.
>>
>> Finally the signalfd_siginfo fields are removed as they appear to be
>> filling up the structure without userspace actually being able to use
>> them.
>>
>> v2: https://lkml.kernel.org/r/m14kfjh8et.fsf_-_@fess.ebiederm.org
>> v1: https://lkml.kernel.org/r/m1zgxfs7zq.fsf_-_@fess.ebiederm.org
>>
>> Eric W. Biederman (9):
>>       signal: Verify the alignment and size of siginfo_t
>>       siginfo: Move si_trapno inside the union inside _si_fault
>>       signal: Implement SIL_FAULT_TRAPNO
>>       signal: Use dedicated helpers to send signals with si_trapno set
>>       signal: Remove __ARCH_SI_TRAPNO
>>       signal: Rename SIL_PERF_EVENT SIL_FAULT_PERF_EVENT for consistency
>>       signal: Factor force_sig_perf out of perf_sigtrap
>>       signal: Deliver all of the siginfo perf data in _perf
>>       signalfd: Remove SIL_FAULT_PERF_EVENT fields from signalfd_siginfo
>>
>> Marco Elver (3):
>>       sparc64: Add compile-time asserts for siginfo_t offsets
>>       arm: Add compile-time asserts for siginfo_t offsets
>>       arm64: Add compile-time asserts for siginfo_t offsets
>
> I can't seem to see the rest of them in my inbox. LKML also is missing
> them: https://lore.kernel.org/linux-api/m1tuni8ano.fsf_-_@fess.ebiederm.org/
>
> Something must have swallowed them. Could you resend?
> I'll then test in the morning.

They got stuck going out you should see them any time now.
Sorry about that.

Eric
