From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v5 4/6] cgroup: add cgroup_may_write() helper
Date: Tue, 21 Jan 2020 16:48:42 +0100
Message-ID: <20200121154844.411-5-christian.brauner@ubuntu.com>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200121154844.411-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian.brauner@ubuntu.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a cgroup_may_write() helper which we can use in the
CLONE_INTO_CGROUP patch series to verify that we can write to the
destination cgroup.

Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
patch not present

/* v2 */
patch not present

/* v3 */
patch not present

/* v4 */
Link: https://lore.kernel.org/r/20200117181219.14542-5-christian.brauner@ubuntu.com
patch introduced

/* v5 */
unchanged
---
 kernel/cgroup/cgroup.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ce2d5b8aa19f..636fe3d46d2d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4649,13 +4649,28 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 	return 0;
 }
 
+static int cgroup_may_write(const struct cgroup *cgrp, struct super_block *sb)
+{
+	int ret;
+	struct inode *inode;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
+	if (!inode)
+		return -ENOMEM;
+
+	ret = inode_permission(inode, MAY_WRITE);
+	iput(inode);
+	return ret;
+}
+
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
 					 struct super_block *sb)
 {
 	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
-	struct inode *inode;
 	int ret;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -4665,12 +4680,7 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 		com_cgrp = cgroup_parent(com_cgrp);
 
 	/* %current should be authorized to migrate to the common ancestor */
-	inode = kernfs_get_inode(sb, com_cgrp->procs_file.kn);
-	if (!inode)
-		return -ENOMEM;
-
-	ret = inode_permission(inode, MAY_WRITE);
-	iput(inode);
+	ret = cgroup_may_write(com_cgrp, sb);
 	if (ret)
 		return ret;
 
-- 
2.25.0
