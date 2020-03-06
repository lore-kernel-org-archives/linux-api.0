Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9764AC3F2CD
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 05:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FDD620728
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 05:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCFFIf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 00:08:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47484 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgCFFIf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 6 Mar 2020 00:08:35 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5Dn-0007A2-BN; Thu, 05 Mar 2020 22:08:27 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5Dm-0003Pg-FD; Thu, 05 Mar 2020 22:08:27 -0700
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
        <875zfmloir.fsf@x220.int.ebiederm.org>
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
        <AM6PR03MB5170C0E85446CAE39F642F5BE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 05 Mar 2020 23:06:12 -0600
In-Reply-To: <AM6PR03MB5170C0E85446CAE39F642F5BE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Thu, 5 Mar 2020 22:31:24 +0000")
Message-ID: <87zhcuax8b.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jA5Dm-0003Pg-FD;;;mid=<87zhcuax8b.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+myVahi27pkdFpz/bqvDvh1TPI3iGlNUI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/2] Infrastructure to allow fixing exec deadlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/5/20 10:14 PM, Eric W. Biederman wrote:
>> 
>> Bernd, everyone
>> 
>> This is how I think the infrastructure change should look that makes way
>> for fixing this issue.
>> 
>> - Correct the point of no return.
>> - Add a new mutex to replace cred_guard_mutex
>> 
>> Then I think it is just going through the existing
>> users of cred_guard_mutex and fixing them to use the new one.
>> 
>> There really aren't that many users of cred_guard_mutex so we should be
>> able to get through the easy ones fairly quickly.  And anything that
>> isn't easy we can wait until we have a good fix.
>> 
>> The users of cred_guard_mutex that I saw were:
>>     fs/proc/base.c:
>>        proc_pid_attr_write
>>        do_io_accounting
>>        proc_pid_stack
>>        proc_pid_syscall
>>        proc_pid_personality
>>     
>>     perf_event_open
>>     mm_access
>>     kcmp
>>     pidfd_fget
>>     seccomp_set_mode_filter
>> 
>> Bernd does this make sense to you?  
>> 
>> I think we can fix the seccomp/no_new_privs issue with some careful
>> refactoring.  We can probably do the same for ptrace but that appears
>> to need a little lsm bug fixing.
>> 
>
> Yes, for most functions the proposed "exec_update_mutex" is fine,
> but we will need a longer-time block for ptrace_attach, seccomp_set_mode_filter
> and proc_pid_attr_write need to be blocked for the whole exec duration so
> they need a second "mutex", with deadlock-detection as in my previous patch,
> if I see that right.

So far I am leaving "cred_guard_mutex" as that second "mutex".  My sense
is that when all we have left are the hard cases we can take those
cases out in detail, examine them and see what really can be done.

> Unfortunately only one of the two test cases can be fixed without the
> second mutex, of course the mm_access is what cause the practical problem.

Fixing the practical problems are foremost on my agenda.
That and clearing away enough of the noise that we can really focus on
the hard problems when we begin to address them.

That way I am hoping we can really solve some of these issues and make
them go away.

> Currently for the unlimited user space delay, I have only the case of
> a ptraced sibling thread on my radar, de_thread waits for the parent
> to call wait in this case, that can literally take forever.
> But I know that also PTRACE_CONT may be needed after a PTRACE_EVENT_EXIT.
>
> Can you explain what else in the user space can go wrong to make an
> unlimited delay in the execve?

Triggering a page fault.  Depending on the backing store or possibly
with the use of userfaultfd that page fault can be delayed indefinitely
and pretty much be as bad as the ptrace case.

Eric
