From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] cgroup: un-inline cgroup_path() and friends
Date: Fri, 11 Mar 2016 10:41:20 -0500
Message-ID: <1457710888-31182-3-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, pjt@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

They're trivial wrappers now but to support in-process resource
control, cgroup_path() and friends will need to access more of cgroup
internals.  Un-inline them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 31 +++++--------------------------
 kernel/cgroup.c        | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2162dca..4717f43 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -74,6 +74,11 @@ extern struct css_set init_css_set;
 #define cgroup_subsys_on_dfl(ss)						\
 	static_branch_likely(&ss ## _on_dfl_key)
 
+int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen);
+char * __must_check cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen);
+void pr_cont_cgroup_name(struct cgroup *cgrp);
+void pr_cont_cgroup_path(struct cgroup *cgrp);
+
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
@@ -522,32 +527,6 @@ static inline struct cgroup_subsys_state *seq_css(struct seq_file *seq)
 	return of_css(seq->private);
 }
 
-/*
- * Name / path handling functions.  All are thin wrappers around the kernfs
- * counterparts and can be called under any context.
- */
-
-static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
-{
-	return kernfs_name(cgrp->kn, buf, buflen);
-}
-
-static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
-					      size_t buflen)
-{
-	return kernfs_path(cgrp->kn, buf, buflen);
-}
-
-static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
-{
-	pr_cont_kernfs_name(cgrp->kn);
-}
-
-static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
-{
-	pr_cont_kernfs_path(cgrp->kn);
-}
-
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2297bf6..4c3c43e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -618,6 +618,27 @@ static int notify_on_release(const struct cgroup *cgrp)
 static void cgroup_release_agent(struct work_struct *work);
 static void check_for_release(struct cgroup *cgrp);
 
+int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
+{
+	return kernfs_name(cgrp->kn, buf, buflen);
+}
+
+char * __must_check cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen)
+{
+	return kernfs_path(cgrp->kn, buf, buflen);
+}
+EXPORT_SYMBOL_GPL(cgroup_path);
+
+void pr_cont_cgroup_name(struct cgroup *cgrp)
+{
+	pr_cont_kernfs_name(cgrp->kn);
+}
+
+void pr_cont_cgroup_path(struct cgroup *cgrp)
+{
+	pr_cont_kernfs_path(cgrp->kn);
+}
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
-- 
2.5.0
