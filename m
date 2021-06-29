Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61A9C11F69
	for <linux-api@archiver.kernel.org>; Tue, 29 Jun 2021 22:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFAFD61D00
	for <linux-api@archiver.kernel.org>; Tue, 29 Jun 2021 22:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhF2W5i (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 29 Jun 2021 18:57:38 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35474 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhF2W5g (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 29 Jun 2021 18:57:36 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:47960)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lyMdH-000LwU-8A; Tue, 29 Jun 2021 16:55:07 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:41336 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lyMdG-0039ez-C7; Tue, 29 Jun 2021 16:55:06 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     <linux-api@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        <linux-man@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Tue, 29 Jun 2021 17:54:24 -0500
Message-ID: <87r1gkp9i7.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lyMdG-0039ez-C7;;;mid=<87r1gkp9i7.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+C/+RI8ccgi3UsWtxmzQboBPz6VqLQeJo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Semantics of SECCOMP_MODE_STRICT?
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


I am the process of cleaning up the process exit path in the kernel, and
as part of that I am looking at the callers of do_exit.  A very
interesting one is __seccure_computing_strict.

Looking at the code is very clear that if a system call is attempted
that is not in the table the thread attempting to execute that system
call is terminated.

Reading the man page for seccomp it says that the process is delivered
SIGKILL.

The practical difference is what happens for multi-threaded
applications.

What are the desired semantics for a multi-threaded application if one
thread attempts to use a unsupported system call?  Should the thread be
terminated or the entire application?

Do we need to fix the kernel, or do we need to fix the manpages?

Thank you,
Eric



