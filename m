Return-Path: <SRS0=PdVN=4Z=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DCAC10DCE
	for <linux-api@archiver.kernel.org>; Sun,  8 Mar 2020 18:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08B6620637
	for <linux-api@archiver.kernel.org>; Sun,  8 Mar 2020 18:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgCHSOu (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 8 Mar 2020 14:14:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35580 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgCHSOu (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 8 Mar 2020 14:14:50 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB0Rg-0000s1-Lt; Sun, 08 Mar 2020 12:14:36 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB0Rf-00049Y-Pk; Sun, 08 Mar 2020 12:14:36 -0600
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
        <87k13yawpp.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87sgil87s3.fsf@x220.int.ebiederm.org>
        <87a74t86cs.fsf@x220.int.ebiederm.org>
        <87v9nh6koh.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170B44BAD4B9402F29B8B58E4E10@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sun, 08 Mar 2020 13:12:14 -0500
In-Reply-To: <AM6PR03MB5170B44BAD4B9402F29B8B58E4E10@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Sun, 8 Mar 2020 12:58:33 +0000")
Message-ID: <87d09m7m2p.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jB0Rf-00049Y-Pk;;;mid=<87d09m7m2p.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18zivdmh9crMBehDVbxDTXy5jTo3YZzPPQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] exec: make de_thread alloc new signal struct earlier
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> It was pointed out that de_thread may return -ENOMEM
> when it already terminated threads, and returning
> an error from execve, except when a fatal signal is
> being delivered is not an option any more.
>
> Allocate the memory for the signal table earlier,
> and make sure that -ENOMEM is returned before the
> unrecoverable actions are started.
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
> Eric, what do you think, might this be helpful
> to move the "point of no return" lower, and simplify
> your patch?

Good thinking but no.  In this case it is possible to move the entire
allocation lower.  As well as the posix timer cleanup.  That code is
actually much clearer outside of de_thread.  I will post a patch in that
direction in a moment.

It is something of a bad idea to move the new sighand allocation sooner
because in practice it does not happen.  It only exists to support the
CLONE_VM | CLONE_SIGHAND without CLONE_SIGNAL case which is not used
by the modern posix thread libraries.

There are just enough old executables floating out there that I don't
think we can remove the CLONE_SIGHAND case in general but I keep
dreaming about it.  We get a lot of complexity in the code to support
something that no one really does anymore.

Eric

>  fs/exec.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 74d88da..a0328dc 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1057,16 +1057,26 @@ static int exec_mmap(struct mm_struct *mm)
>   * disturbing other processes.  (Other processes might share the signal
>   * table via the CLONE_SIGHAND option to clone().)
>   */
> -static int de_thread(struct task_struct *tsk)
> +static int de_thread(void)
>  {
> +	struct task_struct *tsk = current;
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
>  	spinlock_t *lock = &oldsighand->siglock;
> +	struct sighand_struct *newsighand = NULL;
>  
>  	if (thread_group_empty(tsk))
>  		goto no_thread_group;
>  
>  	/*
> +	 * This is the last time for an out of memory error.
> +	 * After this point only fatal signals are are okay.
> +	 */
> +	newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
> +	if (!newsighand)
> +		return -ENOMEM;
> +
> +	/*
>  	 * Kill all other threads in the thread group.
>  	 */
>  	spin_lock_irq(lock);
> @@ -1076,7 +1086,7 @@ static int de_thread(struct task_struct *tsk)
>  		 * return so that the signal is processed.
>  		 */
>  		spin_unlock_irq(lock);
> -		return -EAGAIN;
> +		goto err_free;
>  	}
>  
>  	sig->group_exit_task = tsk;
> @@ -1191,14 +1201,16 @@ static int de_thread(struct task_struct *tsk)
>  #endif
>  
>  	if (refcount_read(&oldsighand->count) != 1) {
> -		struct sighand_struct *newsighand;
>  		/*
>  		 * This ->sighand is shared with the CLONE_SIGHAND
>  		 * but not CLONE_THREAD task, switch to the new one.
>  		 */
> -		newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
> -		if (!newsighand)
> -			return -ENOMEM;
> +		if (!newsighand) {
> +			newsighand = kmem_cache_alloc(sighand_cachep,
> +						      GFP_KERNEL);
> +			if (!newsighand)
> +				return -ENOMEM;
> +		}
>  
>  		refcount_set(&newsighand->count, 1);
>  		memcpy(newsighand->action, oldsighand->action,
> @@ -1211,7 +1223,8 @@ static int de_thread(struct task_struct *tsk)
>  		write_unlock_irq(&tasklist_lock);
>  
>  		__cleanup_sighand(oldsighand);
> -	}
> +	} else if (newsighand)
> +		kmem_cache_free(sighand_cachep, newsighand);
>  
>  	BUG_ON(!thread_group_leader(tsk));
>  	return 0;
> @@ -1222,6 +1235,8 @@ static int de_thread(struct task_struct *tsk)
>  	sig->group_exit_task = NULL;
>  	sig->notify_count = 0;
>  	read_unlock(&tasklist_lock);
> +err_free:
> +	kmem_cache_free(sighand_cachep, newsighand);
>  	return -EAGAIN;
>  }
>  
> @@ -1262,7 +1277,7 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	 * Make sure we have a private signal table and that
>  	 * we are unassociated from the previous thread group.
>  	 */
> -	retval = de_thread(current);
> +	retval = de_thread();
>  	if (retval)
>  		goto out;
