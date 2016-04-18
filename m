From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/2] cgroup_show_path: use a new helper to get current cgns
 css_set
Date: Mon, 18 Apr 2016 00:29:05 -0500
Message-ID: <20160418052905.GA3848@mail.hallyn.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
 <20160418041126.GA424@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418041126.GA424-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Since we're getting current's cgroup namespace info, and are not
modifying it, we can use rcu_read_lock() instead of cgroup_mutex.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9a0d7b3..cd8269e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1215,6 +1215,41 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_free_root(root);
 }
 
+/*
+ * look up cgroup associated with current task's cgroup namespace on the
+ * specified hierarchy
+ */
+static struct cgroup *
+current_cgns_cgroup_from_root(struct cgroup_root *root)
+{
+	struct cgroup *res = NULL;
+	struct css_set *css;
+
+	lockdep_assert_held(&css_set_lock);
+
+	rcu_read_lock();
+
+	css = current->nsproxy->cgroup_ns->root_cset;
+	if (cset == &init_css_set) {
+		res = &root->cgrp;
+	} else {
+		struct cgrp_cset_link *link;
+
+		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+			struct cgroup *c = link->cgrp;
+
+			if (c->root == root) {
+				res = c;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	BUG_ON(!res);
+	return res;
+}
+
 /* look up cgroup associated with given css_set on the specified hierarchy */
 static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
@@ -1598,13 +1633,11 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 {
 	int len = 0, ret = 0;
 	char *buf = NULL;
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
 	struct cgroup *ns_cgroup;
 
-	mutex_lock(&cgroup_mutex);
 	spin_lock_bh(&css_set_lock);
-	ns_cgroup = cset_cgroup_from_root(ns->root_cset, kf_cgroot);
+	ns_cgroup = current_cgns_cgroup_from_root(kf_cgroot);
 	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, NULL, 0);
 	if (len > 0)
 		buf = kmalloc(len + 1, GFP_ATOMIC);
@@ -1612,7 +1645,6 @@ static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 		ret = kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, len + 1);
 
 	spin_unlock_bh(&css_set_lock);
-	mutex_unlock(&cgroup_mutex);
 
 	if (len <= 0)
 		return len;
-- 
2.7.4
