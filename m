From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 11/24] open: chown_common(): handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:40 +0100
Message-ID: <20200211165753.356508-12-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch chown_common() to lookup fsids in the fsid mappings. If no fsid
mappings are setup the behavior is unchanged, i.e. fsids are looked up in the
id mappings.

Filesystems that share a superblock in all user namespaces they are mounted in
will retain their old semantics even with the introduction of fsidmappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/open.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index b62f5c0923a8..e5154841152c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -32,6 +32,7 @@
 #include <linux/ima.h>
 #include <linux/dnotify.h>
 #include <linux/compat.h>
+#include <linux/fsuidgid.h>
 
 #include "internal.h"
 
@@ -626,8 +627,13 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
 	kuid_t uid;
 	kgid_t gid;
 
-	uid = make_kuid(current_user_ns(), user);
-	gid = make_kgid(current_user_ns(), group);
+	if (is_userns_visible(inode->i_sb->s_iflags)) {
+		uid = make_kuid(current_user_ns(), user);
+		gid = make_kgid(current_user_ns(), group);
+	} else {
+		uid = make_kfsuid(current_user_ns(), user);
+		gid = make_kfsgid(current_user_ns(), group);
+	}
 
 retry_deleg:
 	newattrs.ia_valid =  ATTR_CTIME;
-- 
2.25.0
