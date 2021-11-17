Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C756BC433EF
	for <linux-api@archiver.kernel.org>; Wed, 17 Nov 2021 16:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD04161C32
	for <linux-api@archiver.kernel.org>; Wed, 17 Nov 2021 16:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhKQQyO (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 17 Nov 2021 11:54:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46598 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbhKQQyM (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 17 Nov 2021 11:54:12 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:56300)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mnO9R-00Ffy8-C7; Wed, 17 Nov 2021 09:51:13 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:58388 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mnO9P-0076Zs-BI; Wed, 17 Nov 2021 09:51:12 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kyle Huey <me@kylehuey.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Robert O'Callahan" <rocallahan@gmail.com>,
        Marko =?utf-8?B?TcOka2Vsw6Q=?= <marko.makela@mariadb.com>,
        Linux API <linux-api@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
References: <20211101034147.6203-1-khuey@kylehuey.com>
        <877ddqabvs.fsf@disp2133>
        <CAP045AqJVXA60R9RF8Gb2PWGBsK6bZ7tVBkdCcPYYrp6rOkG-Q@mail.gmail.com>
        <87fsse8maf.fsf@disp2133>
        <CAP045ApAX725ZfujaK-jJNkfCo5s+oVFpBvNfPJk+DKY8K7d=Q@mail.gmail.com>
        <CAP045AqsstnxfTyXhhCGDSucqGN7BTtfHJ5s6ZxUQC5K-JU56A@mail.gmail.com>
        <87bl2kekig.fsf_-_@email.froward.int.ebiederm.org>
        <CAP045AqSKv8hAz79ntbj6ZoGiO-v7M0UBuQF2hwJdXqqL7oxWA@mail.gmail.com>
Date:   Wed, 17 Nov 2021 10:51:03 -0600
In-Reply-To: <CAP045AqSKv8hAz79ntbj6ZoGiO-v7M0UBuQF2hwJdXqqL7oxWA@mail.gmail.com>
        (Kyle Huey's message of "Wed, 17 Nov 2021 08:24:28 -0800")
Message-ID: <87y25m9154.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mnO9P-0076Zs-BI;;;mid=<87y25m9154.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/SsM6pAPjKLdFDsz+YJA6Oh8adTVDjXuw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/3] signal: requeuing undeliverable signals
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kyle Huey <me@kylehuey.com> writes:

> On Mon, Nov 15, 2021 at 9:31 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>>
>> Kyle Huey recently reported[1] that rr gets confused if SIGKILL prevents
>> ptrace_signal from delivering a signal, as the kernel setups up a signal
>> frame for a signal that rr did not have a chance to observe with ptrace.
>>
>> In looking into it I found a couple of bugs and a quality of
>> implementation issue.
>>
>> - The test for signal_group_exit should be inside the for loop in get_signal.
>> - Signals should be requeued on the same queue they were dequeued from.
>> - When a fatal signal is pending ptrace_signal should not return another
>>   signal for delivery.
>>
>> Kyle Huey has verified[2] an earlier version of this change.
>>
>> I have reworked things one more time to completely fix the issues
>> raised, and to keep the code maintainable long term.
>>
>> I have smoke tested this code and combined with a careful review I
>> expect this code to work fine.  Kyle if you can double check that
>> my last round of changes still works for rr I would appreciate it.
>
> This still fixes the race we reported.

>
> Tested-by: Kyle Huey <khuey@kylehuey.com>

Thank you very much for retesting.

Eric
