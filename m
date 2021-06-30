Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E609C11F68
	for <linux-api@archiver.kernel.org>; Wed, 30 Jun 2021 20:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BEE5613B7
	for <linux-api@archiver.kernel.org>; Wed, 30 Jun 2021 20:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhF3UOk (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 30 Jun 2021 16:14:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49604 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhF3UOj (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 30 Jun 2021 16:14:39 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lygZ7-00BxLo-8J; Wed, 30 Jun 2021 14:12:09 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:43832 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lygZ5-007Q6s-LZ; Wed, 30 Jun 2021 14:12:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <87r1gkp9i7.fsf@disp2133> <202106292156.9458CF22@keescook>
Date:   Wed, 30 Jun 2021 15:11:23 -0500
In-Reply-To: <202106292156.9458CF22@keescook> (Kees Cook's message of "Tue, 29
        Jun 2021 22:23:06 -0700")
Message-ID: <87k0mbp0yc.fsf_-_@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lygZ5-007Q6s-LZ;;;mid=<87k0mbp0yc.fsf_-_@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18aOKYeX4bVt7U5rQ+ngAg94VyPJEFtMio=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] seccomp.2:  Clarify that bad system calls kill the thread
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 man2/seccomp.2 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/man2/seccomp.2 b/man2/seccomp.2
index a3421871f0f4..bde54c3e3e99 100644
--- a/man2/seccomp.2
+++ b/man2/seccomp.2
@@ -69,9 +69,10 @@ The only system calls that the calling thread is permitted to make are
 .BR exit_group (2)),
 and
 .BR sigreturn (2).
-Other system calls result in the delivery of a
+Other system calls result in the termination of the calling thread,
+or termination of the entire process with the
 .BR SIGKILL
-signal.
+signal when there is only one thread.
 Strict secure computing mode is useful for number-crunching
 applications that may need to execute untrusted byte code, perhaps
 obtained by reading from a pipe or socket.
-- 
2.29.2
