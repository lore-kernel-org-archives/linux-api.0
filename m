From: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Subject: [PATCH] fs: check for DAC_READ_SEARCH instead of SYS_ADMIN
Date: Sat, 21 Oct 2017 15:24:46 +0200
Message-ID: <20171021132446.17567-1-nicolas@belouin.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These checks are meant to prevent leaks or attacks via directory
traversal, the use of CAP_SYS_ADMIN here is a misuse,
CAP_DAC_READ_SEARCH being way more appropriate as a process
with CAP_DAC_READ_SEARCH is entrusted with going trough all directories.
CAP_SYS_ADMIN is not meant to flag such a process.

Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
---
 fs/dcookies.c  | 2 +-
 fs/proc/base.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index 0d0461cf2431..48491299a183 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -158,7 +158,7 @@ SYSCALL_DEFINE3(lookup_dcookie, u64, cookie64, char __user *, buf, size_t, len)
 	/* we could leak path information to users
 	 * without dir read permission without this
 	 */
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_DAC_READ_SEARCH))
 		return -EPERM;
 
 	mutex_lock(&dcookie_mutex);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ad3b0762cc3e..965a3aa1a77f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2006,16 +2006,16 @@ struct map_files_info {
 };
 
 /*
- * Only allow CAP_SYS_ADMIN to follow the links, due to concerns about how the
- * symlinks may be used to bypass permissions on ancestor directories in the
- * path to the file in question.
+ * Only allow CAP_SYS_ADMIN or CAP_DAC_READ_SEARCH to follow the links, due
+ * to concerns about how the symlinks may be used to bypass permissions on
+ * ancestor directories in the path to the file in question.
  */
 static const char *
 proc_map_files_get_link(struct dentry *dentry,
 			struct inode *inode,
 		        struct delayed_call *done)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_DAC_READ_SEARCH))
 		return ERR_PTR(-EPERM);
 
 	return proc_pid_get_link(dentry, inode, done);
-- 
2.14.2
