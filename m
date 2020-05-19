Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D00FC433E0
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 12:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C82207C4
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 12:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgESMA3 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 19 May 2020 08:00:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55794 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgESMA2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 19 May 2020 08:00:28 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb0v1-00053s-PB; Tue, 19 May 2020 06:00:23 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb0uu-0004Bg-MP; Tue, 19 May 2020 06:00:23 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Biggers <ebiggers3@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20200518055457.12302-1-keescook@chromium.org>
        <20200518055457.12302-2-keescook@chromium.org>
        <20200518130251.zih2s32q2rxhxg6f@wittgenstein>
        <CAG48ez1FspvvypJSO6badG7Vb84KtudqjRk1D7VyHRm06AiEbQ@mail.gmail.com>
        <20200518144627.sv5nesysvtgxwkp7@wittgenstein>
        <87blmk3ig4.fsf@x220.int.ebiederm.org> <87mu64uxq1.fsf@igel.home>
Date:   Tue, 19 May 2020 06:56:36 -0500
In-Reply-To: <87mu64uxq1.fsf@igel.home> (Andreas Schwab's message of "Tue, 19
        May 2020 10:37:26 +0200")
Message-ID: <87sgfwuoi3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jb0uu-0004Bg-MP;;;mid=<87sgfwuoi3.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18KHCvzrkAL+KkT291e5MaUNnZX1ztiKf4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/4] exec: Change uselib(2) IS_SREG() failure to EACCES
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Andreas Schwab <schwab@linux-m68k.org> writes:

> On Mai 18 2020, Eric W. Biederman wrote:
>
>> If it was only libc4 and libc5 that used the uselib system call then it
>> can probably be removed after enough time.
>
> Only libc4 used it, libc5 was already ELF.

binfmt_elf.c supports uselib.  In a very a.out ish way.  Do you know if
that support was ever used?

If we are truly talking a.out only we should be able to make uselib
conditional on a.out support in the kernel which is strongly mostly
disabled at this point.

I am wondering if there are source trees for libc4 or libc5 around
anywhere that we can look at to see how usage of uselib evolved.

Eric
