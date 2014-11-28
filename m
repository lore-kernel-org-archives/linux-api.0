From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH v2] userns: Avoid problems with negative groups
Date: Thu, 27 Nov 2014 23:22:06 -0600
Message-ID: <87r3wnrjb5.fsf_-_@x220.int.ebiederm.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<546A3942.5040906@schaufler-ca.com>
	<CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
	<CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
	<546A43CE.2030706@schaufler-ca.com>
	<87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
	<CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
	<87wq6frjcw.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87wq6frjcw.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Thu, 27 Nov 2014 23:21:03 -0600")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Classic unix permission checks have an interesting feature.  The group
permissions for a file can be set to less than the other permissions
on a file.  Occassionally this is used deliberately to give a certain
group of users fewer permissions than the default.

Overlooking negative groups has resulted in the permission checks for
setting up a group mapping in a user namespace to be too lax.  Tighten
the permission checks in new_idmap_permitted to ensure that mapping
uids and gids into user namespaces without privilege will not result
in new combinations of credentials being available to the users.

When setting mappings without privilege only the creator of the user
namespace is interesting as all other users that have CAP_SETUID over
the user namespace will also have CAP_SETUID over the user namespaces
parent.  So the scope of the unprivileged check is reduced to just
the case where cred->euid is the namespace creator.

For setting a uid mapping without privilege only euid is considered as
setresuid can set uid, suid and fsuid from euid without privielege
making any combination of uids possible with user namespaces already
possible without them.

For setting a gid mapping without privilege only egid on a credential
without supplementary groups is condsidered, as setresgid can set gid,
sgid and fsgid from egid without privilege.  The requirement for no
supplementary groups is because CAP_SETUID in a user namespace allows
supplementary groups to be cleared, which unfortunately means allowing
a credential with supplementary groups would allow new combinations
of credentials to exist, and thus would allow defeating negative
groups without permission.

setgroups is modified to fail not only when the group ids do not
map but also when there are no gid mappings at all, preventing
setgroups(0, NULL) from succeeding when gid mappings have not been
established.

This change should break userspace by the minimal amount needed
to fix this issue.

This should fix CVE-2014-8989.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/user_namespace.h | 10 ++++++++++
 kernel/groups.c                |  7 ++++++-
 kernel/uid16.c                 |  5 ++++-
 kernel/user_namespace.c        | 16 ++++++++++++----
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e95372654f09..26d5e8f5db97 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -46,6 +46,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return ns;
 }
 
+static inline bool gid_mapping_possible(const struct user_namespace *ns)
+{
+	return ns->gid_map.nr_extents != 0;
+}
+
 extern int create_user_ns(struct cred *new);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void free_user_ns(struct user_namespace *ns);
@@ -70,6 +75,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return &init_user_ns;
 }
 
+static inline bool gid_mapping_possible(const struct user_namespace *ns)
+{
+	return true;
+}
+
 static inline int create_user_ns(struct cred *new)
 {
 	return -EINVAL;
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f86cfa..302aa415158f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -220,14 +221,18 @@ out:
 
 SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!gid_mapping_possible(user_ns) ||
+	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
 
+	/* How do I alloc a negative gidsetsize??? */
+
 	group_info = groups_alloc(gidsetsize);
 	if (!group_info)
 		return -ENOMEM;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bbbceff..602c7de2aa11 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -13,6 +13,7 @@
 #include <linux/highuid.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 
 #include <asm/uaccess.h>
 
@@ -173,10 +174,12 @@ out:
 
 SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!gid_mapping_possible(user_ns) ||
+	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..b338c42d04fd 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,16 +812,24 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
+	const struct cred *cred = file->f_cred;
+
+	/* Allow mapping an id without CAP_SETUID and CAP_SETGID when
+	 * allowing the root of the user namespace CAP_SETUID or
+	 * CAP_SETGID restricted to just that id will not change the
+	 * set of credentials available that user.
+	 */
+	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
+	    uid_eq(ns->owner, cred->euid)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, cred->euid))
 				return true;
 		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
+			if (gid_eq(gid, cred->egid) &&
+			    (cred->group_info->ngroups == 0))
 				return true;
 		}
 	}
-- 
1.9.1
