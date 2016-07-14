From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] kernel: add a helper to get an owning user namespace for
	a namespace
Date: Thu, 14 Jul 2016 11:20:16 -0700
Message-ID: <1468520419-28220-3-git-send-email-avagin@openvz.org>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468520419-28220-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Return -EPERM if an owning user namespace is outside of a process
current user namespace.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/linux/user_namespace.h |  7 +++++++
 kernel/user_namespace.c        | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a941b44..e416b76 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -76,6 +76,8 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
 extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
+
+struct ns_common *ns_get_owner(struct ns_common *ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -104,6 +106,11 @@ static inline bool userns_may_setgroups(const struct user_namespace *ns)
 {
 	return true;
 }
+
+static inline struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif /* _LINUX_USER_H */
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a5bc78c..6382e5e 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -994,6 +994,30 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return commit_creds(cred);
 }
 
+struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	const struct cred *cred = current_cred();
+	struct user_namespace *user_ns, *p;
+
+	user_ns = p = ns->user_ns;
+	if (user_ns == NULL) { /* ns is init_user_ns */
+		/* Unprivileged user should not know that it's init_user_ns. */
+		if (capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EPERM);
+	}
+
+	for (;;) {
+		if (p == cred->user_ns)
+			break;
+		if (p == &init_user_ns)
+			return ERR_PTR(-EPERM);
+		p = p->parent;
+	}
+
+	return &get_user_ns(user_ns)->ns;
+}
+
 const struct proc_ns_operations userns_operations = {
 	.name		= "user",
 	.type		= CLONE_NEWUSER,
-- 
2.5.5
