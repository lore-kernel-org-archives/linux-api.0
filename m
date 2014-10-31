From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv2 4/7] cgroup: export cgroup_get() and cgroup_put()
Date: Fri, 31 Oct 2014 12:18:58 -0700
Message-ID: <1414783141-6947-5-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1414783141-6947-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1414783141-6947-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

move cgroup_get() and cgroup_put() into cgroup.h so that
they can be called from other places.

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 22 ++++++++++++++++++++++
 kernel/cgroup.c        | 22 ----------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 80ed6e0..4a0eb2d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -521,6 +521,28 @@ static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
 	return cgrp->root == &cgrp_dfl_root;
 }
 
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
+
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 50fa8e3..9c622b9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -284,12 +284,6 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	return cgroup_css(cgrp, ss);
 }
 
-/* convenient tests for these bits */
-static inline bool cgroup_is_dead(const struct cgroup *cgrp)
-{
-	return !(cgrp->self.flags & CSS_ONLINE);
-}
-
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
@@ -1002,22 +996,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
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
 /**
  * cgroup_refresh_child_subsys_mask - update child_subsys_mask
  * @cgrp: the target cgroup
-- 
2.1.0.rc2.206.gedb03e5
