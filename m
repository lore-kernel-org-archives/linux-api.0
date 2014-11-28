From: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH] userns: Disallow setgroups unless the gid_map writer is privileged
Date: Fri, 28 Nov 2014 14:53:20 -0800
Message-ID: <81ba656ffbdc62a7f7e94ad17f0238ee063fe6b3.1417214430.git.luto@amacapital.net>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, kenton@sandstorm.io, Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Classic unix permission checks have an interesting feature.  The
group permissions for a file can be set to less than the other
permissions on a file.  Occasionally this is used deliberately to
give a certain group of users fewer permissions than the default.

User namespaces break this usage.  Groups set in rgid or egid are
unaffected because an unprivileged user namespace creator can only
map a single group, so setresgid inside and outside the namespace
have the same effect.  However, an unprivileged user namespace
creator can currently use setgroups(2) to drop all supplementary
groups, so, if a supplementary group denies access to some resource,
user namespaces can be used to bypass that restriction.

To fix this issue without unduly breaking existing user code, this
introduces a new user namespace flag USERNS_SETGROUPS_ALLOWED.  If
that flag is not set, then setgroups(2) will fail regardless of the
caller's capabilities.

USERNS_SETGROUPS_ALLOWED is cleared in a new user namespace.  By
default, if the writer of gid_map has CAP_SETGID in the parent
userns and the parent userns has USERNS_SETGROUPS_ALLOWED, then the
USERNS_SETGROUPS_ALLOWED will be set in the child.

While it could be safe to set USERNS_SETGROUPS_ALLOWED if the user
namespace creator has no supplementary groups, doing so could be
surprising and could have unpleasant interactions with setns(2).

The default behavior can be overridden by adding a line of the form
"setgroups allow" or "setgroups deny" to gid_map.  The former will
return -EPERM if the caller is not permitted to set
USERNS_SETGROUPS_ALLOWED, and the latter will clear
USERNS_SETGROUPS_ALLOWED even if the flag would otherwise be set.

This change should break userspace by the minimal amount needed to
fix this issue.  Any application that uses newgidmap(1) should be
unaffected by this fix, and unprivileged users that create user
namespaces to manipulate mounts or sandbox themselves will also be
unaffected unless they try to use setgroups(2).

This should fix CVE-2014-8989.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Eric, this is an alternative to your patch.  I think it will cause
less breakage, and it will keep unprivileged user namespaces
more or less fully functional.

Kenton, I think that neither run-bundle nor supervisor-main will be
broken by this patch.

 include/linux/user_namespace.h |  3 +++
 kernel/groups.c                |  3 +++
 kernel/user.c                  |  1 +
 kernel/user_namespace.c        | 36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e95372654f09..a74c1f3d44fe 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -17,6 +17,8 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 	} extent[UID_GID_MAP_MAX_EXTENTS];
 };
 
+#define USERNS_SETGROUPS_ALLOWED 1
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -27,6 +29,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	unsigned int		flags;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f86cfa..e27433809978 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -223,6 +224,8 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
+	if (!(current_user_ns()->flags & USERNS_SETGROUPS_ALLOWED))
+		return -EPERM;
 	if (!ns_capable(current_user_ns(), CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
diff --git a/kernel/user.c b/kernel/user.c
index 4efa39350e44..f8cdb1ec6049 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.flags = USERNS_SETGROUPS_ALLOWED,
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..6e7b9ee5bddc 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -600,6 +600,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	unsigned long page = 0;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret = -EINVAL;
+	unsigned int gid_flags = 0;
+	bool seen_explicit_gid_flag = false;
 
 	/*
 	 * The id_map_mutex serializes all writes to any given map.
@@ -633,6 +635,19 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
 		goto out;
 
+	/* Deal with supplementary groups. */
+	if (map == &ns->gid_map) {
+		/*
+		 * By default, setgroups is allowed inside the userns
+		 * if the writer has no supplementary groups (making
+		 * it useless) or if the writer is privileged.
+		 */
+		if ((ns->parent->flags & USERNS_SETGROUPS_ALLOWED) &&
+		    file_ns_capable(file, ns->parent, CAP_SETGID) &&
+		    ns_capable(ns->parent, CAP_SETGID))
+			gid_flags = USERNS_SETGROUPS_ALLOWED;
+	}
+
 	/* Get a buffer */
 	ret = -ENOMEM;
 	page = __get_free_page(GFP_TEMPORARY);
@@ -667,6 +682,25 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 				next_line = NULL;
 		}
 
+		/* Is this line a gid_map option? */
+		if (map == &ns->gid_map) {
+			if (!strcmp(pos, "setgroups deny")) {
+				if (seen_explicit_gid_flag)
+					goto out;
+				seen_explicit_gid_flag = 1;
+				gid_flags = 0;
+				continue;
+			} else if (!strcmp(pos, "setgroups allow")) {
+				if (seen_explicit_gid_flag)
+					goto out;
+				if (!(gid_flags & USERNS_SETGROUPS_ALLOWED)) {
+					ret = -EPERM;
+					goto out;
+				}
+				continue;
+			}
+		}
+
 		pos = skip_spaces(pos);
 		extent->first = simple_strtoul(pos, &pos, 10);
 		if (!isspace(*pos))
@@ -746,6 +780,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		new_map.nr_extents*sizeof(new_map.extent[0]));
 	smp_wmb();
 	map->nr_extents = new_map.nr_extents;
+	if (map == &ns->gid_map)
+		ns->flags |= gid_flags;
 
 	*ppos = count;
 	ret = count;
-- 
1.9.3

