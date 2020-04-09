Return-Path: <SRS0=1jdd=5Z=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F979C2BA2B
	for <linux-api@archiver.kernel.org>; Thu,  9 Apr 2020 13:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB93E20771
	for <linux-api@archiver.kernel.org>; Thu,  9 Apr 2020 13:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDINDh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:03:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59848 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgDINDg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 9 Apr 2020 09:03:36 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jMWqF-0001hb-1e; Thu, 09 Apr 2020 07:03:35 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jMWpL-0007xO-Oy; Thu, 09 Apr 2020 07:03:34 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Security Module <linux-security-module@vger.kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Djalal Harouni <tixxdz@gmail.com>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        David Howells <dhowells@redhat.com>
References: <20200409123752.1070597-1-gladkov.alexey@gmail.com>
Date:   Thu, 09 Apr 2020 07:59:47 -0500
In-Reply-To: <20200409123752.1070597-1-gladkov.alexey@gmail.com> (Alexey
        Gladkov's message of "Thu, 9 Apr 2020 14:37:44 +0200")
Message-ID: <87y2r4vmpo.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jMWpL-0007xO-Oy;;;mid=<87y2r4vmpo.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/WJ31Nql+9t5EG46GA+7qbhhHjHwL+opo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH RESEND v11 0/8] proc: modernize proc to support multiple private instances
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> Preface:
> --------
> This is patchset v11 to modernize procfs and make it able to support multiple
> private instances per the same pid namespace.
>
> This patchset can be applied on top of:
>
> git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
> 4b871ce26ab2



Why the resend?

Nothing happens until the merge window closes with the release of -rc1
(almost certainly on this coming Sunday).  I goofed and did not act on
this faster, and so it is my fault this did not make it into linux-next
before the merge window.  But I am not going to rush this forward.



You also ignored my review and have not even descibed why it is safe
to change the type of a filesystem parameter.

-	fsparam_u32("hidepid",	Opt_hidepid),
+	fsparam_string("hidepid",	Opt_hidepid),


Especially in light of people using fsconfig(fd, FSCONFIG_SET_...);

All I need is someone to point out that fsparam_u32 does not use
FSCONFIG_SET_BINARY, but FSCONFIG_SET_STRING.



My apologies for being grumpy but this feels like you are asking me to
go faster when it is totally inappropriate to do so, while busily
ignoring my feedback.

I think this should happen.  But I can't do anything until after -rc1.

Eric
