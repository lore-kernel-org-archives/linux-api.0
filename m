Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by archive.lwn.net (Postfix) with ESMTP id 523C27D910
	for <lwn-linux-api@archive.lwn.net>; Wed, 11 Mar 2020 16:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgCKQbm (ORCPT <rfc822;lwn-linux-api@archive.lwn.net>);
        Wed, 11 Mar 2020 12:31:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54052 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbgCKQbm (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 11 Mar 2020 12:31:42 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jC4GW-0001qd-9w; Wed, 11 Mar 2020 10:31:28 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jC4GV-0006Xl-GD; Wed, 11 Mar 2020 10:31:28 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez13XXWNRLrPFRHRsvPKSwSK1-6k+1F7QujWOJtVuk0QHg@mail.gmail.com>
        <87wo7roq2c.fsf@x220.int.ebiederm.org>
        <CAG48ez1j2=pdj0nc1syHkh6X4d=aHuCH1srzA6hT7+32QD+6Gg@mail.gmail.com>
        <87k13roigf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51709C444F21281F6A40F039E4FC0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Wed, 11 Mar 2020 11:29:08 -0500
In-Reply-To: <AM6PR03MB51709C444F21281F6A40F039E4FC0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Wed, 11 Mar 2020 07:33:35 +0100")
Message-ID: <87d09ionxn.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jC4GV-0006Xl-GD;;;mid=<87d09ionxn.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ZjP97Ct6MFalNH8PhJ+rPzWt746X6+Og=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
Archived-At: <http://archive.lwn.net:8080/linux-api/87d09ionxn.fsf@x220.int.ebiederm.org/>
List-Archive: <http://archive.lwn.net:8080/linux-api/>
List-Post: <mailto:linux-api@vger.kernel.org>

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/11/20 1:15 AM, Eric W. Biederman wrote:
>> Jann Horn <jannh@google.com> writes:
>> 
>>> On Tue, Mar 10, 2020 at 10:33 PM Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Jann Horn <jannh@google.com> writes:
>>>>> On Sun, Mar 8, 2020 at 10:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>>>> over the userspace accesses as the arguments from userspace are read.
>>>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>>>> threads are killed.  The cred_guard_mutex is held over
>>>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>>>
>>>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>>>> over a possible indefinite userspace waits for userspace.
>>>>>>
>>>>>> Add exec_update_mutex that is only held over exec updating process
>>>>>> with the new contents of exec, so that code that needs not to be
>>>>>> confused by exec changing the mm and the cred in ways that can not
>>>>>> happen during ordinary execution of a process.
>>>>>>
>>>>>> The plan is to switch the users of cred_guard_mutex to
>>>>>> exec_udpate_mutex one by one.  This lets us move forward while still
>>>>>> being careful and not introducing any regressions.
>>>>> [...]
>>>>>> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>>>>>>                         return -EINTR;
>>>>>>                 }
>>>>>>         }
>>>>>> +
>>>>>> +       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>>>>>> +       if (ret)
>>>>>> +               return ret;
>>>>>
>>>>> We're already holding the old mmap_sem, and now nest the
>>>>> exec_update_mutex inside it; but then while still holding the
>>>>> exec_update_mutex, we do mmput(), which can e.g. end up in ksm_exit(),
>>>>> which can do down_write(&mm->mmap_sem) from __ksm_exit(). So I think
>>>>> at least lockdep will be unhappy, and I'm not sure whether it's an
>>>>> actual problem or not.
>>>>
>>>> Good point.  I should double check the lock ordering here with mmap_sem.
>>>> It doesn't look like mmput takes mmap_sem
>>>
>>> You sure about that? mmput() -> __mmput() -> ksm_exit() ->
>>> __ksm_exit() -> down_write(&mm->mmap_sem)
>>>
>>> Or also: mmput() -> __mmput() -> khugepaged_exit() ->
>>> __khugepaged_exit() -> down_write(&mm->mmap_sem)
>>>
>>> Or is there a reason why those paths can't happen?
>> 
>> Clearly I didn't look far enough. 
>> 
>> I will adjust this so that exec_update_mutex is taken before mmap_sem.
>> Anything else is just asking for trouble.
>> 
>
> Note that vm_access does also mmput under the exec_update_mutex.
> So I don't see a huge problem here.
> But maybe I missed something.

The issue is that to prevent deadlock locks must always be taken
in the same order.

Taking mmap_sem then exec_update_mutex at the start of the function,
then taking exec_update_mutex then mmap_sem in mmput, takes the
two locks in two different orders.   Which means that in the right
set or circumstances:

thread1:                                thread2:
   obtain mmap_sem                      optain exec_update_mutex
      wait for exec_update_mutex        wait for mmap_sem

Which guarantees that neither thread will make progress.

The fix is easy I just need to take exec_update_mutex a few lines
earlier.

Eric

