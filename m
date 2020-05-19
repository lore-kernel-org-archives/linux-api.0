Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CC4C433E0
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 18:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F6A20758
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 18:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgESSqM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 19 May 2020 14:46:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60656 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgESSqM (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 19 May 2020 14:46:12 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb7Fi-0005kT-4o; Tue, 19 May 2020 12:46:10 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb7Fh-00056u-AM; Tue, 19 May 2020 12:46:09 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Biggers <ebiggers3@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200518055457.12302-1-keescook@chromium.org>
        <87a724t153.fsf@x220.int.ebiederm.org>
        <202005190918.D2BD83F7C@keescook>
        <87o8qjstyw.fsf@x220.int.ebiederm.org>
        <202005191052.0A6B1D5843@keescook>
Date:   Tue, 19 May 2020 13:42:28 -0500
In-Reply-To: <202005191052.0A6B1D5843@keescook> (Kees Cook's message of "Tue,
        19 May 2020 10:56:08 -0700")
Message-ID: <87sgfvrckr.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jb7Fh-00056u-AM;;;mid=<87sgfvrckr.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18MccEeDar1/0mLamXCyDMxW4fspzZPKe8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/4] Relocate execve() sanity checks
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Tue, May 19, 2020 at 12:41:27PM -0500, Eric W. Biederman wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> > and given the LSM hooks, I think the noexec check is too late as well.
>> > (This is especially true for the coming O_MAYEXEC series, which will
>> > absolutely need those tests earlier as well[1] -- the permission checking
>> > is then in the correct place: during open, not exec.) I think the only
>> > question is about leaving the redundant checks in fs/exec.c, which I
>> > think are a cheap way to retain a sense of robustness.
>> 
>> The trouble is when someone passes through changes one of the permission
>> checks for whatever reason (misses that they are duplicated in another
>> location) and things then fail in some very unexpected way.
>
> Do you think this series should drop the "late" checks in fs/exec.c?
> Honestly, the largest motivation for me to move the checks earlier as
> I've done is so that other things besides execve() can use FMODE_EXEC
> during open() and receive the same sanity-checking as execve() (i.e the
> O_MAYEXEC series -- the details are still under discussion but this
> cleanup will be needed regardless).

I think this series should drop the "late" checks in fs/exec.c  It feels
less error prone, and it feels like that would transform this into
something Linus would be eager to merge because series becomes a cleanup
that reduces line count.

I haven't been inside of open recently enough to remember if the
location you are putting the check fundamentally makes sense.  But the
O_MAYEXEC bits make a pretty strong case that something of the sort
needs to happen.

I took a quick look but I can not see clearly where path_noexec
and the regular file tests should go.

I do see that you have code duplication with faccessat which suggests
that you haven't put the checks in the right place.

I am wondering if we need something distinct to request the type of the
file being opened versus execute permissions.

All I know is being careful and putting the tests in a good logical
place makes the code more maintainable, whereas not being careful
results in all kinds of sharp corners that might be exploitable.
So I think it is worth digging in and figuring out where those checks
should live.  Especially so that code like faccessat does not need
to duplicate them.

Eric

