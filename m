From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCHv2 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Sat, 15 Nov 2014 13:02:53 -0800
Message-ID: <311e7d2982ee36b7c5782dd47e2d589748ef3759.1416085112.git.josh@joshtriplett.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416085112.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416085112.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Currently, unprivileged processes (without CAP_SETGID) cannot call
setgroups at all.  In particular, processes with a set of supplementary
groups cannot further drop permissions without obtaining elevated
permissions first.

Allow unprivileged processes to call setgroups with a subset of their
current groups; only require CAP_SETGID to add a group the process does
not currently have.

Since some privileged programs (such as sudo) allow tests for
non-membership in a group, require no_new_privs to drop group
privileges.

The kernel already maintains the list of supplementary group IDs in
sorted order, and setgroups already needs to sort the new list, so this
just requires a linear comparison of the two sorted lists.

This moves the CAP_SETGID test from setgroups into set_current_groups.

Tested via the following test program:

void run_id(void)
{
    pid_t p = fork();
    switch (p) {
        case -1:
            err(1, "fork");
        case 0:
            execl("/usr/bin/id", "id", NULL);
            err(1, "exec");
        default:
            if (waitpid(p, NULL, 0) < 0)
                err(1, "waitpid");
    }
}

int main(void)
{
    gid_t list1[] = { 1, 2, 3, 4, 5 };
    gid_t list2[] = { 2, 3, 4 };
    run_id();
    if (setgroups(5, list1) < 0)
        err(1, "setgroups 1");
    run_id();
    if (setresgid(1, 1, 1) < 0)
        err(1, "setresgid");
    if (setresuid(1, 1, 1) < 0)
        err(1, "setresuid");
    run_id();
    if (setgroups(3, list2) < 0)
        err(1, "setgroups 2");
    run_id();
    if (setgroups(5, list1) < 0)
        err(1, "setgroups 3");
    run_id();

    return 0;
}

Without this patch, the test program gets EPERM from the second
setgroups call, after dropping root privileges.  With this patch, the
test program successfully drops groups 1 and 5, but then gets EPERM from
the third setgroups call, since that call attempts to add groups the
process does not currently have.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---
v2: Require no_new_privs.

 kernel/groups.c | 34 +++++++++++++++++++++++++++++++---
 kernel/uid16.c  |  2 --
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/kernel/groups.c b/kernel/groups.c
index f0667e7..f7fb8dd 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -153,6 +153,29 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
 	return 0;
 }
 
+/* Compare two sorted group lists; return true if the first is a subset of the
+ * second.
+ */
+static bool is_subset(const struct group_info *g1, const struct group_info *g2)
+{
+	unsigned int i, j;
+
+	for (i = 0, j = 0; i < g1->ngroups; i++) {
+		kgid_t gid1 = GROUP_AT(g1, i);
+		kgid_t gid2;
+		for (; j < g2->ngroups; j++) {
+			gid2 = GROUP_AT(g2, j);
+			if (gid_lte(gid1, gid2))
+				break;
+		}
+		if (j >= g2->ngroups || !gid_eq(gid1, gid2))
+			return false;
+		j++;
+	}
+
+	return true;
+}
+
 /**
  * set_groups_sorted - Change a group subscription in a set of credentials
  * @new: The newly prepared set of credentials to alter
@@ -189,11 +212,18 @@ int set_current_groups(struct group_info *group_info)
 {
 	struct cred *new;
 
+	groups_sort(group_info);
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
+	if (!(ns_capable(current_user_ns(), CAP_SETGID)
+	      || (task_no_new_privs(current)
+		  && is_subset(group_info, new->group_info)))) {
+		abort_creds(new);
+		return -EPERM;
+	}
 
-	set_groups(new, group_info);
+	set_groups_sorted(new, group_info);
 	return commit_creds(new);
 }
 
@@ -233,8 +263,6 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
-		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bb..b27e167 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -176,8 +176,6 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
-		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
 
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
