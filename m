From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v5 2/6] cgroup: add cgroup_get_from_file() helper
Date: Tue, 21 Jan 2020 16:48:40 +0100
Message-ID: <20200121154844.411-3-christian.brauner@ubuntu.com>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200121154844.411-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian.brauner@ubuntu.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a helper cgroup_get_from_file(). The helper will be used in
subsequent patches to retrieve a cgroup while holding a reference to the
struct file it was taken from.

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
Link: https://lore.kernel.org/r/20200117002143.15559-3-christian.brauner@ubuntu.com
patch introduced
- Tejun Heo <tj@kernel.org>:
  - split cgroup_get_from_file() changes into separate commmit

/* v4 */
Link: https://lore.kernel.org/r/20200117181219.14542-3-christian.brauner@ubuntu.com
unchanged

/* v5 */
unchanged
---
 kernel/cgroup/cgroup.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7b98cc389dae..9b3241d67592 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5875,6 +5875,24 @@ void cgroup_fork(struct task_struct *child)
 	INIT_LIST_HEAD(&child->cg_list);
 }
 
+static struct cgroup *cgroup_get_from_file(struct file *f)
+{
+	struct cgroup_subsys_state *css;
+	struct cgroup *cgrp;
+
+	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
+	if (IS_ERR(css))
+		return ERR_CAST(css);
+
+	cgrp = css->cgroup;
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return ERR_PTR(-EBADF);
+	}
+
+	return cgrp;
+}
+
 /**
  * cgroup_can_fork - called on a new task before the process is exposed
  * @child: the task in question.
@@ -6163,7 +6181,6 @@ EXPORT_SYMBOL_GPL(cgroup_get_from_path);
  */
 struct cgroup *cgroup_get_from_fd(int fd)
 {
-	struct cgroup_subsys_state *css;
 	struct cgroup *cgrp;
 	struct file *f;
 
@@ -6171,17 +6188,8 @@ struct cgroup *cgroup_get_from_fd(int fd)
 	if (!f)
 		return ERR_PTR(-EBADF);
 
-	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
+	cgrp = cgroup_get_from_file(f);
 	fput(f);
-	if (IS_ERR(css))
-		return ERR_CAST(css);
-
-	cgrp = css->cgroup;
-	if (!cgroup_on_dfl(cgrp)) {
-		cgroup_put(cgrp);
-		return ERR_PTR(-EBADF);
-	}
-
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
-- 
2.25.0
