From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Mon, 30 Nov 2015 20:08:07 -0600
Message-ID: <20151201020807.GA29487@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
 <20151127052511.GA25490@mail.hallyn.com>
 <20151130151147.GG3535@mtj.duckdns.org>
 <20151130183758.GA25433@mail.hallyn.com>
 <20151130225318.GD9039@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151130225318.GD9039-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 05:53:18PM -0500, Tejun Heo wrote:
> Hello, Serge.
> 
> On Mon, Nov 30, 2015 at 12:37:58PM -0600, Serge E. Hallyn wrote:
> > > Yeah, I agree but the name is kinda misleading tho.  The output isn't
> > > really a relative path but rather absolute path against the specified
> > > root.  Maybe updating the function and parameter names would be
> > > helpful?
> > > 
> > 
> > Ok - updating the comment is simple enough.  Though the name/params
> > kernfs_path_from_node_locked(from, to) still seem to make sense.  Would
> > you prefer something like kernfs_absolute_path_from node_locked()?  I
> > hesitate to call 'from' 'root' since kernfs_root is a thing and this
> > is not that.
> 
> Hmmm... I see.  Let's just make sure that the comment is clear about
> the fact that it calculates (pseudo) absolute path rather than
> relative path.
> 
> Thanks.

Ok, new patch follows (and is pushed at
 https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/log/?h=2015-11-30/cgroupns)

[PATCH 1/7] kernfs: Add API to generate relative kernfs path

The new function kernfs_path_from_node() generates and returns kernfs
path of a given kernfs_node relative to a given parent kernfs_node.

Changelog 20151125:
  - Fully-wing multilinecomments
  - Rework kernfs_path_from_node_locked() logic
  - Replace BUG_ONs with returning NULL
  - Use a const char* for /.. and precalculate its size
Changelog 20151130:
  - Update kernfs_path_from_node_locked comment

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/dir.c        | 182 +++++++++++++++++++++++++++++++++++++++++--------
 include/linux/kernfs.h |   3 +
 2 files changed, 158 insertions(+), 27 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 91e0045..7cd4bb4 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -44,28 +44,134 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
 	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
 }
 
-static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
-					      size_t buflen)
+/* kernfs_node_depth - compute depth from @from to @to */
+static size_t kernfs_node_distance(struct kernfs_node *from, struct kernfs_node *to)
 {
-	char *p = buf + buflen;
-	int len;
+	size_t depth = 0;
 
-	*--p = '\0';
+	BUG_ON(!to);
+	BUG_ON(!from);
 
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
+	while (to->parent && to != from) {
+		depth++;
+		to = to->parent;
+	}
+	return depth;
+}
 
-	return p;
+static struct kernfs_node *kernfs_common_ancestor(struct kernfs_node *a,
+		struct kernfs_node *b)
+{
+	size_t da = kernfs_node_distance(kernfs_root(a)->kn, a);
+	size_t db = kernfs_node_distance(kernfs_root(b)->kn, b);
+
+	if (da == 0)
+		return a;
+	if (db == 0)
+		return b;
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
+__must_check kernfs_path_from_node_locked(struct kernfs_node *kn_from,
+					  struct kernfs_node *kn_to, char *buf,
+					  size_t buflen)
+{
+	char *p = buf;
+	struct kernfs_node *kn, *common;
+	const char parent_str[] = "/..";
+	int i;
+	size_t depth_from, depth_to, len = 0, nlen = 0,
+	       plen = sizeof(parent_str) - 1;
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
+	if (!common) {
+		WARN_ONCE("%s: kn_from and kn_to on different roots\n",
+			__func__);
+		return NULL;
+	}
+
+	depth_to = kernfs_node_distance(common, kn_to);
+	depth_from = kernfs_node_distance(common, kn_from);
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
@@ -115,26 +221,48 @@ size_t kernfs_path_len(struct kernfs_node *kn)
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
@@ -168,8 +296,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 
 	spin_lock_irqsave(&kernfs_rename_lock, flags);
 
-	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
-			       sizeof(kernfs_pr_cont_buf));
+	p = kernfs_path_from_node_locked(NULL, kn, kernfs_pr_cont_buf,
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
2.5.0
