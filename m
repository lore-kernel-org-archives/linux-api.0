Return-Path: <SRS0=yzTb=43=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E632C10F27
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E75222C3
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJVFK (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Mar 2020 17:05:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52914 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVFJ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Mar 2020 17:05:09 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm3o-0007Ja-5Z; Tue, 10 Mar 2020 15:05:08 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm3n-0008Ca-EI; Tue, 10 Mar 2020 15:05:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <202003101352.28BE3BEB4@keescook>
Date:   Tue, 10 Mar 2020 16:02:48 -0500
In-Reply-To: <202003101352.28BE3BEB4@keescook> (Kees Cook's message of "Tue,
        10 Mar 2020 13:55:54 -0700")
Message-ID: <87a74nsz2f.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBm3n-0008Ca-EI;;;mid=<87a74nsz2f.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18PTvqUqvFHzaS8aRXcjAAB8aMmbAjVv+4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Mon, Mar 09, 2020 at 02:02:37PM -0500, Eric W. Biederman wrote:
>>     exec: Add exec_update_mutex to replace cred_guard_mutex
>>     
>>     The cred_guard_mutex is problematic as it is held over possibly
>>     indefinite waits for userspace.  The possilbe indefinite waits for
>>     userspace that I have identified are: The cred_guard_mutex is held in
>>     PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
>>     held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
>>     cred_guard_mutex is held over "get_user(futex_offset, ...")  in
>>     exit_robust_list.  The cred_guard_mutex held over copy_strings.
>
> I suspect you're not trying to make a comprehensive list here, but do
> you want to mention seccomp too (since it's yet another weird case).

I was calling out all of the places I have found so far where
cred_guard_mutex is held over waiting for userspace to maybe do
something.  Those places are what cause our deadlocks.

>> [...]
>>     Holding a mutex over any of those possibly indefinite waits for
>>     userspace does not appear necessary.  Add exec_update_mutex that will
>>     just cover updating the process during exec where the permissions and
>>     the objects pointed to by the task struct may be out of sync.
>
> Should the specific resources be pointed out here? creds, mm, ... ?
>
> But otherwise, yup, looks sane:

Probably not.  The design is if exec changes it we will hold the
cred_guard_mutex over it, so things are semi-atomic.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Eric
