Return-Path: <SRS0=pxsc=BF=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D0CC433ED
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 07:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2346A20715
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 07:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QBlZouW5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGZHO4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 26 Jul 2020 03:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgGZHOw (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 26 Jul 2020 03:14:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF4FC0619D2;
        Sun, 26 Jul 2020 00:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6X4e7OKSvxIk/16wDkIuYcxejxX1HL3zAnkYL6lwBI8=; b=QBlZouW5rzwkqYifDQ0WOC+x8i
        00pAUr3/zUqXlF1kbXcEnjmJbfCzt9w9yNE0EUdsuaDrPYyJA3eE4h+wHBcByA9N9LviZ52lRrK3h
        pCx26MNhTcyZ5PgmS7TsG5b18QxoEhTU5J1471K/uz9w3eXNqnOTInlCyV0zXo+R9iz2oq2LJlLS4
        vBQ6axzGlITpiFBNoycbuanDdKhTi6QxxERTiYyTCL2YpAlVSLbI4WUbqTWZIa96gwLUafRooqXp5
        X3dYbj9r3QRIlC4Bi6/4NWVT5uRrVwjzS/lkDBsMpqqZXyr/L5Ctv7236nkTVFeswJ7OKruOO/Il2
        MQwRVM3g==;
Received: from [2001:4bb8:18c:2acc:5ff1:d0b0:8643:670e] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jzarv-0002XC-75; Sun, 26 Jul 2020 07:14:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 21/21] init: add an init_utimes helper
Date:   Sun, 26 Jul 2020 09:13:56 +0200
Message-Id: <20200726071356.287160-22-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Add a simple helper to set timestamps with a kernel space file name and
switch the early init code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/for_init.c                 | 13 +++++++++++++
 include/linux/init_syscalls.h |  1 +
 init/initramfs.c              |  3 +--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/for_init.c b/fs/for_init.c
index 919a50130a5919..4eee11ad63ffce 100644
--- a/fs/for_init.c
+++ b/fs/for_init.c
@@ -234,3 +234,16 @@ int __init init_rmdir(const char *pathname)
 {
 	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
 }
+
+int __init init_utimes(char *filename, struct timespec64 *ts)
+{
+	struct path path;
+	int error;
+
+	error = kern_path(filename, 0, &path);
+	if (error)
+		return error;
+	error = vfs_utimes(&path, ts);
+	path_put(&path);
+	return error;
+}
diff --git a/include/linux/init_syscalls.h b/include/linux/init_syscalls.h
index b2fda50daca6c5..3654b525ac0b17 100644
--- a/include/linux/init_syscalls.h
+++ b/include/linux/init_syscalls.h
@@ -15,3 +15,4 @@ int __init init_symlink(const char *oldname, const char *newname);
 int __init init_unlink(const char *pathname);
 int __init init_mkdir(const char *pathname, umode_t mode);
 int __init init_rmdir(const char *pathname);
+int __init init_utimes(char *filename, struct timespec64 *ts);
diff --git a/init/initramfs.c b/init/initramfs.c
index b1be3ada3ce4b3..b9dfc941a4c3e4 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -110,8 +110,7 @@ static long __init do_utime(char *filename, time64_t mtime)
 	t[0].tv_nsec = 0;
 	t[1].tv_sec = mtime;
 	t[1].tv_nsec = 0;
-
-	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+	return init_utimes(filename, t);
 }
 
 static __initdata LIST_HEAD(dir_list);
-- 
2.27.0

