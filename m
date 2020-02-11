From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 09/24] capability: privileged_wrt_inode_uidgid(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:38 +0100
Message-ID: <20200211165753.356508-10-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch privileged_wrt_inode_uidgid() to lookup fsids in the fsid mappings. If
no fsid mappings are setup the behavior is unchanged, i.e. fsids are looked up
in the id mappings.

Filesystems that share a superblock in all user namespaces they are mounted in
will retain their old semantics even with the introduction of fsidmappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/capability.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 1444f3954d75..de7edd5c9900 100644
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
@@ -484,10 +486,15 @@ EXPORT_SYMBOL(file_ns_capable);
  *
  * Return true if the inode uid and gid are within the namespace.
  */
-bool privileged_wrt_inode_uidgid(struct user_namespace *ns, const struct inode *inode)
+bool privileged_wrt_inode_uidgid(struct user_namespace *ns,
+				 const struct inode *inode)
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
