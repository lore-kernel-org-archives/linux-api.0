Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1055C433F5
	for <linux-api@archiver.kernel.org>; Fri, 19 Nov 2021 17:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A416D61A62
	for <linux-api@archiver.kernel.org>; Fri, 19 Nov 2021 17:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhKSRl0 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:41:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56124 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhKSRlX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 19 Nov 2021 12:41:23 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:56980)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mo7q7-00FTBc-TF; Fri, 19 Nov 2021 10:38:19 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:43164 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mo7q5-006GMV-W0; Fri, 19 Nov 2021 10:38:19 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kyle Huey <me@kylehuey.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Robert O'Callahan <rocallahan@gmail.com>
In-Reply-To: <20211119160348.22409-1-khuey@kylehuey.com> (Kyle Huey's message
        of "Fri, 19 Nov 2021 08:03:48 -0800")
References: <87y27mvnke.fsf@disp2133>
        <20211119160348.22409-1-khuey@kylehuey.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 19 Nov 2021 11:38:11 -0600
Message-ID: <87ilwonj0c.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mo7q5-006GMV-W0;;;mid=<87ilwonj0c.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/a0Zx+gWJ9DOTPKk9YuaDFOXKqR13iyuo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 6/6] coredump: Limit coredumps to a single thread group
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Kyle Huey <me@kylehuey.com> writes:

>> Solve this by making a userspace visible change to only kill a single
>> process/thread group. [...] With LinuxThreads long gone I don't
>> expect anyone to have a notice this behavior change in practice.
>
> FWIW rr's test suite does have an explicit test that we correctly record and 
> replay the old behavior. We don't actually care what that behavior is though,
> so we will update our tests.

Thanks.  I am keep being afraid someone will have a program where it
actually matters.  But so far so good.

Eric

