From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Thu, 3 Dec 2015 16:47:06 -0600
Message-ID: <20151203224706.GA19971@mail.hallyn.com>
References: <20151127051745.GA24521@mail.hallyn.com>
 <20151130150938.GF3535@mtj.duckdns.org>
 <20151201040704.GA31067@mail.hallyn.com>
 <20151201164649.GD12922@mtj.duckdns.org>
 <20151201215853.GA9153@mail.hallyn.com>
 <20151202165312.GB19878@mtj.duckdns.org>
 <20151202165637.GA20840@mail.hallyn.com>
 <20151202165839.GD19878@mtj.duckdns.org>
 <20151202170239.GA21009@mail.hallyn.com>
 <20151202170551.GE19878@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151202170551.GE19878-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 02, 2015 at 12:05:51PM -0500, Tejun Heo wrote:
> On Wed, Dec 02, 2015 at 11:02:39AM -0600, Serge E. Hallyn wrote:
> > On Wed, Dec 02, 2015 at 11:58:39AM -0500, Tejun Heo wrote:
> > > On Wed, Dec 02, 2015 at 10:56:37AM -0600, Serge E. Hallyn wrote:
> > > > Can it be flushed when we know that the cgroup is being pinned by
> > > > a css_set?  (There's either a task or a cgroup_namespace pinning it
> > > > or we wouldn't get here)
> > > 
> > > Yeap, it can be flushed.  There's no ref coming out of cgroup to the
> > > vfs objects.
> > 
> > Ok, thanks.  Still seems to me to be more work to actually walk the
> > path ourselves, but I'll go that route and see what it looks like :)
> 
> I just dislike having two separate paths instantiating the same
> objects and would prefer doing it the same way userland would do if
> that isn't too complex but yeah it might turn out to be a lot more
> work.
> 
> Thanks a lot!

Here's a patch to make that change.  Seems to be working for me.  If it
looks ok I can fold it into the prevoius patches and resend the new set.

PATCH 1/1] kernfs_obtain_root: switch to walking the path [fold up]

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c | 80 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index cc41fe1..027f4ca 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -14,6 +14,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/namei.h>
 
 #include "kernfs-internal.h"
 
@@ -62,6 +63,27 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
 	return NULL;
 }
 
+/*
+ * find the next ancestor in the path down to @child, where @parent was the
+ * parent whose child we want to find.
+ *
+ * Say the path is /a/b/c/d.  @child is d, @parent is NULL.  We return the root
+ * node.  If @parent is b, then we return the node for c.
+ * Passing in d as @parent is not ok.
+ */
+static struct kernfs_node *
+find_kn_ancestor_below(struct kernfs_node *child, struct kernfs_node *parent)
+{
+	BUG_ON(child == parent);
+
+	while (child->parent != parent) {
+		BUG_ON(!child->parent);
+		child = child->parent;
+	}
+
+	return child;
+}
+
 /**
  * kernfs_obtain_root - get a dentry for the given kernfs_node
  * @sb: the kernfs super_block
@@ -74,42 +96,34 @@ struct dentry *kernfs_obtain_root(struct super_block *sb,
 				  struct kernfs_node *kn)
 {
 	struct dentry *dentry;
-	struct inode *inode;
+	struct kernfs_node *knparent = NULL;
 
 	BUG_ON(sb->s_op != &kernfs_sops);
 
-	/* inode for the given kernfs_node should already exist. */
-	inode = kernfs_get_inode(sb, kn);
-	if (!inode) {
-		pr_debug("kernfs: could not get inode for '");
-		pr_cont_kernfs_path(kn);
-		pr_cont("'.\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	/* instantiate and link root dentry */
-	dentry = d_obtain_root(inode);
-	if (!dentry) {
-		pr_debug("kernfs: could not get dentry for '");
-		pr_cont_kernfs_path(kn);
-		pr_cont("'.\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/*
-	 * If this is a new dentry, set it up. We need kernfs_mutex because
-	 * this may be called by callers other than kernfs_fill_super.
-	 */
-	mutex_lock(&kernfs_mutex);
-	if (!dentry->d_fsdata) {
-		kernfs_get(kn);
-		dentry->d_fsdata = kn;
-	} else {
-		WARN_ON(dentry->d_fsdata != kn);
-	}
-	mutex_unlock(&kernfs_mutex);
-
-	return dentry;
+	dentry = dget(sb->s_root);
+	if (!kn->parent) // this is the root
+		return dentry;
+
+	knparent = find_kn_ancestor_below(kn, NULL);
+	BUG_ON(!knparent);
+
+	do {
+		struct dentry *dtmp;
+		struct kernfs_node *kntmp;
+
+		if (kn == knparent)
+			return dentry;
+		kntmp = find_kn_ancestor_below(kn, knparent);
+		BUG_ON(!kntmp);
+		dtmp = lookup_one_len(kntmp->name, dentry, strlen(kntmp->name));
+		dput(dentry);
+		if (IS_ERR(dtmp))
+			return dtmp;
+		knparent = kntmp;
+		dentry = dtmp;
+	} while (1);
+
+	// notreached
 }
 
 static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
-- 
2.5.0
