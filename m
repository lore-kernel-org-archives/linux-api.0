Return-Path: <SRS0=cHN1=A7=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C504C433FB
	for <linux-api@archiver.kernel.org>; Mon, 20 Jul 2020 16:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C1422BF3
	for <linux-api@archiver.kernel.org>; Mon, 20 Jul 2020 16:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIY1Vo37"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbgGTP7Q (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 20 Jul 2020 11:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732163AbgGTP7O (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 20 Jul 2020 11:59:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A52C061794;
        Mon, 20 Jul 2020 08:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=odQbkjUxFzFbuRy/BvdmjLaA+rlQMKoZDJWHpbta07k=; b=GIY1Vo37RS232P6603hY2FmVZg
        xjy9iUZMV66tye6HDkbPmBX6BokK6zYlkozUTzAmuJ3qiaqXwvy1mt/yeB+pKw4chHLHUKBOukBcK
        IyZqWmEbiduutlH7PQXKeUv0OQzxm5Qkts7n5X1EwLrVJninoPqCbjWgiIOp5eSpfi2Bit/yriOV7
        bK0hOjuEPrfjxAPx8Ce/rkvaU13hAEvTKmnCcMrVRGLhdHi8SGwaGr+CePd6xynRIqRL/nkHueflB
        8K2BBY5gvZDKIgvWg6zfZsA2b1eue3lI1Xp8lxuXzyWfVFzx0qmlSu2VoHf99jLRIARp0ebEviXzm
        YLBL3pzA==;
Received: from [2001:4bb8:105:4a81:db56:edb1:dbf2:5cc3] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxYC6-0007nJ-CS; Mon, 20 Jul 2020 15:59:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 05/24] fs: move the putname from filename_lookup to the callers
Date:   Mon, 20 Jul 2020 17:58:43 +0200
Message-Id: <20200720155902.181712-6-hch@lst.de>
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
 fs/fs_parser.c |  1 +
 fs/namei.c     | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index ab53e42a874aaa..58d5e53d74eeb7 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -171,6 +171,7 @@ int fs_lookup_param(struct fs_context *fc,
 		errorf(fc, "%s: Lookup failure for '%s'", param->key, f->name);
 		goto out;
 	}
+	putname(f);
 
 	if (want_bdev &&
 	    !S_ISBLK(d_backing_inode(_path->dentry)->i_mode)) {
diff --git a/fs/namei.c b/fs/namei.c
index 6ebe400c9736d2..6daffd59e97270 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2372,8 +2372,9 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 	if (likely(!retval))
 		audit_inode(name, path->dentry,
 			    flags & LOOKUP_MOUNTPOINT ? AUDIT_INODE_NOEVAL : 0);
+	else
+		putname(name);
 	restore_nameidata();
-	putname(name);
 	return retval;
 }
 
@@ -2450,8 +2451,12 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
-	return filename_lookup(AT_FDCWD, getname_kernel(name),
-			       flags, path, NULL);
+	struct filename *f = getname_kernel(name);
+	int ret = filename_lookup(AT_FDCWD, f, flags, path, NULL);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(kern_path);
 
@@ -2468,9 +2473,12 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 		    struct path *path)
 {
 	struct path root = {.mnt = mnt, .dentry = dentry};
-	/* the first argument of filename_lookup() is ignored with root */
-	return filename_lookup(AT_FDCWD, getname_kernel(name),
-			       flags , path, &root);
+	struct filename *f = getname_kernel(name);
+	int ret = filename_lookup(AT_FDCWD, f, flags, path, &root);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(vfs_path_lookup);
 
@@ -2643,8 +2651,12 @@ int path_pts(struct path *path)
 int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 		 struct path *path, int *empty)
 {
-	return filename_lookup(dfd, getname_flags(name, flags, empty),
-			       flags, path, NULL);
+	struct filename *f = getname_flags(name, flags, empty);
+	int ret = filename_lookup(dfd, f, flags, path, NULL);
+
+	if (!ret)
+		putname(f);
+	return ret;
 }
 EXPORT_SYMBOL(user_path_at_empty);
 
-- 
2.27.0

