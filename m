Return-Path: <SRS0=rFbF=BH=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB25EC433ED
	for <linux-api@archiver.kernel.org>; Tue, 28 Jul 2020 16:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A878222B3F
	for <linux-api@archiver.kernel.org>; Tue, 28 Jul 2020 16:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OAZmT69I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbgG1QfT (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 28 Jul 2020 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731798AbgG1QfG (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 28 Jul 2020 12:35:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98078C061794;
        Tue, 28 Jul 2020 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=q1GTk1RlsyvH9yQMe4vpFQxPuZOIwtLdA/sWj8+xUCM=; b=OAZmT69IL0zuGlaAUCzzjs4P9v
        34Q63h8slV+rUIaBsh57NjY34kBLKb2HB9bzpNRmgZtL+AAgiO7tT+umj6naUB1dDvQrMPazDDauX
        Wn5F9sDzoPy4mECigqgvsg53fnNsi3KNhi5NvuMRE/st+T7qMpE59weL2q5iJFgdxIbxCzckBSI7y
        3PwJIvawlf6lhzAZJIcDiSWM1XkrhveXDX7SlwCw4AZdmpQi1j5Eq43Uwdx7qfW8R1OfvgWhIGblr
        MR8K4zLPIL74xfLejBB27ic20Twi1SZvgyO/6WzzI28nlf7dAXlDwAH5+BgT27GYLljtU9+wRgSy3
        dnHbhfuA==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0SZB-00074B-IT; Tue, 28 Jul 2020 16:35:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 22/23] init: add an init_utimes helper
Date:   Tue, 28 Jul 2020 18:34:15 +0200
Message-Id: <20200728163416.556521-23-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
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
 fs/init.c                     | 13 +++++++++++++
 include/linux/init_syscalls.h |  1 +
 init/initramfs.c              |  3 +--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/init.c b/fs/init.c
index 51646ba38099e6..db5c48a85644fa 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -238,3 +238,16 @@ int __init init_rmdir(const char *pathname)
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
index 8f7e39f06547ff..d5351737624edd 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -111,8 +111,7 @@ static long __init do_utime(char *filename, time64_t mtime)
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

