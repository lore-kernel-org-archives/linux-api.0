Return-Path: <SRS0=PoQX=4G=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C93C3403F
	for <linux-api@archiver.kernel.org>; Tue, 18 Feb 2020 14:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB9320801
	for <linux-api@archiver.kernel.org>; Tue, 18 Feb 2020 14:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgBROfi (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 18 Feb 2020 09:35:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53006 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgBROfi (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 18 Feb 2020 09:35:38 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j43y0-0000fF-GX; Tue, 18 Feb 2020 14:35:16 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc:     smbarber@chromium.org, Seth Forshee <seth.forshee@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Phil Estes <estesp@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v3 12/25] capability: privileged_wrt_inode_uidgid(): handle fsid mappings
Date:   Tue, 18 Feb 2020 15:33:58 +0100
Message-Id: <20200218143411.2389182-13-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218143411.2389182-1-christian.brauner@ubuntu.com>
References: <20200218143411.2389182-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Switch privileged_wrt_inode_uidgid() to lookup fsids in the fsid mappings. If
no fsid mappings are setup the behavior is unchanged, i.e. fsids are looked up
in the id mappings.

Filesystems that share a superblock in all user namespaces they are mounted in
will retain their old semantics even with the introduction of fsid mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
unchanged

/* v3 */
unchanged
---
 kernel/capability.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 1444f3954d75..2b0c1dc992e2 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -19,6 +19,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/uaccess.h>
+#include <linux/fsuidgid.h>
+#include <linux/fs.h>
 
 /*
  * Leveraged for setting/resetting capabilities
@@ -486,8 +488,12 @@ EXPORT_SYMBOL(file_ns_capable);
  */
 bool privileged_wrt_inode_uidgid(struct user_namespace *ns, const struct inode *inode)
 {
-	return kuid_has_mapping(ns, inode->i_uid) &&
-		kgid_has_mapping(ns, inode->i_gid);
+	if (is_userns_visible(inode->i_sb->s_iflags))
+		return kuid_has_mapping(ns, inode->i_uid) &&
+		       kgid_has_mapping(ns, inode->i_gid);
+
+	return kfsuid_has_mapping(ns, inode->i_uid) &&
+	       kfsgid_has_mapping(ns, inode->i_gid);
 }
 
 /**
-- 
2.25.0

