Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA0EC433DF
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 00:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4F22072C
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 00:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgESABE (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 18 May 2020 20:01:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53872 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgESABE (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 18 May 2020 20:01:04 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1japgp-0000OE-IQ; Mon, 18 May 2020 18:00:59 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1japgk-0000i6-TC; Mon, 18 May 2020 18:00:59 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
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
Date:   Mon, 18 May 2020 18:57:15 -0500
In-Reply-To: <20200518144627.sv5nesysvtgxwkp7@wittgenstein> (Christian
        Brauner's message of "Mon, 18 May 2020 16:46:27 +0200")
Message-ID: <87blmk3ig4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1japgk-0000i6-TC;;;mid=<87blmk3ig4.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19DeuOkpDOKLgt2uTPMIXubiPZdr97oZ0k=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/4] exec: Change uselib(2) IS_SREG() failure to EACCES
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Christian Brauner <christian.brauner@ubuntu.com> writes:

> On Mon, May 18, 2020 at 04:43:20PM +0200, Jann Horn wrote:
>> On Mon, May 18, 2020 at 3:03 PM Christian Brauner
>> <christian.brauner@ubuntu.com> wrote:
>> > Also - gulp (puts on flame proof suit) - may I suggest we check if there
>> > are any distros out there that still set CONFIG_USELIB=y
>> 
>> Debian seems to have it enabled on x86...
>> 
>> https://salsa.debian.org/kernel-team/linux/-/blob/master/debian/config/kernelarch-x86/config#L1896
>> 
>> A random Ubuntu 19.10 VM I have here has it enabled, too.
>
> I wonder if there's any program - apart from _ancient_ glibc out there
> that actually use it...
> I looked at uselib in codsearch but the results were quite unspecific
> but I didn't look too close.

So the thing to do is to have a polite word with people who build Ubuntu
and Debian kernels and get them to disable the kernel .config.

A quick look suggets it is already disabled in RHEL8.  It cannot be
disabled in RHEL7.

Then in a few years we can come back and discuss removing the uselib
system call, base on no distributions having it enabled.

If it was only libc4 and libc5 that used the uselib system call then it
can probably be removed after enough time.

We can probably reorganize the code before the point it is clearly safe
to drop support for USELIB to keep it off to the side so USELIB does not
have any ongoing mainteance costs.

For this patchset I think we need to assume uselib will need to be
maintained for a bit longer.

Eric

