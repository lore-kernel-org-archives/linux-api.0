From: serge.hallyn@ubuntu.com
Subject: [PATCH 7/7] Add FS_USERNS_FLAG to cgroup fs
Date: Fri, 27 Nov 2015 14:52:25 -0600
Message-ID: <1448657545-531-8-git-send-email-serge.hallyn@ubuntu.com>
References: <1448657545-531-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448657545-531-1-git-send-email-serge.hallyn@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: adityakali@google.com, tj@kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com, gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org, Serge Hallyn <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

From: Serge Hallyn <serge.hallyn@ubuntu.com>

allowing root in a non-init user namespace to mount it.  This should
now be safe, because

1. non-init-root cannot mount a previously unbound subsystem
2. the task doing the mount must be privileged with respect to the
   user namespace owning the cgroup namespace
3. the mounted subsystem will have its current cgroup as the root dentry.
   the permissions will be unchanged, so tasks will receive no new
   privilege over the cgroups which they did not have on the original
   mounts.

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2f487a4..ff81303 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2222,12 +2222,14 @@ static struct file_system_type cgroup_fs_type = {
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
 
 char * __must_check
-- 
1.7.9.5
