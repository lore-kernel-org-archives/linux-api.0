From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 07/24] namei: may_{o_}create(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:36 +0100
Message-ID: <20200211165753.356508-8-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch may_{o_}create() to lookup fsids in the fsid mappings. If no fsid
mappings are setup the behavior is unchanged, i.e. fsids are looked up in the
id mappings.

Filesystems that share a superblock in all user namespaces they are mounted in
will retain their old semantics even with the introduction of fsidmappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4fb61e0754ed..c85c65adfa9d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -39,6 +39,7 @@
 #include <linux/bitops.h>
 #include <linux/init_task.h>
 #include <linux/uaccess.h>
+#include <linux/fsuidgid.h>
 
 #include "internal.h"
 #include "mount.h"
@@ -2771,6 +2772,20 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	return 0;
 }
 
+static bool fsid_has_mapping(struct user_namespace *ns, struct super_block *sb)
+{
+	if (is_userns_visible(sb->s_iflags)) {
+		if (!kuid_has_mapping(ns, current_fsuid()) ||
+		    !kgid_has_mapping(ns, current_fsgid()))
+			return false;
+	} else if (!kfsuid_has_mapping(ns, current_fsuid()) ||
+		   !kfsgid_has_mapping(ns, current_fsgid())) {
+		return false;
+	}
+
+	return true;
+}
+
 /*	Check whether we can create an object with dentry child in directory
  *  dir.
  *  1. We can't do it if child already exists (open has special treatment for
@@ -2789,8 +2804,7 @@ static inline int may_create(struct inode *dir, struct dentry *child)
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
 	s_user_ns = dir->i_sb->s_user_ns;
-	if (!kuid_has_mapping(s_user_ns, current_fsuid()) ||
-	    !kgid_has_mapping(s_user_ns, current_fsgid()))
+	if (!fsid_has_mapping(s_user_ns, dir->i_sb))
 		return -EOVERFLOW;
 	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
 }
@@ -2972,8 +2986,7 @@ static int may_o_create(const struct path *dir, struct dentry *dentry, umode_t m
 		return error;
 
 	s_user_ns = dir->dentry->d_sb->s_user_ns;
-	if (!kuid_has_mapping(s_user_ns, current_fsuid()) ||
-	    !kgid_has_mapping(s_user_ns, current_fsgid()))
+	if (!fsid_has_mapping(s_user_ns, dir->dentry->d_sb))
 		return -EOVERFLOW;
 
 	error = inode_permission(dir->dentry->d_inode, MAY_WRITE | MAY_EXEC);
-- 
2.25.0
