Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA36C433B4
	for <linux-api@archiver.kernel.org>; Thu,  6 May 2021 15:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 325D3611AE
	for <linux-api@archiver.kernel.org>; Thu,  6 May 2021 15:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhEFPPa (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 6 May 2021 11:15:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45168 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbhEFPP3 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 6 May 2021 11:15:29 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lefhp-005MIv-LY; Thu, 06 May 2021 09:14:25 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lefhl-0000RC-E9; Thu, 06 May 2021 09:14:22 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marco Elver <elver@google.com>, Arnd Bergmann <arnd@arndb.de>,
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
        <CAMuHMdUXh45iNmzrqqQc1kwD_OELHpujpst1BTMXDYTe7vKSCg@mail.gmail.com>
Date:   Thu, 06 May 2021 10:14:17 -0500
In-Reply-To: <CAMuHMdUXh45iNmzrqqQc1kwD_OELHpujpst1BTMXDYTe7vKSCg@mail.gmail.com>
        (Geert Uytterhoeven's message of "Thu, 6 May 2021 09:00:59 +0200")
Message-ID: <m1pmy36gja.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lefhl-0000RC-E9;;;mid=<m1pmy36gja.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19LyVyCtQprDRirlYQLwegi4JFnnMVJ0N8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3 00/12] signal: sort out si_trapno and si_perf
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Eric,
>
> On Tue, May 4, 2021 at 11:14 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
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
>
> Thanks for your series, which is now in next-20210506.
>
>>  arch/alpha/include/uapi/asm/siginfo.h              |   2 -
>>  arch/alpha/kernel/osf_sys.c                        |   2 +-
>>  arch/alpha/kernel/signal.c                         |   4 +-
>>  arch/alpha/kernel/traps.c                          |  24 ++---
>>  arch/alpha/mm/fault.c                              |   4 +-
>>  arch/arm/kernel/signal.c                           |  39 +++++++
>>  arch/arm64/kernel/signal.c                         |  39 +++++++
>>  arch/arm64/kernel/signal32.c                       |  39 +++++++
>>  arch/mips/include/uapi/asm/siginfo.h               |   2 -
>>  arch/sparc/include/uapi/asm/siginfo.h              |   3 -
>>  arch/sparc/kernel/process_64.c                     |   2 +-
>>  arch/sparc/kernel/signal32.c                       |  37 +++++++
>>  arch/sparc/kernel/signal_64.c                      |  36 +++++++
>>  arch/sparc/kernel/sys_sparc_32.c                   |   2 +-
>>  arch/sparc/kernel/sys_sparc_64.c                   |   2 +-
>>  arch/sparc/kernel/traps_32.c                       |  22 ++--
>>  arch/sparc/kernel/traps_64.c                       |  44 ++++----
>>  arch/sparc/kernel/unaligned_32.c                   |   2 +-
>>  arch/sparc/mm/fault_32.c                           |   2 +-
>>  arch/sparc/mm/fault_64.c                           |   2 +-
>>  arch/x86/kernel/signal_compat.c                    |  15 ++-
>
> No changes needed for other architectures?
> All m68k configs are broken with

Thanks.  I hadn't realized that si_perf asserts existed on m68k.
Thankfully linux-next caught this these.

Looking a little more deeply, it is strange that this is tested on m68k.
The architecture does not implement HAVE_PERF_EVENTS so it is impossible
for this signal to be generated.

On the off chance this these new signals will appear on m68k someday I
will update the assertion.

> arch/m68k/kernel/signal.c:626:35: error: 'siginfo_t' {aka 'struct
> siginfo'} has no member named 'si_perf'; did you mean 'si_errno'?
>
> See e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/14537820/
>
> There are still a few more references left to si_perf:
>
> $ git grep -n -w si_perf
> Next/merge.log:2902:Merging userns/for-next (4cf4e48fff05 signal: sort
> out si_trapno and si_perf)
> arch/m68k/kernel/signal.c:626:  BUILD_BUG_ON(offsetof(siginfo_t,
> si_perf) != 0x10);
> include/uapi/linux/perf_event.h:467:     * siginfo_t::si_perf, e.g. to
> permit user to identify the event.
> tools/testing/selftests/perf_events/sigtrap_threads.c:46:/* Unique
> value to check si_perf is correctly set from
> perf_event_attr::sig_data. */

I will sweep them up as well.

Eric
