Return-Path: <SRS0=YmEt=42=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B541DC10F25
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 19:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904952465A
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 19:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCIThw (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:37:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57330 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCIThv (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Mar 2020 15:37:51 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBODe-00015d-OU; Mon, 09 Mar 2020 13:37:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBODd-0004Wy-QQ; Mon, 09 Mar 2020 13:37:42 -0600
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
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
Date:   Mon, 09 Mar 2020 14:35:24 -0500
In-Reply-To: <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Mon, 9 Mar 2020 19:24:58 +0000")
Message-ID: <87fteh1fur.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBODd-0004Wy-QQ;;;mid=<87fteh1fur.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+DDWQI5cjwElTn1n4Tvz89F0vLYf/zGAA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/9/20 8:02 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> On 3/9/20 7:36 PM, Eric W. Biederman wrote:
>>>>
>>>>
>>>> Does that sound better?
>>>>
>>>
>>> almost done.
>> 
>> I think this text is finally clean.
>> 
>>     exec: Add exec_update_mutex to replace cred_guard_mutex
>>     
>>     The cred_guard_mutex is problematic as it is held over possibly
>>     indefinite waits for userspace.  The possilbe indefinite waits for
>>     userspace that I have identified are: The cred_guard_mutex is held in
>>     PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
>>     held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
>>     cred_guard_mutex is held over "get_user(futex_offset, ...")  in
>>     exit_robust_list.  The cred_guard_mutex held over copy_strings.
>>     
>>     The functions get_user and put_user can trigger a page fault which can
>>     potentially wait indefinitely in the case of userfaultfd or if
>>     userspace implements part of the page fault path.
>>     
>>     In any of those cases the userspace process that the kernel is waiting
>>     for might make a different system call that winds up taking the
>>     cred_guard_mutex and result in deadlock.
>>     
>>     Holding a mutex over any of those possibly indefinite waits for
>>     userspace does not appear necessary.  Add exec_update_mutex that will
>>     just cover updating the process during exec where the permissions and
>>     the objects pointed to by the task struct may be out of sync.
>>     
>>     The plan is to switch the users of cred_guard_mutex to
>>     exec_update_mutex one by one.  This lets us move forward while still
>>     being careful and not introducing any regressions.
>>     
>>     Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>>     Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>     Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>>     Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>>     Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>>     Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>>     Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>
> I checked the urls they all work.
> Just one last question, are these git references?
> I can't find them in my linux git tree (cloned from linus' git)?
>
> Sorry for being pedantically.

You have to track down tglx's historicaly git tree from when everything
was in bitkeeper.

But yes they are git references and yes they work.  Just that part
of the history is not in linux.git.

>>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> 
>> Bernd do you want to give me your Reviewed-by for this part of the
>> series?
>> 
>
> Sure also the other parts of course.
>
> Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>
>> After that do you think you can write the obvious patch for mm_access?
>> 
>
> Yes, I can do that.
> I also have some typos in comments, will make them extra patches as well.
>
> I wonder if the test case is okay to include the ptrace_attach altough
> that is not yet passing?

It is an existing kernel but that it doesn't pass.

My sense is that if you include it as a separate patch if it is a
problem for someone we can identify it easily via bisect and we do
whatever is appropriate.

Eric
