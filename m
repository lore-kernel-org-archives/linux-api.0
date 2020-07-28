Return-Path: <SRS0=rFbF=BH=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BE5C43459
	for <linux-api@archiver.kernel.org>; Tue, 28 Jul 2020 16:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A46207F5
	for <linux-api@archiver.kernel.org>; Tue, 28 Jul 2020 16:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jp+B769e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbgG1QgU (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 28 Jul 2020 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731416AbgG1Qe2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 28 Jul 2020 12:34:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CCFC0619D2;
        Tue, 28 Jul 2020 09:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=EC+FxFIHex2sWZ34S6MwpVZAyyDPurOctu/Z14/eRMg=; b=jp+B769e3a9nErJNCadZHrwYi+
        o3ZwBvysW28Ep104+GAgBewclKtZE6ilG5Za6kuPvGUyjtIwqlNeN9ijZH8wvwmbSCP1Z3y4Y3J1v
        biukOJsHnmLrfXy5dDJG2aRYMCXafs4BIjCz+FNoEp/t4c5+xNYtw4MeT0VptvaA83kI67hlRgeKI
        d/LV6K1lftWFIuSmfBlv8LDUCjAvBBgZFGr9XK5a6fSZ+nKgOK221ysnXOJtMecJ2x6qyAfuZt5nY
        gGMGjLu63bCWDTlvpVBP4jxoq4G2Fk2JAxPAr0qeG0ghPTEmII2pnpqM3inxTg+SdPxlGpe5wy/Bo
        14I5Dl3A==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0SYa-0006xJ-ML; Tue, 28 Jul 2020 16:34:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 04/23] devtmpfs: refactor devtmpfsd()
Date:   Tue, 28 Jul 2020 18:33:57 +0200
Message-Id: <20200728163416.556521-5-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Split the main worker loop into a separate function.  This allows
devtmpfsd_setup to be marked __init, which will allows us to call
__init routines for the setup work.  devtmpfѕ itself needs a __ref
marker for that to work, and a comment explaining why it works.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/base/devtmpfs.c | 52 ++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index c9017e0584c003..d697634bc0d48c 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -378,7 +378,30 @@ static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
 		return handle_remove(name, dev);
 }
 
-static int devtmpfs_setup(void *p)
+static void __noreturn devtmpfs_work_loop(void)
+{
+	while (1) {
+		spin_lock(&req_lock);
+		while (requests) {
+			struct req *req = requests;
+			requests = NULL;
+			spin_unlock(&req_lock);
+			while (req) {
+				struct req *next = req->next;
+				req->err = handle(req->name, req->mode,
+						  req->uid, req->gid, req->dev);
+				complete(&req->done);
+				req = next;
+			}
+			spin_lock(&req_lock);
+		}
+		__set_current_state(TASK_INTERRUPTIBLE);
+		spin_unlock(&req_lock);
+		schedule();
+	}
+}
+
+static int __init devtmpfs_setup(void *p)
 {
 	int err;
 
@@ -396,31 +419,18 @@ static int devtmpfs_setup(void *p)
 	return err;
 }
 
-static int devtmpfsd(void *p)
+/*
+ * The __ref is because devtmpfs_setup needs to be __init for the routines it
+ * calls.  That call is done while devtmpfs_init, which is marked __init,
+ * synchronously waits for it to complete.
+ */
+static int __ref devtmpfsd(void *p)
 {
 	int err = devtmpfs_setup(p);
 
 	if (err)
 		return err;
-	while (1) {
-		spin_lock(&req_lock);
-		while (requests) {
-			struct req *req = requests;
-			requests = NULL;
-			spin_unlock(&req_lock);
-			while (req) {
-				struct req *next = req->next;
-				req->err = handle(req->name, req->mode,
-						  req->uid, req->gid, req->dev);
-				complete(&req->done);
-				req = next;
-			}
-			spin_lock(&req_lock);
-		}
-		__set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock(&req_lock);
-		schedule();
-	}
+	devtmpfs_work_loop();
 	return 0;
 }
 
-- 
2.27.0

