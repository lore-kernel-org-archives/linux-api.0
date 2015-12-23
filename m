From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 6/8] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Tue, 22 Dec 2015 22:23:27 -0600
Message-ID: <1450844609-9194-7-git-send-email-serge.hallyn@ubuntu.com>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1450844609-9194-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

This patch enables cgroup mounting inside userns when a process
as appropriate privileges. The cgroup filesystem mounted is
rooted at the cgroupns-root. Thus, in a container-setup, only
the hierarchy under the cgroupns-root is exposed inside the container.
This allows container management tools to run inside the containers
without depending on any global state.

Signed-off-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
Changelog:
	20151116 - Don't allow user namespaces to bind new subsystems
	20151118 - postpone the FS_USERNS_MOUNT flag until the
	           last patch, until we can convince ourselves it
		   is safe.
	20151207 - Switch to walking up the kernfs path from kn root.
		 - Group initialized variables
		 - Explain the capable(CAP_SYS_ADMIN) check
		 - Style fixes
---
 kernel/cgroup.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e85fbf9..99c4443 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1983,6 +1983,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 {
 	bool is_v2 = fs_type == &cgroup2_fs_type;
 	struct super_block *pinned_sb = NULL;
+	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
@@ -1991,6 +1992,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	int i;
 	bool new_sb;
 
+	get_cgroup_ns(ns);
+
+	/* Check if the caller has permission to mount. */
+	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
+		put_cgroup_ns(ns);
+		return ERR_PTR(-EPERM);
+	}
+
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
 	 * linking each css_set to its tasks and fix up all existing tasks.
@@ -2106,6 +2115,16 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * We know this subsystem has not yet been bound.  Users in a non-init
+	 * user namespace may only mount hierarchies with no bound subsystems,
+	 * i.e. 'none,name=user1'
+	 */
+	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
 		ret = -ENOMEM;
@@ -2124,12 +2143,30 @@ out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ns);
 		return ERR_PTR(ret);
+	}
 out_mount:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
 			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
 			      &new_sb);
+
+	/*
+	 * In non-init cgroup namespace, instead of root cgroup's
+	 * dentry, we return the dentry corresponding to the
+	 * cgroupns->root_cgrp.
+	 */
+	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
+		struct dentry *nsdentry;
+		struct cgroup *cgrp;
+
+		cgrp = cset_cgroup_from_root(ns->root_cset, root);
+		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
+		dput(dentry);
+		dentry = nsdentry;
+	}
+
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
 
@@ -2142,6 +2179,7 @@ out_mount:
 		deactivate_super(pinned_sb);
 	}
 
+	put_cgroup_ns(ns);
 	return dentry;
 }
 
-- 
1.7.9.5
