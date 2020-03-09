Return-Path: <SRS0=YmEt=42=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C243C10F25
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 20:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 380FC24649
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 20:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCIUvR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Mar 2020 16:51:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55926 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUvR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Mar 2020 16:51:17 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBPMp-00009J-3W; Mon, 09 Mar 2020 14:51:15 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBPMn-00036L-Ir; Mon, 09 Mar 2020 14:51:14 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
References: <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
        <20200309195909.h2lv5uawce5wgryx@wittgenstein>
        <877dztz415.fsf@x220.int.ebiederm.org>
        <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
Date:   Mon, 09 Mar 2020 15:48:55 -0500
In-Reply-To: <20200309201729.yk5sd26v4bz4gtou@wittgenstein> (Christian
        Brauner's message of "Mon, 9 Mar 2020 21:17:29 +0100")
Message-ID: <87k13txnig.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBPMn-00036L-Ir;;;mid=<87k13txnig.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++cg/1/LEU7AeNulDU9zu2Fhhs7DPCMnA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of de_thread
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Christian Brauner <christian.brauner@ubuntu.com> writes:

> On Mon, Mar 09, 2020 at 03:06:46PM -0500, Eric W. Biederman wrote:
>> Christian Brauner <christian.brauner@ubuntu.com> writes:
>> 
>> > On Sun, Mar 08, 2020 at 04:36:55PM -0500, Eric W. Biederman wrote:
>> >> 
>> >> These functions have very little to do with de_thread move them out
>> >> of de_thread an into flush_old_exec proper so it can be more clearly
>> >> seen what flush_old_exec is doing.
>> >> 
>> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> ---
>> >>  fs/exec.c | 10 +++++-----
>> >>  1 file changed, 5 insertions(+), 5 deletions(-)
>> >> 
>> >> diff --git a/fs/exec.c b/fs/exec.c
>> >> index ff74b9a74d34..215d86f77b63 100644
>> >> --- a/fs/exec.c
>> >> +++ b/fs/exec.c
>> >> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
>> >
>> > While you're cleaning up de_thread() wouldn't it be good to also take
>> > the opportunity and remove the task argument from de_thread(). It's only
>> > ever used with current. Could be done in one of your patches or as a
>> > separate patch.
>> 
>> How does that affect the code generation?
>
> The same way renaming "tsk" to "me" does.
>
>> 
>> My sense is that computing current once in flush_old_exec is much
>> better than computing it in each function flush_old_exec calls.
>> I remember that computing current used to be not expensive but
>> noticable.
>> 
>> For clarity I can see renaming tsk to me.  So that it is clear we are
>> talking about the current process, and not some arbitrary process.
>
> For clarity since de_thread() uses "tsk" giving the impression that any
> task can be dethreaded while it's only ever used with current. It's just
> a suggestion since you're doing the rename tsk->me anyway it would fit
> with the series. You do whatever you want though.
> (I just remember that the same request was made once to changes I did:
> Don't pass current as arg when it's the only task passed.)

That's fair.

And I completely agree that we should at least rename tsk to me.
Just for clarity.

My apologies if I am a little short.  My little son has been an extra
handful lately.

Eric

