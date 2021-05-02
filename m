Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F1CC43460
	for <linux-api@archiver.kernel.org>; Sun,  2 May 2021 18:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165B861352
	for <linux-api@archiver.kernel.org>; Sun,  2 May 2021 18:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhEBS2T (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 2 May 2021 14:28:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39128 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhEBS2T (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 2 May 2021 14:28:19 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldGoQ-00FXga-HS; Sun, 02 May 2021 12:27:26 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldGoP-00BO9w-MT; Sun, 02 May 2021 12:27:26 -0600
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
        <m1tunns7yf.fsf_-_@fess.ebiederm.org>
        <CANpmjNOZj-jRfFH365znJGqDAwdXL4Z2QBuHOtdvN_uNJ8WBSA@mail.gmail.com>
Date:   Sun, 02 May 2021 13:27:21 -0500
In-Reply-To: <CANpmjNOZj-jRfFH365znJGqDAwdXL4Z2QBuHOtdvN_uNJ8WBSA@mail.gmail.com>
        (Marco Elver's message of "Sat, 1 May 2021 12:31:10 +0200")
Message-ID: <m1czu9ng8m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1ldGoP-00BO9w-MT;;;mid=<m1czu9ng8m.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+I6HZ0cD4XvYQ+uzlALtJgYoOqGyYDPxk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/3] siginfo: Move si_trapno inside the union inside _si_fault
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Marco Elver <elver@google.com> writes:

> On Sat, 1 May 2021 at 00:50, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> It turns out that linux uses si_trapno very sparingly, and as such it
>> can be considered extra information for a very narrow selection of
>> signals, rather than information that is present with every fault
>> reported in siginfo.
>>
>> As such move si_trapno inside the union inside of _si_fault.  This
>> results in no change in placement, and makes it eaiser to extend
>> _si_fault in the future as this reduces the number of special cases.
>> In particular with si_trapno included in the union it is no longer a
>> concern that the union must be pointer alligned on most architectures
>> because the union followes immediately after si_addr which is a
>> pointer.
>>
>
> Maybe add "Link:
> https://lkml.kernel.org/r/CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com"
>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Acked-by: Marco Elver <elver@google.com>
>
> By no longer guarding it with __ARCH_SI_TRAPNO we run the risk that it
> will be used by something else at some point. Is that intentional?

The motivation was letting the code be tested on other architectures.

But once si_trapno falls inside the union instead of being present for
every signal reporting a fault it doesn't really matter.

I think it would be poor taste but harmless to use si_trapno, mostly
because defining a new entry in the union could be more specific and
well defined.

Eric
