From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 3/3] namei: aggressively check for nd->root escape on ".." resolution
Date: Tue,  9 Oct 2018 18:02:30 +1100
Message-ID: <20181009070230.12884-4-cyphar@cyphar.com>
References: <20181009070230.12884-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009070230.12884-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch allows for AT_BENEATH and AT_THIS_ROOT to safely permit ".."
resolution (in the case of AT_BENEATH the resolution will still fail if
".." resolution would resolve a path outside of the root -- while
AT_THIS_ROOT will chroot(2)-style scope it). "proclink" jumps are still
disallowed entirely because now they could result in inconsistent
behaviour if resolution encounters a subsequent "..".

The need for this patch is explained by observing there is a fairly
easy-to-exploit race condition with chroot(2) (and thus by extension
AT_THIS_ROOT and AT_BENEATH) where a rename(2) of a path can be used to
"skip over" nd->root and thus escape to the filesystem above nd->root.

  thread1 [attacker]:
    for (;;)
      renameat2(AT_FDCWD, "/a/b/c", AT_FDCWD, "/a/d", RENAME_EXCHANGE);
  thread2 [victim]:
    for (;;)
      openat(dirb, "b/c/../../etc/shadow", O_THISROOT);

With fairly significant regularity, thread2 will resolve to
"/etc/shadow" rather than "/a/b/etc/shadow". There is also a similar
(though somewhat more privileged) attack using MS_MOVE.

With this patch, such cases will be detected *during* ".." resolution
(which is the weak point of chroot(2) -- since walking *into* a
subdirectory tautologically cannot result in you walking *outside*
nd->root -- except through a bind-mount or "proclink"). By detecting
this at ".." resolution (rather than checking only at the end of the
entire resolution) we can both correct escapes by jumping back to the
root (in the case of AT_THIS_ROOT), as well as avoid revealing to
attackers the structure of the filesystem outside of the root (through
timing attacks for instance).

In order to avoid a quadratic lookup with each ".." entry, we only
activate the slow path if a write through &rename_lock or &mount_lock
have occurred during path resolution (&rename_lock and &mount_lock are
re-taken to further optimise the lookup). Since the primary attack being
protected against is MS_MOVE or rename(2), not doing additional checks
unless a mount or rename have occurred avoids making the common case
slow.

The use of __d_path here might seem suspect, but on further inspection
of the most important race (a path was *inside* the root but is now
*outside*), there appears to be no attack potential. If __d_path occurs
before the rename, then the path will be resolved but since the path was
originally inside the root there is no escape. Subsequent ".." jumps are
guaranteed to check __d_path reachable (by construction, &rename_lock or
&mount_lock must have been taken after __d_path returned), and thus will
not be able to escape from the previously-inside-root path. Walking down
is still safe since the entire subtree was moved (either by rename(2) or
MS_MOVE) and because (as discussed above) walking down is safe.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c | 79 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b31aef27df22..12cd8d8987ea 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -493,7 +493,7 @@ struct nameidata {
 	struct path	root;
 	struct inode	*inode; /* path.dentry.d_inode */
 	unsigned int	flags;
-	unsigned	seq, m_seq;
+	unsigned	seq, m_seq, r_seq;
 	int		last_type;
 	unsigned	depth;
 	int		total_link_count;
@@ -508,6 +508,7 @@ struct nameidata {
 	struct inode	*link_inode;
 	unsigned	root_seq;
 	int		dfd;
+	char		*dpathbuf;
 } __randomize_layout;
 
 static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
@@ -530,6 +531,7 @@ static void restore_nameidata(void)
 		old->total_link_count = now->total_link_count;
 	if (now->stack != now->internal)
 		kfree(now->stack);
+	kfree(now->dpathbuf);
 }
 
 static int __nd_alloc_stack(struct nameidata *nd)
@@ -580,6 +582,22 @@ static inline int nd_alloc_stack(struct nameidata *nd)
 	return __nd_alloc_stack(nd);
 }
 
+static inline int nd_alloc_dpathbuf(struct nameidata *nd)
+{
+	if (unlikely(!nd->dpathbuf)) {
+		if (nd->flags & LOOKUP_RCU) {
+			nd->dpathbuf = kmalloc(PATH_MAX, GFP_ATOMIC);
+			if (unlikely(!nd->dpathbuf))
+				return -ECHILD;
+		} else {
+			nd->dpathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+			if (unlikely(!nd->dpathbuf))
+				return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
 static void drop_links(struct nameidata *nd)
 {
 	int i = nd->depth;
@@ -1738,18 +1756,40 @@ static inline int may_lookup(struct nameidata *nd)
 static inline int handle_dots(struct nameidata *nd, int type)
 {
 	if (type == LAST_DOTDOT) {
-		/*
-		 * AT_BENEATH resolving ".." is not currently safe -- races can cause
-		 * our parent to have moved outside of the root and us to skip over it.
-		 */
-		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)))
-			return -EXDEV;
+		int error = 0;
+
 		if (!nd->root.mnt)
 			set_root(nd);
-		if (nd->flags & LOOKUP_RCU) {
-			return follow_dotdot_rcu(nd);
-		} else
-			return follow_dotdot(nd);
+		if (nd->flags & LOOKUP_RCU)
+			error = follow_dotdot_rcu(nd);
+		else
+			error = follow_dotdot(nd);
+		if (error)
+			return error;
+
+		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
+			char *pathptr;
+			bool m_retry = read_seqretry(&mount_lock, nd->m_seq);
+			bool r_retry = read_seqretry(&rename_lock, nd->r_seq);
+
+			/* Racing rename(2) or MS_MOVE? */
+			if (likely(!m_retry && !r_retry))
+				return 0;
+			if (m_retry && !(nd->flags & LOOKUP_RCU))
+				nd->m_seq = read_seqbegin(&mount_lock);
+			if (r_retry)
+				nd->r_seq = read_seqbegin(&rename_lock);
+
+			error = nd_alloc_dpathbuf(nd);
+			if (error)
+				return error;
+			pathptr = __d_path(&nd->path, &nd->root, nd->dpathbuf, PATH_MAX);
+			if (unlikely(!pathptr))
+				/* Breakout -- go back to root! */
+				return nd_jump_root(nd);
+			if (unlikely(IS_ERR(pathptr)))
+				return PTR_ERR(pathptr);
+		}
 	}
 	return 0;
 }
@@ -2279,6 +2319,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags | LOOKUP_JUMPED | LOOKUP_PARENT;
 	nd->depth = 0;
+
+	nd->m_seq = read_seqbegin(&mount_lock);
+	if (unlikely(flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)))
+		nd->r_seq = read_seqbegin(&rename_lock);
+
 	if (flags & LOOKUP_ROOT) {
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
@@ -2289,7 +2334,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 		if (flags & LOOKUP_RCU) {
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			nd->root_seq = nd->seq;
-			nd->m_seq = read_seqbegin(&mount_lock);
 		} else {
 			path_get(&nd->path);
 		}
@@ -2300,7 +2344,6 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.mnt = NULL;
 	nd->path.dentry = NULL;
 
-	nd->m_seq = read_seqbegin(&mount_lock);
 	if (unlikely(flags & (LOOKUP_CHROOT | LOOKUP_XDEV))) {
 		error = dirfd_path_init(nd);
 		if (unlikely(error))
@@ -2407,7 +2450,7 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 		    struct path *path, struct path *root)
 {
 	int retval;
-	struct nameidata nd;
+	struct nameidata nd = {};
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 	if (unlikely(root)) {
@@ -2450,7 +2493,7 @@ static struct filename *filename_parentat(int dfd, struct filename *name,
 				struct qstr *last, int *type)
 {
 	int retval;
-	struct nameidata nd;
+	struct nameidata nd = {};
 
 	if (IS_ERR(name))
 		return name;
@@ -2779,7 +2822,7 @@ static int
 filename_mountpoint(int dfd, struct filename *name, struct path *path,
 			unsigned int flags)
 {
-	struct nameidata nd;
+	struct nameidata nd = {};
 	int error;
 	if (IS_ERR(name))
 		return PTR_ERR(name);
@@ -3626,7 +3669,7 @@ static struct file *path_openat(struct nameidata *nd,
 struct file *do_filp_open(int dfd, struct filename *pathname,
 		const struct open_flags *op)
 {
-	struct nameidata nd;
+	struct nameidata nd = {};
 	int flags = op->lookup_flags;
 	struct file *filp;
 
@@ -3643,7 +3686,7 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 		const char *name, const struct open_flags *op)
 {
-	struct nameidata nd;
+	struct nameidata nd = {};
 	struct file *file;
 	struct filename *filename;
 	int flags = op->lookup_flags | LOOKUP_ROOT;
-- 
2.19.0
