Return-Path: <SRS0=yzTb=43=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B8CC10F27
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 19:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E56120637
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 19:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgCJTDo (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Mar 2020 15:03:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60596 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgCJTDo (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Mar 2020 15:03:44 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkAI-0002Hx-MC; Tue, 10 Mar 2020 13:03:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkA9-0004jE-TO; Tue, 10 Mar 2020 13:03:42 -0600
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
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <877dzt1fnf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfcxlwy.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:01:15 -0500
In-Reply-To: <AM6PR03MB517057A2269C3A4FB287B76EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 18:45:11 +0100")
Message-ID: <87k13svxtw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBkA9-0004jE-TO;;;mid=<87k13svxtw.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184oAtGUl9ErG2CEbQO/LXGywzplo5o8Mo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/4] kernel/kcmp.c: Use new infrastructure to fix deadlocks in execve
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This changes kcmp_epoll_target to use the new exec_update_mutex
> instead of cred_guard_mutex.
>
> This should be safe, as the credentials are only used for reading,
> and furthermore ->mm and ->sighand are updated on execve,
> but only under the new exec_update_mutex.
>

Can you add a comment that the exec_update_mutex is not needed for
KCMP_FILE?  As both sets of credentials during exec are valid
for accessing the files so exec_update_mutex does not matter.

I don't think exec_update_mutex is needed for KCMP_SYSVSEM
or KCMP_EPOLL_TFD either.  As I don't think exec changes either
one of those.

Eric


> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  kernel/kcmp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/kcmp.c b/kernel/kcmp.c
> index a0e3d7a..b3ff928 100644
> --- a/kernel/kcmp.c
> +++ b/kernel/kcmp.c
> @@ -173,8 +173,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>  	/*
>  	 * One should have enough rights to inspect task details.
>  	 */
> -	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
> -			&task2->signal->cred_guard_mutex);
> +	ret = kcmp_lock(&task1->signal->exec_update_mutex,
> +			&task2->signal->exec_update_mutex);
>  	if (ret)
>  		goto err;
>  	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
> @@ -229,8 +229,8 @@ static int kcmp_epoll_target(struct task_struct *task1,
>  	}
>  
>  err_unlock:
> -	kcmp_unlock(&task1->signal->cred_guard_mutex,
> -		    &task2->signal->cred_guard_mutex);
> +	kcmp_unlock(&task1->signal->exec_update_mutex,
> +		    &task2->signal->exec_update_mutex);
>  err:
>  	put_task_struct(task1);
>  	put_task_struct(task2);
