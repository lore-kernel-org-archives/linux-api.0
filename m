Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAD7C433EF
	for <linux-api@archiver.kernel.org>; Sat,  8 Jan 2022 18:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiAHSOr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-api@archiver.kernel.org>);
        Sat, 8 Jan 2022 13:14:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52814 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiAHSOr (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 8 Jan 2022 13:14:47 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:38462)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GEo-0019tX-0e; Sat, 08 Jan 2022 11:14:46 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:33932 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GEl-000w1l-BS; Sat, 08 Jan 2022 11:14:44 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
        <20211213225350.27481-1-ebiederm@xmission.com>
        <9363765f-9883-75ee-70f1-a1a8e9841812@gmail.com>
        <87pmp67y4r.fsf@email.froward.int.ebiederm.org>
        <5bbb54c4-7504-cd28-5dde-4e5965496625@gmail.com>
Date:   Sat, 08 Jan 2022 12:13:59 -0600
In-Reply-To: <5bbb54c4-7504-cd28-5dde-4e5965496625@gmail.com> (Dmitry
        Osipenko's message of "Thu, 6 Jan 2022 00:39:10 +0300")
Message-ID: <87bl0m14ew.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1n6GEl-000w1l-BS;;;mid=<87bl0m14ew.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18S0I7LBCK7w4uyZFfzYkiEuP7fj3S3eVM=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/8] signal: Make SIGKILL during coredumps an explicit
 special case
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> writes:

> 05.01.2022 22:58, Eric W. Biederman пишет:
>> 
>> I have not yet been able to figure out how to run gst-pluggin-scanner in
>> a way that triggers this yet.  In truth I can't figure out how to
>> run gst-pluggin-scanner in a useful way.
>> 
>> I am going to set up some unit tests and see if I can reproduce your
>> hang another way, but if you could give me some more information on what
>> you are doing to trigger this I would appreciate it.
>
> Thanks, Eric. The distro is Arch Linux, but it's a development
> environment where I'm running latest GStreamer from git master. I'll try
> to figure out the reproduction steps and get back to you.

Thank you.

Until I can figure out why this is causing problems I have dropped the
following two patches from my queue:
 signal: Make SIGKILL during coredumps an explicit special case
 signal: Drop signals received after a fatal signal has been processed

I have replaced them with the following two patches that just do what
is needed for the rest of the code in the series:
 signal: Have prepare_signal detect coredumps using
 signal: Make coredump handling explicit in complete_signal

Perversely my failure to change the SIGKILL handling when coredumps are
happening proves to me that I need to change the SIGKILL handling when
coredumps are happening to make the code more maintainable.

Eric

