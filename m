Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3687FC433DF
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 15:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1893C207FB
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 15:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgESPKR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 19 May 2020 11:10:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44388 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbgESPKR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 19 May 2020 11:10:17 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb3sk-0005GH-Fu; Tue, 19 May 2020 09:10:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jb3si-0001s6-RW; Tue, 19 May 2020 09:10:13 -0600
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
Date:   Tue, 19 May 2020 10:06:32 -0500
In-Reply-To: <20200518055457.12302-1-keescook@chromium.org> (Kees Cook's
        message of "Sun, 17 May 2020 22:54:53 -0700")
Message-ID: <87a724t153.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jb3si-0001s6-RW;;;mid=<87a724t153.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+A3FfcWjqtqqukiK5gO20MFpn1V2jd41Y=
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

> Hi,
>
> While looking at the code paths for the proposed O_MAYEXEC flag, I saw
> some things that looked like they should be fixed up.
>
>   exec: Change uselib(2) IS_SREG() failure to EACCES
> 	This just regularizes the return code on uselib(2).
>
>   exec: Relocate S_ISREG() check
> 	This moves the S_ISREG() check even earlier than it was already.
>
>   exec: Relocate path_noexec() check
> 	This adds the path_noexec() check to the same place as the
> 	S_ISREG() check.
>
>   fs: Include FMODE_EXEC when converting flags to f_mode
> 	This seemed like an oversight, but I suspect there is some
> 	reason I couldn't find for why FMODE_EXEC doesn't get set in
> 	f_mode and just stays in f_flags.

So I took a look at this series.

I think the belt and suspenders approach of adding code in open and then
keeping it in exec and uselib is probably wrong.  My sense of the
situation is a belt and suspenders approach is more likely to be
confusing and result in people making mistakes when maintaining the code
than to actually be helpful.

Eric
