Return-Path: <SRS0=/LmR=6O=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7025C83001
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 07:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835052186A
	for <linux-api@archiver.kernel.org>; Thu, 30 Apr 2020 07:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cs.msu.ru header.i=@cs.msu.ru header.b="tYImIuIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgD3HRQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:17:16 -0400
Received: from mail.cs.msu.ru ([188.44.42.39]:50590 "EHLO mail.cs.msu.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgD3HRP (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 30 Apr 2020 03:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cs.msu.ru;
         s=dkim; h=Subject:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yx55Thu7Gf0r0u/XFEjGbPEa2L3yF6iBFpJzZun4g9A=; b=tYImIuIyPJagcc6FPVaOYZLQPi
        9kAFEOVgxEnOigCDvy0mExWX2v805sfZGc3kJK6SoxL/pCzdzOCAWkvnDv3KIPDHfo/lhJ6FhxaET
        DrHyMSPlI4YTxZ8axbx0GIo+OfL6Gvh73ZhFBXVyQe3VQTLG8omAv8GZlQJuu6kV5fHYgGcNUoYGT
        4/ZsebLY3y2pzbgYa6zzQhtuLClMntI4B0vcOeXBWFsIy8uiaB60HLTpviorkpr2Z/GvBWc1soULz
        gBp4z5DQh6jUGBETpVMYRmlin6sKajWSVq7B5AI4a8tDLUDTnA9OzvMX43561gzaHV5c/rQlLvSsT
        nensbArw==;
Received: from [37.204.119.143] (port=42272 helo=localhost.localdomain)
        by mail.cs.msu.ru with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93.0.4 (FreeBSD))
        (envelope-from <ar@cs.msu.ru>)
        id 1jU2uv-000B4I-Do; Thu, 30 Apr 2020 09:43:29 +0300
From:   Arseny Maslennikov <ar@cs.msu.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Arseny Maslennikov <ar@cs.msu.ru>, Rob Landley <rob@landley.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Machek <pavel@ucw.cz>, linux-api@vger.kernel.org,
        "Vladimir D. Seleznev" <vseleznv@altlinux.org>
Date:   Thu, 30 Apr 2020 09:42:58 +0300
Message-Id: <20200430064301.1099452-5-ar@cs.msu.ru>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430064301.1099452-1-ar@cs.msu.ru>
References: <20200430064301.1099452-1-ar@cs.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.204.119.143
X-SA-Exim-Mail-From: ar@cs.msu.ru
Subject: [PATCH v3 4/7] linux/signal.h: Ignore SIGINFO by default in new tasks
X-SA-Exim-Version: 4.2.1
X-SA-Exim-Scanned: Yes (on mail.cs.msu.ru)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

This matches the behaviour of other Unix-like systems that have SIGINFO
and causes less harm to processes that do not install handlers for this
signal, making the keyboard status character non-fatal for them.

This is implemented with the assumption that SIGINFO is defined
to be equivalent to SIGPWR; still, there is no reason for PWR to
result in termination of the signal recipient anyway — it does not
indicate there is a fatal problem with the recipient's execution
context (like e.g. FPE/ILL do), and we have TERM/KILL for explicit
termination requests.

To put it another way:
The only scenario where system behaviour actually changes is when the
signal recipient has default disposition for SIGPWR. If a process
chose to interpret a SIGPWR as an incentive to cleanly terminate, it
would supply its own handler — and this commit does not affect processes
with non-default handlers.

Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
---
 include/linux/signal.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 05bacd2ab..dc31da8fc 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -369,7 +369,7 @@ extern bool unhandled_signal(struct task_struct *tsk, int sig);
  *	|  SIGSYS/SIGUNUSED  |	coredump 	|
  *	|  SIGSTKFLT         |	terminate	|
  *	|  SIGWINCH          |	ignore   	|
- *	|  SIGPWR            |	terminate	|
+ *	|  SIGPWR            |	ignore   	|
  *	|  SIGRTMIN-SIGRTMAX |	terminate       |
  *	+--------------------+------------------+
  *	|  non-POSIX signal  |  default action  |
@@ -420,7 +420,8 @@ extern bool unhandled_signal(struct task_struct *tsk, int sig);
 
 #define SIG_KERNEL_IGNORE_MASK (\
         rt_sigmask(SIGCONT)   |  rt_sigmask(SIGCHLD)   | \
-	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    )
+	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    | \
+	rt_sigmask(SIGINFO)			       )
 
 #define SIG_SPECIFIC_SICODES_MASK (\
 	rt_sigmask(SIGILL)    |  rt_sigmask(SIGFPE)    | \
-- 
2.26.2

