Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C825C433F5
	for <linux-api@archiver.kernel.org>; Mon, 21 Feb 2022 15:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379677AbiBUPxQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 21 Feb 2022 10:53:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiBUPxP (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 21 Feb 2022 10:53:15 -0500
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 07:52:51 PST
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [45.157.188.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6627626542
        for <linux-api@vger.kernel.org>; Mon, 21 Feb 2022 07:52:51 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4K2RQx6PqBzMqBHW;
        Mon, 21 Feb 2022 16:43:21 +0100 (CET)
Received: from localhost (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4K2RQx4nTWzlhMCN;
        Mon, 21 Feb 2022 16:43:21 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Shuah Khan <shuah@kernel.org>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v1 7/7] selftest/landlock: Fully test file rename with "remove" access
Date:   Mon, 21 Feb 2022 16:53:11 +0100
Message-Id: <20220221155311.166278-8-mic@digikod.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221155311.166278-1-mic@digikod.net>
References: <20220221155311.166278-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

These tests were missing to check the check_access_path() call with all
combinations of maybe_remove(old_dentry) and maybe_remove(new_dentry).

Extend layout1/link with a new complementary test.

Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220221155311.166278-8-mic@digikod.net
---
 tools/testing/selftests/landlock/fs_test.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 3736253c9582..62b88406419d 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -1640,11 +1640,14 @@ TEST_F_FORK(layout1, link)
 
 	ASSERT_EQ(-1, link(file2_s1d1, file1_s1d1));
 	ASSERT_EQ(EACCES, errno);
+
 	/* Denies linking because of reparenting. */
 	ASSERT_EQ(-1, link(file1_s2d1, file1_s1d2));
 	ASSERT_EQ(EXDEV, errno);
 	ASSERT_EQ(-1, link(file2_s1d2, file1_s1d3));
 	ASSERT_EQ(EXDEV, errno);
+	ASSERT_EQ(-1, link(file2_s1d3, file1_s1d2));
+	ASSERT_EQ(EXDEV, errno);
 
 	ASSERT_EQ(0, link(file2_s1d2, file1_s1d2));
 	ASSERT_EQ(0, link(file2_s1d3, file1_s1d3));
@@ -1668,7 +1671,6 @@ TEST_F_FORK(layout1, rename_file)
 
 	ASSERT_LE(0, ruleset_fd);
 
-	ASSERT_EQ(0, unlink(file1_s1d1));
 	ASSERT_EQ(0, unlink(file1_s1d2));
 
 	enforce_ruleset(_metadata, ruleset_fd);
@@ -1704,9 +1706,15 @@ TEST_F_FORK(layout1, rename_file)
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s2d2, AT_FDCWD, file1_s2d1,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that file1_s2d1 cannot be removed (instead of ENOTDIR). */
+	ASSERT_EQ(-1, rename(dir_s2d2, file1_s2d1));
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s2d1, AT_FDCWD, dir_s2d2,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that file1_s1d1 cannot be removed (instead of EISDIR). */
+	ASSERT_EQ(-1, rename(file1_s1d1, dir_s1d2));
+	ASSERT_EQ(EACCES, errno);
 
 	/* Renames files with different parents. */
 	ASSERT_EQ(-1, rename(file1_s2d2, file1_s1d2));
@@ -1769,9 +1777,15 @@ TEST_F_FORK(layout1, rename_dir)
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, dir_s1d1, AT_FDCWD, dir_s2d1,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that dir_s1d2 cannot be removed (instead of ENOTDIR). */
+	ASSERT_EQ(-1, rename(dir_s1d2, file1_s1d1));
+	ASSERT_EQ(EACCES, errno);
 	ASSERT_EQ(-1, renameat2(AT_FDCWD, file1_s1d1, AT_FDCWD, dir_s1d2,
 				RENAME_EXCHANGE));
 	ASSERT_EQ(EACCES, errno);
+	/* Checks that dir_s1d2 cannot be removed (instead of EISDIR). */
+	ASSERT_EQ(-1, rename(file1_s1d1, dir_s1d2));
+	ASSERT_EQ(EACCES, errno);
 
 	/*
 	 * Exchanges and renames directory to the same parent, which allows
-- 
2.35.1

