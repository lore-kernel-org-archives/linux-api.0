From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 8/8] Add FS_USERNS_FLAG to cgroup fs
Date: Wed,  9 Dec 2015 13:29:01 -0600
Message-ID: <1449689341-28742-9-git-send-email-serge.hallyn@ubuntu.com>
References: <1449689341-28742-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449689341-28742-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

allowing root in a non-init user namespace to mount it.  This should
now be safe, because

1. non-init-root cannot mount a previously unbound subsystem
2. the task doing the mount must be privileged with respect to the
   user namespace owning the cgroup namespace
3. the mounted subsystem will have its current cgroup as the root dentry.
   the permissions will be unchanged, so tasks will receive no new
   privilege over the cgroups which they did not have on the original
   mounts.

Signed-off-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b92b3fd..7d5d7e1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2231,12 +2231,14 @@ static struct file_system_type cgroup_fs_type = {
 	.name = "cgroup",
 	.mount = cgroup_mount,
 	.kill_sb = cgroup_kill_sb,
+	.fs_flags = FS_USERNS_MOUNT,
 };
 
 static struct file_system_type cgroup2_fs_type = {
 	.name = "cgroup2",
 	.mount = cgroup_mount,
 	.kill_sb = cgroup_kill_sb,
+	.fs_flags = FS_USERNS_MOUNT,
 };
 
 static char * cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
-- 
1.7.9.5
