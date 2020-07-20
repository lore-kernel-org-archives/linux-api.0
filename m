Return-Path: <SRS0=cHN1=A7=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C79C433E0
	for <linux-api@archiver.kernel.org>; Mon, 20 Jul 2020 16:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9B22073A
	for <linux-api@archiver.kernel.org>; Mon, 20 Jul 2020 16:29:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T1qIkJk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgGTP7M (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 20 Jul 2020 11:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732143AbgGTP7M (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 20 Jul 2020 11:59:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB8C0619D4;
        Mon, 20 Jul 2020 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=szWl1h+pYK/HnKbBrREDHsB1qY6TetWZvhxkv/iA/l8=; b=T1qIkJk8b4fFG1jYmgBx4a22Zk
        HPGI/2zp7Zut3Dh5mcnkf26AHZ1TK6HcymCwf4Lyg6oypwNydNi7wId9yMYJNEu/q8YMO6jvRCMN1
        lPtsZUK5ZmxMMIIYdWBHtCGVve8vSdS4UtaNpEnONhkJwCUwduLgElTb+H/sEBiLvvSTQInW/ugYY
        NfMG2G/lS+KaMS+wiAmxTKrtM/dJit+hVYQm1dAy6DYcyUiFcYFTmQcWMMjzjOYsYdIm9qqtqctdn
        Jya+RVgkxZo1PXg6vBIzNgM66TVmB/xGB/2maN6W9CoyToz003Rpl1KHHT6CDlATZc0rQtT2xYK8N
        0Oo9YBrg==;
Received: from [2001:4bb8:105:4a81:db56:edb1:dbf2:5cc3] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxYC5-0007n9-1U; Mon, 20 Jul 2020 15:59:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 04/24] fs: move the putname from filename_create to the callers
Date:   Mon, 20 Jul 2020 17:58:42 +0200
Message-Id: <20200720155902.181712-5-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720155902.181712-1-hch@lst.de>
References: <20200720155902.181712-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

This allows reusing the struct filename for retries, and will also allow
pushing the getname up the stack for a few places to allower for better
handling of kernel space filenames.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 72d4219c93acb7..6ebe400c9736d2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3478,7 +3478,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3496,8 +3495,12 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 struct dentry *kern_path_create(int dfd, const char *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
-	return filename_create(dfd, getname_kernel(pathname),
-				path, lookup_flags);
+	struct filename *name = getname_kernel(pathname);
+	struct dentry *dentry = filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(dentry))
+		putname(name);
+	return dentry;
 }
 EXPORT_SYMBOL(kern_path_create);
 
@@ -3513,7 +3516,12 @@ EXPORT_SYMBOL(done_path_create);
 inline struct dentry *user_path_create(int dfd, const char __user *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
-	return filename_create(dfd, getname(pathname), path, lookup_flags);
+	struct filename *name = getname(pathname);
+	struct dentry *dentry = filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(dentry))
+		putname(name);
+	return dentry;
 }
 EXPORT_SYMBOL(user_path_create);
 
-- 
2.27.0

