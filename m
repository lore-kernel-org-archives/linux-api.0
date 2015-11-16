From: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 4/8] cgroup: export cgroup_get() and cgroup_put()
Date: Mon, 16 Nov 2015 13:51:41 -0600
Message-ID: <1447703505-29672-5-git-send-email-serge@hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447703505-29672-1-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

move cgroup_get() and cgroup_put() into cgroup.h so that
they can be called from other places.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 include/linux/cgroup.h |   21 +++++++++++++++++++++
 kernel/cgroup.c        |   22 ----------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 29f0b02..99096be 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -231,6 +231,27 @@ void css_task_iter_end(struct css_task_iter *it);
 #define css_for_each_descendant_post(pos, css)				\
 	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
 	     (pos) = css_next_descendant_post((pos), (css)))
+/* convenient tests for these bits */
+static inline bool cgroup_is_dead(const struct cgroup *cgrp)
+{
+	return !(cgrp->self.flags & CSS_ONLINE);
+}
+
+static inline void cgroup_get(struct cgroup *cgrp)
+{
+	WARN_ON_ONCE(cgroup_is_dead(cgrp));
+	css_get(&cgrp->self);
+}
+
+static inline bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
+static inline void cgroup_put(struct cgroup *cgrp)
+{
+	css_put(&cgrp->self);
+}
 
 /**
  * cgroup_taskset_for_each - iterate cgroup_taskset
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e29c346..e972259 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -417,28 +417,6 @@ out_unlock:
 	return css;
 }
 
-/* convenient tests for these bits */
-static inline bool cgroup_is_dead(const struct cgroup *cgrp)
-{
-	return !(cgrp->self.flags & CSS_ONLINE);
-}
-
-static void cgroup_get(struct cgroup *cgrp)
-{
-	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
-}
-
-static bool cgroup_tryget(struct cgroup *cgrp)
-{
-	return css_tryget(&cgrp->self);
-}
-
-static void cgroup_put(struct cgroup *cgrp)
-{
-	css_put(&cgrp->self);
-}
-
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
-- 
1.7.9.5
