Return-Path: <SRS0=Hu9T=4C=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A876BC2BA83
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 18:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7614120848
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 18:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgBNSkY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:40:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33818 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgBNSkX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Feb 2020 13:40:23 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j2fql-0000uO-JW; Fri, 14 Feb 2020 18:38:03 +0000
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
Subject: [PATCH v2 24/28] commoncap: cap_task_fix_setuid(): handle fsid mappings
Date:   Fri, 14 Feb 2020 19:35:50 +0100
Message-Id: <20200214183554.1133805-25-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214183554.1133805-1-christian.brauner@ubuntu.com>
References: <20200214183554.1133805-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Switch cap_task_fix_setuid() to lookup fsids in the fsid mappings. If no fsid
mappings are setup the behavior is unchanged, i.e. fsids are looked up in the
id mappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
unchanged
---
 security/commoncap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 9641695d8383..0581c6aa8bdc 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,6 +24,7 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
 #include <linux/personality.h>
+#include <linux/fsuidgid.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
@@ -1061,7 +1062,7 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
 		 *          if not, we might be a bit too harsh here.
 		 */
 		if (!issecure(SECURE_NO_SETUID_FIXUP)) {
-			kuid_t root_uid = make_kuid(old->user_ns, 0);
+			kuid_t root_uid = make_kfsuid(old->user_ns, 0);
 			if (uid_eq(old->fsuid, root_uid) && !uid_eq(new->fsuid, root_uid))
 				new->cap_effective =
 					cap_drop_fs_set(new->cap_effective);
-- 
2.25.0

