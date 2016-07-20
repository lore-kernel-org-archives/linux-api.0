From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3 v2] namei: add LOOKUP_DFD_ROOT to use dfd as root
Date: Wed, 20 Jul 2016 13:42:55 -0700
Message-ID: <1469047377-13128-2-git-send-email-avagin@openvz.org>
References: <1469047377-13128-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1469047377-13128-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The problem is that a pathname can contain absolute symlinks and now
they are resolved relative to the current root.

If we want to open a file in another mount namespaces and we have a file
descriptor to its root directory, we probably want to resolve pathname
in the target mount namespace. For this we add this new flag.

If LOOKUP_DFD_ROOT is set, path_init() initializes nd->root and nd->path
to the same value.

Changes since v1:
* initialize nd->root_seq (thanks to Omar Sandoval for reporting and
  fixing this issue)

Cc: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/namei.c            | 16 +++++++++++++++-
 include/linux/namei.h |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 28cb1cd..17548b1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2141,7 +2141,7 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.dentry = NULL;
 
 	nd->m_seq = read_seqbegin(&mount_lock);
-	if (*s == '/') {
+	if (*s == '/' && !(flags & LOOKUP_DFD_ROOT)) {
 		if (flags & LOOKUP_RCU)
 			rcu_read_lock();
 		set_root(nd);
@@ -2167,6 +2167,13 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			get_fs_pwd(current->fs, &nd->path);
 			nd->inode = nd->path.dentry->d_inode;
 		}
+		if (flags & LOOKUP_DFD_ROOT) {
+			nd->root = nd->path;
+			if (flags & LOOKUP_RCU)
+				nd->root_seq = nd->seq;
+			else
+				path_get(&nd->root);
+		}
 		return s;
 	} else {
 		/* Caller must check execute permissions on the starting path component */
@@ -2195,6 +2202,13 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			nd->inode = nd->path.dentry->d_inode;
 		}
 		fdput(f);
+		if (flags & LOOKUP_DFD_ROOT) {
+			nd->root = nd->path;
+			if (flags & LOOKUP_RCU)
+				nd->root_seq = nd->seq;
+			else
+				path_get(&nd->root);
+		}
 		return s;
 	}
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index ec5ec28..59ca78c 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -45,6 +45,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_EMPTY		0x4000
 
+#define LOOKUP_DFD_ROOT		0x8000
+
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
 
 static inline int user_path_at(int dfd, const char __user *name, unsigned flags,
-- 
2.5.5
