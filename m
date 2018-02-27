From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 01/11] fs,security: Add a security blob to nameidata
Date: Tue, 27 Feb 2018 01:41:11 +0100
Message-ID: <20180227004121.3633-2-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-11976-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho
List-Id: linux-api@vger.kernel.org

The function current_nameidata_security(struct inode *) can be used to
retrieve a blob's pointer address tied to the inode being walk through.
This enable to follow a path lookup and know where an inode access come
from. This is needed for the Landlock LSM to be able to restrict access
to file path.

The LSM hook nameidata_free_security(struct inode *) is called before
freeing the associated nameidata.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/namei.c                | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/lsm_hooks.h |  7 +++++++
 include/linux/namei.h     | 14 +++++++++++++-
 include/linux/security.h  |  7 +++++++
 security/security.c       |  7 +++++++
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 921ae32dbc80..d592b3fb0d1e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -505,6 +505,9 @@ struct nameidata {
 	struct inode	*link_inode;
 	unsigned	root_seq;
 	int		dfd;
+#ifdef CONFIG_SECURITY
+	struct nameidata_lookup lookup;
+#endif
 } __randomize_layout;
 
 static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
@@ -515,6 +518,9 @@ static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 	p->name = name;
 	p->total_link_count = old ? old->total_link_count : 0;
 	p->saved = old;
+#ifdef CONFIG_SECURITY
+	p->lookup.security = NULL;
+#endif
 	current->nameidata = p;
 }
 
@@ -522,6 +528,7 @@ static void restore_nameidata(void)
 {
 	struct nameidata *now = current->nameidata, *old = now->saved;
 
+	security_nameidata_put_lookup(&now->lookup, now->inode);
 	current->nameidata = old;
 	if (old)
 		old->total_link_count = now->total_link_count;
@@ -549,6 +556,27 @@ static int __nd_alloc_stack(struct nameidata *nd)
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY
+/**
+ * current_nameidata_lookup - get the state of the current path walk
+ *
+ * @inode: inode associated to the path walk
+ *
+ * Used by LSM modules for access restriction based on path walk. The LSM is in
+ * charge of the lookup->security blob allocation and management. The hook
+ * security_nameidata_put_lookup() will be called after the path walk end.
+ *
+ * Return ERR_PTR(-ENOENT) if there is no match.
+ */
+struct nameidata_lookup *current_nameidata_lookup(const struct inode *inode)
+{
+	if (!current->nameidata || current->nameidata->inode != inode)
+		return ERR_PTR(-ENOENT);
+	return &current->nameidata->lookup;
+}
+EXPORT_SYMBOL(current_nameidata_lookup);
+#endif
+
 /**
  * path_connected - Verify that a path->dentry is below path->mnt.mnt_root
  * @path: nameidate to verify
@@ -2009,6 +2037,13 @@ static inline u64 hash_name(const void *salt, const char *name)
 
 #endif
 
+static inline void refresh_lookup(struct nameidata *nd)
+{
+#ifdef CONFIG_SECURITY
+	nd->lookup.type = nd->last_type;
+#endif
+}
+
 /*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
@@ -2025,6 +2060,8 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		name++;
 	if (!*name)
 		return 0;
+	/* be ready for may_lookup() */
+	refresh_lookup(nd);
 
 	/* At this point we know we have a real path component. */
 	for(;;) {
@@ -2064,6 +2101,8 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		nd->last.hash_len = hash_len;
 		nd->last.name = name;
 		nd->last_type = type;
+		/* be ready for the next security_inode_permission() */
+		refresh_lookup(nd);
 
 		name += hashlen_len(hash_len);
 		if (!*name)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7161d8e7ee79..d71cf183f0be 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -428,6 +428,10 @@
  *	security module does not know about attribute or a negative error code
  *	to abort the copy up. Note that the caller is responsible for reading
  *	and writing the xattrs as this hook is merely a filter.
+ * @nameidata_put_lookup:
+ *	Deallocate and clear the current's nameidata->lookup.security field.
+ *	@lookup->security contains the security structure to be freed.
+ *	@inode is the last associated inode to the path walk
  *
  * Security hooks for file operations
  *
@@ -1514,6 +1518,8 @@ union security_list_options {
 	void (*inode_getsecid)(struct inode *inode, u32 *secid);
 	int (*inode_copy_up)(struct dentry *src, struct cred **new);
 	int (*inode_copy_up_xattr)(const char *name);
+	void (*nameidata_put_lookup)(struct nameidata_lookup *lookup,
+					struct inode *inode);
 
 	int (*file_permission)(struct file *file, int mask);
 	int (*file_alloc_security)(struct file *file);
@@ -1805,6 +1811,7 @@ struct security_hook_heads {
 	struct list_head inode_getsecid;
 	struct list_head inode_copy_up;
 	struct list_head inode_copy_up_xattr;
+	struct list_head nameidata_put_lookup;
 	struct list_head file_permission;
 	struct list_head file_alloc_security;
 	struct list_head file_free_security;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index a982bb7cd480..ba08cbb41f97 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -14,7 +14,19 @@ enum { MAX_NESTED_LINKS = 8 };
 /*
  * Type of the last component on LOOKUP_PARENT
  */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
+enum namei_type {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
+
+#ifdef CONFIG_SECURITY
+struct nameidata_lookup {
+	void *security;
+	enum namei_type type;
+};
+
+struct inode;
+
+extern struct nameidata_lookup *current_nameidata_lookup(
+		const struct inode *inode);
+#endif
 
 /*
  * The bitmask for a lookup event:
diff --git a/include/linux/security.h b/include/linux/security.h
index 73f1ef625d40..b1fd4370daf8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/namei.h>
 
 struct linux_binprm;
 struct cred;
@@ -302,6 +303,8 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 void security_inode_getsecid(struct inode *inode, u32 *secid);
 int security_inode_copy_up(struct dentry *src, struct cred **new);
 int security_inode_copy_up_xattr(const char *name);
+void security_nameidata_put_lookup(struct nameidata_lookup *lookup,
+					struct inode *inode);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -808,6 +811,10 @@ static inline int security_inode_copy_up_xattr(const char *name)
 	return -EOPNOTSUPP;
 }
 
+static inline void security_nameidata_put_lookup(
+		struct nameidata_lookup *lookup, struct inode *inode)
+{ }
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
diff --git a/security/security.c b/security/security.c
index 1cd8526cb0b7..17053c7a1a77 100644
--- a/security/security.c
+++ b/security/security.c
@@ -857,6 +857,13 @@ int security_inode_copy_up_xattr(const char *name)
 }
 EXPORT_SYMBOL(security_inode_copy_up_xattr);
 
+void security_nameidata_put_lookup(struct nameidata_lookup *lookup,
+					struct inode *inode)
+{
+	call_void_hook(nameidata_put_lookup, lookup, inode);
+}
+EXPORT_SYMBOL(security_nameidata_put_lookup);
+
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;
-- 
2.16.2
