Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C12C433FE
	for <linux-api@archiver.kernel.org>; Wed, 17 Nov 2021 16:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5ECB61BFE
	for <linux-api@archiver.kernel.org>; Wed, 17 Nov 2021 16:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbhKQQec (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 17 Nov 2021 11:34:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55958 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239078AbhKQQe3 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 17 Nov 2021 11:34:29 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:33436)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mnNqL-00AvqG-5R; Wed, 17 Nov 2021 09:31:29 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:57668 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mnNqK-000CQN-0b; Wed, 17 Nov 2021 09:31:28 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Kyle Huey <me@kylehuey.com>,
        Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        Robert O'Callahan <rocallahan@gmail.com>,
        Marko =?utf-8?B?TcOka2Vsw6Q=?= <marko.makela@mariadb.com>,
        linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20211101034147.6203-1-khuey@kylehuey.com>
        <877ddqabvs.fsf@disp2133>
        <CAP045AqJVXA60R9RF8Gb2PWGBsK6bZ7tVBkdCcPYYrp6rOkG-Q@mail.gmail.com>
        <87fsse8maf.fsf@disp2133>
        <CAP045ApAX725ZfujaK-jJNkfCo5s+oVFpBvNfPJk+DKY8K7d=Q@mail.gmail.com>
        <CAP045AqsstnxfTyXhhCGDSucqGN7BTtfHJ5s6ZxUQC5K-JU56A@mail.gmail.com>
        <87bl2kekig.fsf_-_@email.froward.int.ebiederm.org>
        <875yssekcd.fsf_-_@email.froward.int.ebiederm.org>
        <202111161022.7B5720B@keescook>
Date:   Wed, 17 Nov 2021 10:31:20 -0600
In-Reply-To: <202111161022.7B5720B@keescook> (Kees Cook's message of "Tue, 16
        Nov 2021 10:23:48 -0800")
Message-ID: <877dd6bv6v.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mnNqK-000CQN-0b;;;mid=<877dd6bv6v.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19oxkzpsBrrn4aOH5JpxHcwA5X7nGF6NIo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/3] signal: In get_signal test for signal_group_exit every time through the loop
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Mon, Nov 15, 2021 at 11:32:50PM -0600, Eric W. Biederman wrote:
>> 
>> Recently while investigating a problem with rr and signals I noticed
>> that siglock is dropped in ptrace_signal and get_signal does not jump
>> to relock.
>> 
>> Looking farther to see if the problem is anywhere else I see that
>> do_signal_stop also returns if signal_group_exit is true.  I believe
>> that test can now never be true, but it is a bit hard to trace
>> through and be certain.
>> 
>> Testing signal_group_exit is not expensive, so move the test for
>> signal_group_exit into the for loop inside of get_signal to ensure
>> the test is never skipped improperly.
>
> Seems reasonable.
>
>> 
>> This has been a potential since I added the test for signal_group_exit
>
> nit: missing word after "potential"? "bug", "problem"?

Yes.  Potential problem.  I will update the comment.

>> was added.
>> 
>> Fixes: 35634ffa1751 ("signal: Always notice exiting tasks")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
>> ---
>>  kernel/signal.c | 20 ++++++++++----------
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>> 
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 7c4b7ae714d4..986fa69c15c5 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -2662,19 +2662,19 @@ bool get_signal(struct ksignal *ksig)
>>  		goto relock;
>>  	}
>>  
>> -	/* Has this task already been marked for death? */
>> -	if (signal_group_exit(signal)) {
>> -		ksig->info.si_signo = signr = SIGKILL;
>> -		sigdelset(&current->pending.signal, SIGKILL);
>> -		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
>> -				&sighand->action[SIGKILL - 1]);
>> -		recalc_sigpending();
>> -		goto fatal;
>> -	}
>> -
>>  	for (;;) {
>>  		struct k_sigaction *ka;
>>  
>> +		/* Has this task already been marked for death? */
>> +		if (signal_group_exit(signal)) {
>> +			ksig->info.si_signo = signr = SIGKILL;
>> +			sigdelset(&current->pending.signal, SIGKILL);
>> +			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
>> +				&sighand->action[SIGKILL - 1]);
>> +			recalc_sigpending();
>> +			goto fatal;
>> +		}
>> +
>>  		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
>>  		    do_signal_stop(0))
>>  			goto relock;
>> -- 
>> 2.20.1
>> 
