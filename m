Return-Path: <SRS0=5exw=45=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B14CC10DCE
	for <linux-api@archiver.kernel.org>; Thu, 12 Mar 2020 12:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2C6206FA
	for <linux-api@archiver.kernel.org>; Thu, 12 Mar 2020 12:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCLM1R (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:27:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54454 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLM1R (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 12 Mar 2020 08:27:17 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jCMvg-0008B2-FJ; Thu, 12 Mar 2020 06:27:12 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jCMvf-0006RZ-FN; Thu, 12 Mar 2020 06:27:12 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
        <87v9nmjulm.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <202003021531.C77EF10@keescook>
        <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
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
        <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com>
Date:   Thu, 12 Mar 2020 07:24:50 -0500
In-Reply-To: <f37a5d68-9674-533f-ee9c-a49174605710@virtuozzo.com> (Kirill
        Tkhai's message of "Thu, 12 Mar 2020 13:27:30 +0300")
Message-ID: <87d09hn4kt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jCMvf-0006RZ-FN;;;mid=<87d09hn4kt.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX197oHUB4P7o25mD2mW/iWh+TbBM6TNe7gs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kirill Tkhai <ktkhai@virtuozzo.com> writes:

> On 09.03.2020 00:38, Eric W. Biederman wrote:
>> 
>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>> over the userspace accesses as the arguments from userspace are read.
>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>> threads are killed.  The cred_guard_mutex is held over
>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>> 
>> Any of those can result in deadlock, as the cred_guard_mutex is held
>> over a possible indefinite userspace waits for userspace.
>> 
>> Add exec_update_mutex that is only held over exec updating process
>> with the new contents of exec, so that code that needs not to be
>> confused by exec changing the mm and the cred in ways that can not
>> happen during ordinary execution of a process.
>> 
>> The plan is to switch the users of cred_guard_mutex to
>> exec_udpate_mutex one by one.  This lets us move forward while still
>> being careful and not introducing any regressions.
>> 
>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c                    | 9 +++++++++
>>  include/linux/sched/signal.h | 9 ++++++++-
>>  init/init_task.c             | 1 +
>>  kernel/fork.c                | 1 +
>>  4 files changed, 19 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index d820a7272a76..ffeebb1f167b 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1014,6 +1014,7 @@ static int exec_mmap(struct mm_struct *mm)
>>  {
>>  	struct task_struct *tsk;
>>  	struct mm_struct *old_mm, *active_mm;
>> +	int ret;
>>  
>>  	/* Notify parent that we're no longer interested in the old VM */
>>  	tsk = current;
>> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>>  			return -EINTR;
>>  		}
>>  	}
>> +
>> +	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>> +	if (ret)
>> +		return ret;
>
> You missed old_mm->mmap_sem unlock. See here:

Duh.  Thank you.

I actually need to switch the lock ordering here, and I haven't yet
because my son was sick yesterday.

Something like this.

diff --git a/fs/exec.c b/fs/exec.c
index 96f89401b4d1..03d50c27ec01 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1020,9 +1020,14 @@ static int exec_mmap(struct mm_struct *mm)
        tsk = current;
        old_mm = current->mm;
        exec_mm_release(tsk, old_mm);
+       if (old_mm)
+               sync_mm_rss(old_mm);
+
+       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+       if (ret)
+               return ret;
 
        if (old_mm) {
-               sync_mm_rss(old_mm);
                /*
                 * Make sure that if there is a core dump in progress
                 * for the old mm, we get out and die instead of going
@@ -1032,14 +1037,11 @@ static int exec_mmap(struct mm_struct *mm)
                down_read(&old_mm->mmap_sem);
                if (unlikely(old_mm->core_state)) {
                        up_read(&old_mm->mmap_sem);
+                       mutex_unlock(&tsk->signal->exec_update_mutex);
                        return -EINTR;
                }
        }
 
-       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
-       if (ret)
-               return ret;
-
        task_lock(tsk);
        active_mm = tsk->active_mm;
        membarrier_exec_mmap(mm);



> diff --git a/fs/exec.c b/fs/exec.c
> index 47582cd97f86..d557bac3e862 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1063,8 +1063,11 @@ static int exec_mmap(struct mm_struct *mm)
>  	}
>  
>  	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
> -	if (ret)
> +	if (ret) {
> +		if (old_mm)
> +			up_read(&old_mm->mmap_sem);
>  		return ret;
> +	}
>  
>  	task_lock(tsk);
>  	active_mm = tsk->active_mm;

Eric
