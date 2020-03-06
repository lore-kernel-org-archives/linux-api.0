Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB049C10DCE
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 22:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77FAA206D7
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 22:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFWBM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 17:01:12 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41264 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCFWBL (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 6 Mar 2020 17:01:11 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jAL1o-0007O8-UN; Fri, 06 Mar 2020 15:01:09 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jAL1o-0005iy-3n; Fri, 06 Mar 2020 15:01:08 -0700
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
        <87k13yawpp.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 06 Mar 2020 15:58:52 -0600
In-Reply-To: <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Fri, 6 Mar 2020 19:16:08 +0000")
Message-ID: <87sgil87s3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jAL1o-0005iy-3n;;;mid=<87sgil87s3.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/nQIAja4Tte/KbD9xIUFWHY/xDf5wuGBw=
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

> On 3/6/20 6:17 AM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
>>>>
>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>> over the userspace accesses as the arguments from userspace are read.
>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>> threads are killed.  The cred_guard_mutex is held over
>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>
>
> I am all for this patch, and the direction it is heading, Eric.
>
> I just wanted to add a note that I think it is
> possible that exec_mm_release can also invoke put_user(0, tsk->clear_child_tid),
> under the new exec_update_mutex, since vm_access increments the
> mm->mm_users, under the cred_update_mutex, but releases the mutex,
> and the caller can hold the reference for a while and then exec_mmap is not
> releasing the last reference.

Good catch.  I really appreciate your close look at the details.

I am wondering if process_vm_readv and process_vm_writev could be
safely changed to use mmgrab and mmdrop, instead of mmget and mmput.

That would resolve the potential issue you have pointed out.  I just
haven't figured out if it is safe.  The mm code has been seriously
refactored since I knew how it all worked.

Eric
