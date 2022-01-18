Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FC9C433F5
	for <linux-api@archiver.kernel.org>; Tue, 18 Jan 2022 18:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347791AbiARSKZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 18 Jan 2022 13:10:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43220 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiARSKX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 18 Jan 2022 13:10:23 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:48006)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n9sw0-0028Bm-Ki; Tue, 18 Jan 2022 11:10:20 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:60400 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n9svz-0026qb-Ei; Tue, 18 Jan 2022 11:10:20 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        "Kenta.Tada@sony.com" <Kenta.Tada@sony.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ed Tsai <ed.tsai@mediatek.com>, linux-api@vger.kernel.org
References: <20220117164633.322550-1-valentin.schneider@arm.com>
        <20220117164633.322550-3-valentin.schneider@arm.com>
        <878rve89cc.fsf@email.froward.int.ebiederm.org>
        <878rvd6jgu.mognet@arm.com>
Date:   Tue, 18 Jan 2022 12:10:12 -0600
In-Reply-To: <878rvd6jgu.mognet@arm.com> (Valentin Schneider's message of
        "Tue, 18 Jan 2022 17:29:21 +0000")
Message-ID: <87h7a06hkr.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1n9svz-0026qb-Ei;;;mid=<87h7a06hkr.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+GdPcXRX9fPx6fHK6oCi3BAAvq5AF1mLk=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 2/2] sched/tracing: Add TASK_RTLOCK_WAIT to TASK_REPORT
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Valentin Schneider <valentin.schneider@arm.com> writes:

> On 17/01/22 13:12, Eric W. Biederman wrote:
>> Valentin Schneider <valentin.schneider@arm.com> writes:
>>> --- a/fs/proc/array.c
>>> +++ b/fs/proc/array.c
>>> @@ -128,9 +128,10 @@ static const char * const task_state_array[] = {
>>>  	"X (dead)",		/* 0x10 */
>>>  	"Z (zombie)",		/* 0x20 */
>>>  	"P (parked)",		/* 0x40 */
>>> +	"L (rt-locked)",        /* 0x80 */
>>>  
>>>  	/* states beyond TASK_REPORT: */
>>> -	"I (idle)",		/* 0x80 */
>>> +	"I (idle)",		/* 0x100 */
>>>  };
>>
>> I think this is at least possibly an ABI break.  I have a vague memory
>> that userspace is not ready being reported new task states.  Which is
>> why we encode some of our states the way we do.
>>
>> Maybe it was just someone being very conservative.
>>
>> Still if you are going to add new states to userspace and risk breaking
>> them can you do some basic analysis and report what ps and similar
>> programs do.
>>
>> Simply changing userspace without even mentioning that you are changing
>> the userspace output of proc looks dangerous indeed.
>>
>
> Yeah, you're right.
>
>> Looking in the history commit 74e37200de8e ("proc: cleanup/simplify
>> get_task_state/task_state_array") seems to best document the concern
>> that userspace does not know how to handle new states.
>>
>
> Thanks for the sha1 and for digging around. Now, I read
> 74e37200de8e ("proc: cleanup/simplify get_task_state/task_state_array")
> as "get_task_state() isn't clear vs what value is actually exposed to
> userspace" rather than "get_task_state() could expose things userspace
> doesn't know what to do with".

There is also commit abd50b39e783 ("wait: introduce EXIT_TRACE to avoid
the racy EXIT_DEAD->EXIT_ZOMBIE transition").

Which I think is more of what I was remembering.

>> The fact we have had a parked state for quite a few years despite that
>> concern seems to argue it is possible to extend the states.  Or perhaps
>> it just argues that parked states are rare enough it does not matter.
>>
>> It is definitely the case that the ps manpage documents the possible
>> states and as such they could be a part of anyone's shell scripts.
>>
>
> 06eb61844d84 ("sched/debug: Add explicit TASK_IDLE printing") for instance
> seems to suggest extending the states OK, but you're right that this then
> requires updating ps' manpage.
>
> Alternatively, TASK_RTLOCK_WAIT could be masqueraded as
> TASK_(UN)INTERRUPTIBLE when reported to userspace - it is actually somewhat
> similar, unlike TASK_IDLE vs TASK_UNINTERRUPTIBLE for instance. The
> handling in get_task_state() will be fugly, but it might be preferable over
> exposing a detail userspace might not need to be made aware of?

Right.

Frequently I have seen people do a cost/benefit analysis.

If the benefit is enough, and tracking down the userspace programs that
need to be verified to work with the change is inexpensive enough the
change is made.  Always keeping in mind that if something was missed and
the change causes a regression the change will need to be reverted.

If there is little benefit or the cost to track down userspace is great
enough the work is put in to hide the change from userspace.  Just
because it is too much trouble to expose it to userspace.

I honestly don't have any kind of sense about how hard it is to verify
that a userspace regression won't result from a change like this.  I
just know that the question needs to be asked.

Eric
