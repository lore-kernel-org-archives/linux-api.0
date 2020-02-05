From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 2/6] cgroup: add cgroup_get_from_file() helper
Date: Wed,  5 Feb 2020 14:26:19 +0100
Message-ID: <20200205132623.670015-3-christian.brauner@ubuntu.com>
References: <20200205132623.670015-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205132623.670015-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a helper cgroup_get_from_file(). The helper will be used in
subsequent patches to retrieve a cgroup while holding a reference to the
struct file it was taken from.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Acked-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v1 */
patch not present

/* v2 */
patch not present

/* v3 */
Link: https://lore.kernel.org/r/20200117002143.15559-3-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
patch introduced
- Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
  - split cgroup_get_from_file() changes into separate commmit

/* v4 */
Link: https://lore.kernel.org/r/20200117181219.14542-3-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
unchanged

/* v5 */
Link: https://lore.kernel.org/r/20200121154844.411-3-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
unchanged

/* v6 */
unchanged
- Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>:
  - add Acked-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f84177e2065..7c1c8677849e 100644
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
