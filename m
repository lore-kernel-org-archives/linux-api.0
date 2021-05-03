Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F22CC43460
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 19:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E99C613BC
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 19:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhECTjp (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 May 2021 15:39:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42650 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECTjo (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 May 2021 15:39:44 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldeP2-00HDI3-Qv; Mon, 03 May 2021 13:38:48 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldeOx-00DxKW-Li; Mon, 03 May 2021 13:38:48 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Marco Elver <elver@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Weimer <fweimer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        <m11rarqqx2.fsf_-_@fess.ebiederm.org>
        <CANpmjNNJ_MnNyD4R2+9i24E=9xPHKnwTh6zwWtBYkuAq1Xo6-w@mail.gmail.com>
        <m1wnshm14b.fsf@fess.ebiederm.org>
        <YI/wJSwQitisM8Xf@hirez.programming.kicks-ass.net>
Date:   Mon, 03 May 2021 14:38:39 -0500
In-Reply-To: <YI/wJSwQitisM8Xf@hirez.programming.kicks-ass.net> (Peter
        Zijlstra's message of "Mon, 3 May 2021 14:44:21 +0200")
Message-ID: <m1sg33ip4w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1ldeOx-00DxKW-Li;;;mid=<m1sg33ip4w.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX193P6Zs47y9HH8Pk31Hd8htHGyDNhcJWFA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 7/3] signal: Deliver all of the perf_data in si_perf
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Sun, May 02, 2021 at 01:39:16PM -0500, Eric W. Biederman wrote:
>
>> The one thing that this doesn't do is give you a 64bit field
>> on 32bit architectures.
>> 
>> On 32bit builds the layout is:
>> 
>> 	int si_signo;
>> 	int si_errno;
>> 	int si_code;
>> 	void __user *_addr;
>>         
>> So I believe if the first 3 fields were moved into the _sifields union
>> si_perf could define a 64bit field as it's first member and it would not
>> break anything else.
>> 
>> Given that the data field is 64bit that seems desirable.
>
> The data field is fundamentally an address, it is internally a u64
> because the perf ring buffer has u64 alignment and it saves on compat
> crap etc.
>
> So for the 32bit/compat case the high bits will always be 0 and
> truncating into an unsigned long is fine.

I see why it is fine to truncate the data field into an unsigned long.

Other than technical difficulties in extending siginfo_t is there any
reason not to define data as a __u64?

Eric
