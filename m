Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EEFC43461
	for <linux-api@archiver.kernel.org>; Tue, 18 May 2021 03:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C270761350
	for <linux-api@archiver.kernel.org>; Tue, 18 May 2021 03:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbhERDsS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 17 May 2021 23:48:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48548 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbhERDsS (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 17 May 2021 23:48:18 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1liqgi-00AIup-W9; Mon, 17 May 2021 21:46:38 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1liqgf-00DpMa-Cz; Mon, 17 May 2021 21:46:32 -0600
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
        <m1a6ot5e2h.fsf_-_@fess.ebiederm.org>
        <CANpmjNM6rzyTp_+myecf8_773HLWDyJDbxFM6rWvzfKTLkXbhQ@mail.gmail.com>
Date:   Mon, 17 May 2021 22:46:19 -0500
In-Reply-To: <CANpmjNM6rzyTp_+myecf8_773HLWDyJDbxFM6rWvzfKTLkXbhQ@mail.gmail.com>
        (Marco Elver's message of "Mon, 17 May 2021 22:53:20 +0200")
Message-ID: <m1lf8c4sc4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1liqgf-00DpMa-Cz;;;mid=<m1lf8c4sc4.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Pcm16K+cqYXv6QpoQzYfCpXsEiNIW9QY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v4 0/5] siginfo: ABI fixes for TRAP_PERF
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Marco Elver <elver@google.com> writes:

> On Mon, 17 May 2021 at 21:58, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> During the merge window an issue with si_perf and the siginfo ABI came
>> up.  The alpha and sparc siginfo structure layout had changed with the
>> addition of SIGTRAP TRAP_PERF and the new field si_perf.
>>
>> The reason only alpha and sparc were affected is that they are the
>> only architectures that use si_trapno.
>>
>> Looking deeper it was discovered that si_trapno is used for only
>> a few select signals on alpha and sparc, and that none of the
>> other _sigfault fields past si_addr are used at all.  Which means
>> technically no regression on alpha and sparc.
>>
>> While the alignment concerns might be dismissed the abuse of
>> si_errno by SIGTRAP TRAP_PERF does have the potential to cause
>> regressions in existing userspace.
>>
>> While we still have time before userspace starts using and depending on
>> the new definition siginfo for SIGTRAP TRAP_PERF this set of changes
>> cleans up siginfo_t.
>>
>> - The si_trapno field is demoted from magic alpha and sparc status and
>>   made an ordinary union member of the _sigfault member of siginfo_t.
>>   Without moving it of course.
>>
>> - si_perf is replaced with si_perf_data and si_perf_type ending the
>>   abuse of si_errno.
>>
>> - Unnecessary additions to signalfd_siginfo are removed.
>>
>> v3: https://lkml.kernel.org/r/m1tuni8ano.fsf_-_@fess.ebiederm.org
>> v2: https://lkml.kernel.org/r/m14kfjh8et.fsf_-_@fess.ebiederm.org
>> v1: https://lkml.kernel.org/r/m1zgxfs7zq.fsf_-_@fess.ebiederm.org
>>
>> This version drops the tests and fine grained handling of si_trapno
>> on alpha and sparc (replaced assuming si_trapno is valid for
>> all but the faults that defined different data).
>
> And just to clarify, the rest of the series (including static-asserts)
> for the next merge-window will be sent once this series is all sorted,
> correct?

That is the plan.

I really wonder about alphas use of si_trapno, and alphas use send_sig
instead of force_sig.  It could be worth looking into those as it
has the potential to simplify the code.

>> Eric W. Biederman (5):
>>       siginfo: Move si_trapno inside the union inside _si_fault
>>       signal: Implement SIL_FAULT_TRAPNO
>>       signal: Factor force_sig_perf out of perf_sigtrap
>>       signal: Deliver all of the siginfo perf data in _perf
>>       signalfd: Remove SIL_PERF_EVENT fields from signalfd_siginfo
>
> Looks good, thank you! I build-tested (defconfig -- x86_64, i386, arm,
> arm64, m68k, sparc, alpha) this series together with a local patch to
> pull in the static asserts from v3. Also re-ran perf_events kselftests
> on x86_64 (native and 32bit compat).

Thanks,

Can I have your Tested-by?

Eric
