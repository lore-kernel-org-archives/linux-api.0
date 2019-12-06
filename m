From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v18 03/13] namei: allow nd_jump_link() to produce errors
Date: Sat,  7 Dec 2019 01:13:28 +1100
Message-ID: <20191206141338.23338-4-cyphar@cyphar.com>
References: <20191206141338.23338-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191206141338.23338-1-cyphar@cyphar.com>
Sender: netdev-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, dev@opencontainers.org, containers@lists.linux-foundation.org, bpf@vger.kernel.org, netdev@vger.kernel.orgl
List-Id: linux-api@vger.kernel.org

In preparation for LOOKUP_NO_MAGICLINKS, it's necessary to add the
ability for nd_jump_link() to return an error which the corresponding
get_link() caller must propogate back up to the VFS.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c                     |  3 ++-
 fs/proc/base.c                 |  3 +--
 fs/proc/namespaces.c           | 14 +++++++++-----
 include/linux/namei.h          |  2 +-
 security/apparmor/apparmorfs.c |  6 ++++--
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5a47d9c09581..1024a641f075 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -859,7 +859,7 @@ static int nd_jump_root(struct nameidata *nd)
  * Helper to directly jump to a known parsed path from ->get_link,
  * caller must have taken a reference to path beforehand.
  */
-void nd_jump_link(struct path *path)
+int nd_jump_link(struct path *path)
 {
 	struct nameidata *nd = current->nameidata;
 	path_put(&nd->path);
@@ -867,6 +867,7 @@ void nd_jump_link(struct path *path)
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }
 
 static inline void put_link(struct nameidata *nd)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb8..ee97dd322f3e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1626,8 +1626,7 @@ static const char *proc_pid_get_link(struct dentry *dentry,
 	if (error)
 		goto out;
 
-	nd_jump_link(&path);
-	return NULL;
+	error = nd_jump_link(&path);
 out:
 	return ERR_PTR(error);
 }
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 08dd94df1a66..a8cca516f1a9 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -51,11 +51,15 @@ static const char *proc_ns_get_link(struct dentry *dentry,
 	if (!task)
 		return ERR_PTR(-EACCES);
 
-	if (ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS)) {
-		error = ns_get_path(&ns_path, task, ns_ops);
-		if (!error)
-			nd_jump_link(&ns_path);
-	}
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))
+		goto out;
+
+	error = ns_get_path(&ns_path, task, ns_ops);
+	if (error)
+		goto out;
+
+	error = nd_jump_link(&ns_path);
+out:
 	put_task_struct(task);
 	return ERR_PTR(error);
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 397a08ade6a2..758e9b47db6f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -68,7 +68,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
-extern void nd_jump_link(struct path *path);
+extern int __must_check nd_jump_link(struct path *path);
 
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 45d13b6462aa..0b7d6dce6291 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2455,16 +2455,18 @@ static const char *policy_get_link(struct dentry *dentry,
 {
 	struct aa_ns *ns;
 	struct path path;
+	int error;
 
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
+
 	ns = aa_get_current_ns();
 	path.mnt = mntget(aafs_mnt);
 	path.dentry = dget(ns_dir(ns));
-	nd_jump_link(&path);
+	error = nd_jump_link(&path);
 	aa_put_ns(ns);
 
-	return NULL;
+	return ERR_PTR(error);
 }
 
 static int policy_readlink(struct dentry *dentry, char __user *buffer,
-- 
2.24.0
