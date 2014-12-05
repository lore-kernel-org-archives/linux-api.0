From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 1/8] kernfs: Add API to generate relative kernfs path
Date: Thu,  4 Dec 2014 17:55:43 -0800
Message-ID: <1417744550-6461-2-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1417744550-6461-1-git-send-email-adityakali@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The new function kernfs_path_from_node() generates and returns
kernfs path of a given kernfs_node relative to a given parent
kernfs_node.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/dir.c        | 195 +++++++++++++++++++++++++++++++++++++++++++------
 include/linux/kernfs.h |   3 +
 2 files changed, 177 insertions(+), 21 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1c77193..cb225a7 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -44,28 +44,159 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
-static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
-					      size_t buflen)
+/**
+ * kernfs_node_depth - compute depth of the kernfs node from root.
+ * The root node itself is considered to be at depth 0.
+ */
+static size_t kernfs_node_depth(struct kernfs_node *kn)
 {
-	char *p = buf + buflen;
+	size_t depth = 0;
+
+	BUG_ON(!kn);
+	while (kn->parent) {
+		depth++;
+		kn = kn->parent;
+	}
+	return depth;
+}
+
+/**
+ * kernfs_path_from_node_locked - find a relative path from @kn_from to @kn_to
+ * @kn_from: reference node of the path
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
+static char * __must_check kernfs_path_from_node_locked(
+	struct kernfs_node *kn_from,
+	struct kernfs_node *kn_to,
+	char *buf,
+	size_t buflen)
+{
+	char *p = buf;
+	struct kernfs_node *kn;
+	size_t depth_from = 0, depth_to, d;
 	int len;
 
-	*--p = '\0';
+	/* We atleast need 2 bytes to write "/\0". */
+	BUG_ON(buflen < 2);
 
-	do {
-		len = strlen(kn->name);
-		if (p - buf < len + 1) {
-			buf[0] = '\0';
-			p = NULL;
-			break;
+	/* Short-circuit the easy case - kn_to is the root node. */
+	if ((kn_from == kn_to) || (!kn_from && !kn_to->parent)) {
+		*p = '/';
+		*(p + 1) = '\0';
+		return p;
+	}
+
+	/* We can find the relative path only if both the nodes belong to the
+	 * same kernfs root.
+	 */
+	if (kn_from) {
+		BUG_ON(kernfs_root(kn_from) != kernfs_root(kn_to));
+		depth_from = kernfs_node_depth(kn_from);
+	}
+
+	depth_to = kernfs_node_depth(kn_to);
+
+	/* We compose path from left to right. So first write out all possible
+	 * "/.." strings needed to reach from 'kn_from' to the common ancestor.
+	 */
+	if (kn_from) {
+		while (depth_from > depth_to) {
+			len = strlen("/..");
+			if ((buflen - (p - buf)) < len + 1) {
+				/* buffer not big enough. */
+				buf[0] = '\0';
+				return NULL;
+			}
+			memcpy(p, "/..", len);
+			p += len;
+			*p = '\0';
+			--depth_from;
+			kn_from = kn_from->parent;
 		}
+
+		d = depth_to;
+		kn = kn_to;
+		while (depth_from < d) {
+			kn = kn->parent;
+			d--;
+		}
+
+		/* Now we have 'depth_from == depth_to' at this point. Add more
+		 * "/.."s until we reach common ancestor. In the worst case,
+		 * root node will be the common ancestor.
+		 */
+		while (depth_from > 0) {
+			/* If we reached common ancestor, stop. */
+			if (kn_from == kn)
+				break;
+			len = strlen("/..");
+			if ((buflen - (p - buf)) < len + 1) {
+				/* buffer not big enough. */
+				buf[0] = '\0';
+				return NULL;
+			}
+			memcpy(p, "/..", len);
+			p += len;
+			*p = '\0';
+			--depth_from;
+			kn_from = kn_from->parent;
+			kn = kn->parent;
+		}
+	}
+
+	/* Figure out how many bytes we need to write the path.
+	 */
+	d = depth_to;
+	kn = kn_to;
+	len = 0;
+	while (depth_from < d) {
+		/* Account for "/<name>". */
+		len += strlen(kn->name) + 1;
+		kn = kn->parent;
+		--d;
+	}
+
+	if ((buflen - (p - buf)) < len + 1) {
+		/* buffer not big enough. */
+		buf[0] = '\0';
+		return NULL;
+	}
+
+	/* We have enough space. Move 'p' ahead by computed length and start
+	 * writing node names into buffer.
+	 */
+	p += len;
+	*p = '\0';
+	d = depth_to;
+	kn = kn_to;
+	while (d > depth_from) {
+		len = strlen(kn->name);
 		p -= len;
 		memcpy(p, kn->name, len);
 		*--p = '/';
 		kn = kn->parent;
-	} while (kn && kn->parent);
+		--d;
+	}
 
-	return p;
+	return buf;
 }
 
 /**
@@ -92,26 +223,48 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
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
+	p = kernfs_path_from_node_locked(kn_root, kn, buf, buflen);
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
@@ -145,8 +298,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
 
-	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
-			       sizeof(kernfs_pr_cont_buf));
+	p = kernfs_path_from_node_locked(NULL, kn, kernfs_pr_cont_buf,
+					 sizeof(kernfs_pr_cont_buf));
 	if (p)
 		pr_cont("%s", p);
 	else
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 30faf79..3c2be75 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -258,6 +258,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 }
 
 int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
+char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
+					  struct kernfs_node *kn, char *buf,
+					  size_t buflen);
 char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
-- 
2.2.0.rc0.207.ga3a616c
