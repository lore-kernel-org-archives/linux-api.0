Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E34C433ED
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 15:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A9AA61004
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 15:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245158AbhEQPdQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 17 May 2021 11:33:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38832 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244432AbhEQPbO (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 17 May 2021 11:31:14 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lifBk-0003MZ-KS; Mon, 17 May 2021 09:29:48 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lifBj-00BZOl-IR; Mon, 17 May 2021 09:29:48 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Weimer <fweimer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <m15z031z0a.fsf@fess.ebiederm.org>
        <YIxVWkT03TqcJLY3@elver.google.com>
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
        <m1r1irpc5v.fsf@fess.ebiederm.org>
        <CANpmjNNfiSgntiOzgMc5Y41KVAV_3VexdXCMADekbQEqSP3vqQ@mail.gmail.com>
        <m1czuapjpx.fsf@fess.ebiederm.org>
        <CANpmjNNyifBNdpejc6ofT6+n6FtUw-Cap_z9Z9YCevd7Wf3JYQ@mail.gmail.com>
        <m14kfjh8et.fsf_-_@fess.ebiederm.org>
        <m1tuni8ano.fsf_-_@fess.ebiederm.org>
        <m1a6oxewym.fsf_-_@fess.ebiederm.org> <YKDMWXj2YDkDy1DG@gmail.com>
Date:   Mon, 17 May 2021 10:29:39 -0500
In-Reply-To: <YKDMWXj2YDkDy1DG@gmail.com> (Ingo Molnar's message of "Sun, 16
        May 2021 09:40:09 +0200")
Message-ID: <m1wnrx750c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lifBj-00BZOl-IR;;;mid=<m1wnrx750c.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX199lR/IyLLJ1RHiRf25MlrgYHNCCIjDaII=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT PULL] siginfo: ABI fixes for v5.13-rc2
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Looking deeper it was discovered that si_trapno is used for only
>> a few select signals on alpha and sparc, and that none of the
>> other _sigfault fields past si_addr are used at all.  Which means
>> technically no regression on alpha and sparc.
>
> If there's no functional regression on any platform, could much of this 
> wait until v5.14, or do we want some of these cleanups right now?
>
> The fixes seem to be for long-existing bugs, not fresh regressions, AFAICS. 
> The asserts & cleanups are useful, but not regression fixes.
>
> I.e. this is a bit scary:

The new ABI for SIGTRAP TRAP perf that came in the merge window is
broken and wrong.  We need to revert/disable the new SIGTRAP TRAP_PERF
or have a fix before v5.13.

The issue is old crap getting in the way of a new addition.  I think I
might see a smaller code change on how to get to something compatible
with this.

>>  32 files changed, 377 insertions(+), 163 deletions(-)
>
> at -rc2 time.

The additions are all tests to make certain everything is fine.
The actual code change without the assertions (tests) is essentially
a wash.

Eric

