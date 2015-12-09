From: serge.hallyn@ubuntu.com
Subject: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed,  9 Dec 2015 13:28:54 -0600
Message-ID: <1449689341-28742-2-git-send-email-serge.hallyn@ubuntu.com>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: adityakali@google.com, tj@kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com, gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>
List-Id: linux-api@vger.kernel.org

From: Aditya Kali <adityakali@google.com>

The new function kernfs_path_from_node() generates and returns kernfs
path of a given kernfs_node relative to a given parent kernfs_node.

Signed-off-by: Aditya Kali <adityakali@google.com>
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
Changelog 20151125:
  - Fully-wing multilinecomments
  - Rework kernfs_path_from_node_locked() logic
  - Replace BUG_ONs with returning NULL
  - Use a const char* for /.. and precalculate its size
Changelog 20151130:
  - Update kernfs_path_from_node_locked comment
Changelog 20151208:
  - kernfs_node_distance:
    * Remove BUG_ON(NULL)s
    * Rename kernfs_node_distance to kernfs_depth
  - kernfs_common-ancestor:
    * Remove useless checks for depth == 0
    * Add check to ensure nodes are from same root
  - kernfs_path_from_node_locked:
    * Remove needless __must_check
    * Put p;len on its own decl line.
    * Fix wrong WARN_ONCE usage
---
 fs/kernfs/dir.c        |  177 ++++++++++++++++++++++++++++++++++++++++--------
 include/linux/kernfs.h |    3 +
 2 files changed, 153 insertions(+), 27 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 91e0045..d1a001a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -44,28 +44,129 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
-static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
-					      size_t buflen)
+/* kernfs_node_depth - compute depth from @from to @to */
+static size_t kernfs_depth(struct kernfs_node *from, struct kernfs_node *to)
 {
-	char *p = buf + buflen;
-	int len;
+	size_t depth = 0;
 
-	*--p = '\0';
+	while (to->parent && to != from) {
+		depth++;
+		to = to->parent;
+	}
+	return depth;
+}
 
-	do {
-		len = strlen(kn->name);
-		if (p - buf < len + 1) {
-			buf[0] = '\0';
-			p = NULL;
-			break;
-		}
-		p -= len;
-		memcpy(p, kn->name, len);
-		*--p = '/';
-		kn = kn->parent;
-	} while (kn && kn->parent);
+static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
+		struct kernfs_node *b)
+{
+	size_t da, db;
+	struct kernfs_root *ra = kernfs_root(a), *rb = kernfs_root(b);
 
-	return p;
+	if (ra != rb)
+		return NULL;
+
+	da = kernfs_depth(ra->kn, a);
+	db = kernfs_depth(rb->kn, b);
+
+	while (da > db) {
+		a = a->parent;
+		da--;
+	}
+	while (db > da) {
+		b = b->parent;
+		db--;
+	}
+
+	/* worst case b and a will be the same at root */
+	while (b != a) {
+		b = b->parent;
+		a = a->parent;
+	}
+
+	return a;
+}
+
+/**
+ * kernfs_path_from_node_locked - find a pseudo-absolute path to @kn_to,
+ * where kn_from is treated as root of the path.
+ * @kn_from: kernfs node which should be treated as root for the path
+ * @kn_to: kernfs node to which path is needed
+ * @buf: buffer to copy the path into
+ * @buflen: size of @buf
+ *
+ * We need to handle couple of scenarios here:
+ * [1] when @kn_from is an ancestor of @kn_to at some level
+ * kn_from: /n1/n2/n3
+ * kn_to:   /n1/n2/n3/n4/n5
+ * result:  /n4/n5
+ *
+ * [2] when @kn_from is on a different hierarchy and we need to find common
+ * ancestor between @kn_from and @kn_to.
+ * kn_from: /n1/n2/n3/n4
+ * kn_to:   /n1/n2/n5
+ * result:  /../../n5
+ * OR
+ * kn_from: /n1/n2/n3/n4/n5   [depth=5]
+ * kn_to:   /n1/n2/n3         [depth=3]
+ * result:  /../..
+ */
+static char *
+kernfs_path_from_node_locked(struct kernfs_node *kn_to,
+			     struct kernfs_node *kn_from, char *buf,
+			     size_t buflen)
+{
+	char *p = buf;
+	struct kernfs_node *kn, *common;
+	const char parent_str[] = "/..";
+	int i;
+	size_t depth_from, depth_to, len = 0, nlen = 0;
+	size_t plen = sizeof(parent_str) - 1;
+
+	/* We atleast need 2 bytes to write "/\0". */
+	if (buflen < 2)
+		return NULL;
+
+	if (!kn_from)
+		kn_from = kernfs_root(kn_to)->kn;
+
+	if (kn_from == kn_to) {
+		*p = '/';
+		*(++p) = '\0';
+		return buf;
+	}
+
+	common = kernfs_common_ancestor(kn_from, kn_to);
+	if (WARN_ON(!common))
+		return NULL;
+
+	depth_to = kernfs_depth(common, kn_to);
+	depth_from = kernfs_depth(common, kn_from);
+
+	for (i = 0; i < depth_from; i++) {
+		if (len + plen + 1 > buflen)
+			return NULL;
+		strcpy(p, parent_str);
+		p += plen;
+		len += plen;
+	}
+
+	/* Calculate how many bytes we need for the rest */
+	for (kn = kn_to; kn != common; kn = kn->parent)
+		nlen += strlen(kn->name) + 1;
+
+	if (len + nlen + 1 > buflen)
+		return NULL;
+
+	p += nlen;
+	*p = '\0';
+	for (kn = kn_to; kn != common; kn = kn->parent) {
+		nlen = strlen(kn->name);
+		p -= nlen;
+		memcpy(p, kn->name, nlen);
+		*(--p) = '/';
+	}
+
+	return buf;
 }
 
 /**
@@ -115,26 +216,48 @@ size_t kernfs_path_len(struct kernfs_node *kn)
 }
 
 /**
- * kernfs_path - build full path of a given node
+ * kernfs_path_from_node - build path of node @kn relative to @kn_root.
+ * @kn_root: parent kernfs_node relative to which we need to build the path
  * @kn: kernfs_node of interest
- * @buf: buffer to copy @kn's name into
+ * @buf: buffer to copy @kn's path into
  * @buflen: size of @buf
  *
- * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
- * path is built from the end of @buf so the returned pointer usually
- * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
+ * Builds and returns @kn's path relative to @kn_root. @kn_root and @kn must
+ * be on the same kernfs-root. If @kn_root is not parent of @kn, then a relative
+ * path (which includes '..'s) as needed to reach from @kn_root to @kn is
+ * returned.
+ * The path may be built from the end of @buf so the returned pointer may not
+ * match @buf.  If @buf isn't long enough, @buf is nul terminated
  * and %NULL is returned.
  */
-char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+char *kernfs_path_from_node(struct kernfs_node *kn_root, struct kernfs_node *kn,
+			    char *buf, size_t buflen)
 {
 	unsigned long flags;
 	char *p;
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
-	p = kernfs_path_locked(kn, buf, buflen);
+	p = kernfs_path_from_node_locked(kn, kn_root, buf, buflen);
 	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kernfs_path_from_node);
+
+/**
+ * kernfs_path - build full path of a given node
+ * @kn: kernfs_node of interest
+ * @buf: buffer to copy @kn's name into
+ * @buflen: size of @buf
+ *
+ * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
+ * path is built from the end of @buf so the returned pointer usually
+ * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
+ * and %NULL is returned.
+ */
+char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
+{
+	return kernfs_path_from_node(NULL, kn, buf, buflen);
+}
 EXPORT_SYMBOL_GPL(kernfs_path);
 
 /**
@@ -168,8 +291,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
 
-	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
-			       sizeof(kernfs_pr_cont_buf));
+	p = kernfs_path_from_node_locked(kn, NULL, kernfs_pr_cont_buf,
+					 sizeof(kernfs_pr_cont_buf));
 	if (p)
 		pr_cont("%s", p);
 	else
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 5d4e9c4..d025ebd 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -267,6 +267,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 
 int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
 size_t kernfs_path_len(struct kernfs_node *kn);
+char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
+					  struct kernfs_node *kn, char *buf,
+					  size_t buflen);
 char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
-- 
1.7.9.5
