Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125D8C3F2CD
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 05:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB44B20848
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 05:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgCFFTj (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 00:19:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49550 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgCFFTj (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 6 Mar 2020 00:19:39 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5Ob-00080J-2q; Thu, 05 Mar 2020 22:19:37 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5Oa-0004mH-2R; Thu, 05 Mar 2020 22:19:36 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
        <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
        <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 05 Mar 2020 23:17:22 -0600
In-Reply-To: <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Thu, 5 Mar 2020 21:51:47 +0000")
Message-ID: <87k13yawpp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jA5Oa-0004mH-2R;;;mid=<87k13yawpp.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+J/DXdoLQypOl9c7LRZTltm9MC8zEn+gI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
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
>> happen during ordinary execution of a process can take.
>> 
>> The plan is to switch the users of cred_guard_mutex to
>> exed_udpate_mutex one by one.  This lets us move forward while still
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
>>  fs/exec.c                    | 4 ++++
>>  include/linux/sched/signal.h | 9 ++++++++-
>>  kernel/fork.c                | 1 +
>>  3 files changed, 13 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index c243f9660d46..ad7b518f906d 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1182,6 +1182,7 @@ static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>>  		release_task(leader);
>>  	}
>>  
>> +	mutex_lock(&current->signal->exec_update_mutex);
>>  	bprm->unrecoverable = true;
>>  	sig->group_exit_task = NULL;
>>  	sig->notify_count = 0;
>> @@ -1425,6 +1426,8 @@ static void free_bprm(struct linux_binprm *bprm)
>>  {
>>  	free_arg_pages(bprm);
>>  	if (bprm->cred) {
>> +		if (bprm->unrecoverable)
>> +			mutex_unlock(&current->signal->exec_update_mutex);
>>  		mutex_unlock(&current->signal->cred_guard_mutex);
>>  		abort_creds(bprm->cred);
>>  	}
>> @@ -1474,6 +1477,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>>  	 * credentials; any time after this it may be unlocked.
>>  	 */
>>  	security_bprm_committed_creds(bprm);
>> +	mutex_unlock(&current->signal->exec_update_mutex);
>>  	mutex_unlock(&current->signal->cred_guard_mutex);
>>  }
>>  EXPORT_SYMBOL(install_exec_creds);
>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
>> index 88050259c466..a29df79540ce 100644
>> --- a/include/linux/sched/signal.h
>> +++ b/include/linux/sched/signal.h
>> @@ -224,7 +224,14 @@ struct signal_struct {
>>  
>>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>>  					 * credential calculations
>> -					 * (notably. ptrace) */
>> +					 * (notably. ptrace)
>> +					 * Deprecated do not use in new code.
>> +					 * Use exec_update_mutex instead.
>> +					 */
>> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
>> +					 * updated during exec, and may have
>> +					 * inconsistent permissions.
>> +					 */
>>  } __randomize_layout;
>>  
>>  /*
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 60a1295f4384..12896a6ecee6 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>>  
>>  	mutex_init(&sig->cred_guard_mutex);
>> +	mutex_init(&sig->exec_update_mutex);
>>  
>>  	return 0;
>>  }
>> 
> Don't you need to add something like this to init/init_task.c ?
>
> .exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),

Yes.  I overlooked that.  Thank you.

Eric

