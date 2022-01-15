Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D64CC433FE
	for <linux-api@archiver.kernel.org>; Sat, 15 Jan 2022 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiAOAM7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Jan 2022 19:12:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40920 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiAOAM7 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Jan 2022 19:12:59 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:37430)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n8Wgj-00DNJC-P2; Fri, 14 Jan 2022 17:12:57 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:35496 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n8Wgh-007wWd-Oh; Fri, 14 Jan 2022 17:12:57 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<linux-arch@vger.kernel.org>" <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
        <20211213225350.27481-1-ebiederm@xmission.com>
        <CAHk-=wiS2P+p9VJXV_fWd5ntashbA0QVzJx15rTnWOCAAVJU_Q@mail.gmail.com>
        <87sfu3b7wm.fsf@email.froward.int.ebiederm.org>
        <YdniQob7w5hTwB1v@osiris>
        <87ilurwjju.fsf@email.froward.int.ebiederm.org>
        <87o84juwhg.fsf@email.froward.int.ebiederm.org>
        <57dfc87c7dd5a2f9f9841bba1185336016595ef7.camel@trillion01.com>
        <87lezmrxlq.fsf@email.froward.int.ebiederm.org>
        <87mtk2qf5s.fsf@email.froward.int.ebiederm.org>
        <CAHk-=wjZ=aFzFb0BkxVEbN3o6a53R8Gq4hHnEZVCmpDKs3_FCw@mail.gmail.com>
Date:   Fri, 14 Jan 2022 18:12:48 -0600
In-Reply-To: <CAHk-=wjZ=aFzFb0BkxVEbN3o6a53R8Gq4hHnEZVCmpDKs3_FCw@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 11 Jan 2022 11:19:25 -0800")
Message-ID: <87h7a5kgan.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1n8Wgh-007wWd-Oh;;;mid=<87h7a5kgan.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/4C7QJo/l/wcVnnm0cbpeQIee6fgSf0LM=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/8] signal: Make SIGKILL during coredumps an explicit
 special case
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Jan 11, 2022 at 10:51 AM Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> +       while ((n == -ERESTARTSYS) && test_thread_flag(TIF_NOTIFY_SIGNAL)) {
>> +               tracehook_notify_signal();
>> +               n = __kernel_write(file, addr, nr, &pos);
>> +       }
>
> This reads horribly wrongly to me.
>
> That "tracehook_notify_signal()" thing *has* to be renamed before we
> have anything like this that otherwise looks like "this will just loop
> forever".
>
> I'm pretty sure we've discussed that "tracehook" thing before - the
> whole header file is misnamed, and most of the functions in theer are
> too.
>
> As an ugly alternative, open-code it, so that it's clear that "yup,
> that clears the TIF_NOTIFY_SIGNAL flag".

A cleaner alternative looks like to modify the pipe code to use
wake_up_XXX instead of wake_up_interruptible_XXX and then have code
that does pipe_write_killable instead of pipe_write_interruptible.

There is also a question of how all of this should interact with the
freezer, as I think changing from interruptible to killable means that
the coredumps became unfreezable.

I am busily simmering this on my back burner and I hope I can come up
with something sensible.

Eric
