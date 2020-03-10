Return-Path: <SRS0=yzTb=43=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A69C18E7A
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 19:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8C2227BF
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 19:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgCJT3z (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Mar 2020 15:29:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54394 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCJT3z (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Mar 2020 15:29:55 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkZc-0005OS-FU; Tue, 10 Mar 2020 13:29:52 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBkZZ-0002Nd-K3; Tue, 10 Mar 2020 13:29:52 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jann Horn <jannh@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
        <20200309195909.h2lv5uawce5wgryx@wittgenstein>
        <877dztz415.fsf@x220.int.ebiederm.org>
        <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
        <87k13txnig.fsf@x220.int.ebiederm.org>
        <20200310085540.pztaty2mj62xt2nm@wittgenstein>
        <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
Date:   Tue, 10 Mar 2020 14:27:30 -0500
In-Reply-To: <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
        (Jann Horn's message of "Tue, 10 Mar 2020 20:16:47 +0100")
Message-ID: <87k13sui1p.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBkZZ-0002Nd-K3;;;mid=<87k13sui1p.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Z1jtSmtmPbttkGJihPVv1nviFC/pSEI0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> During exec some file descriptors are closed and the files struct is
>> unshared.  But all of that can happen at other times and it has the
>> same protections during exec as at ordinary times.  So stop taking the
>> cred_guard_mutex as it is useless.
>>
>> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
>> prone, as it is held in serveral while waiting possibly indefinitely
>> for userspace to do something.
>
> Please don't. Just use the new exec_update_mutex like everywhere else.
>
>> Cc: Sargun Dhillon <sargun@sargun.me>
>> Cc: Christian Brauner <christian.brauner@ubuntu.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  kernel/pid.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> Christian if you don't have any objections I will take this one through
>> my tree.
>>
>> I tried to figure out why this code path takes the cred_guard_mutex and
>> the archive on lore.kernel.org was not helpful in finding that part of
>> the conversation.
>
> That was my suggestion.
>
>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index 60820e72634c..53646d5616d2 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -577,17 +577,11 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
>>         struct file *file;
>>         int ret;
>>
>> -       ret = mutex_lock_killable(&task->signal->cred_guard_mutex);
>> -       if (ret)
>> -               return ERR_PTR(ret);
>> -
>>         if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
>>                 file = fget_task(task, fd);
>>         else
>>                 file = ERR_PTR(-EPERM);
>>
>> -       mutex_unlock(&task->signal->cred_guard_mutex);
>> -
>>         return file ?: ERR_PTR(-EBADF);
>>  }
>
> If you make this change, then if this races with execution of a setuid
> program that afterwards e.g. opens a unix domain socket, an attacker
> will be able to steal that socket and inject messages into
> communication with things like DBus. procfs currently has the same
> race, and that still needs to be fixed, but at least procfs doesn't
> let you open things like sockets because they don't have a working
> ->open handler, and it enforces the normal permission check for
> opening files.

It isn't only exec that can change credentials.  Do we need a lock for
changing credentials?

Wouldn't it be sufficient to simply test ptrace_may_access after
we get a copy of the file?

If we need a lock around credential change let's design and build that.
Having a mismatch between what a lock is designed to do, and what
people use it for can only result in other bugs as people get confused.

Eric
