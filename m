From: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 7/8] cgroup: Add documentation for cgroup namespaces
Date: Tue, 22 Dec 2015 22:23:28 -0600
Message-ID: <1450844609-9194-8-git-send-email-serge.hallyn@ubuntu.com>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1450844609-9194-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
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
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
Changelog (2015-12-08):
  Merge into Documentation/cgroup.txt
Changelog (2015-12-22):
  Reformat to try to follow the style of the rest of the cgroup.txt file.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroup.txt |  150 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/Documentation/cgroup.txt b/Documentation/cgroup.txt
index 31d1f7b..03ad757 100644
--- a/Documentation/cgroup.txt
+++ b/Documentation/cgroup.txt
@@ -47,6 +47,7 @@ CONTENTS
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
+6. Namespaces
 P. Information on Kernel Programming
   P-1. Filesystem Support for Writeback
 D. Deprecated v1 Core Features
@@ -1013,6 +1014,155 @@ writeback as follows.
 	vm.dirty[_background]_ratio.
 
 
+6. Cgroup Namespaces
+
+Cgroup namespaces provides a mechanism to virtualize the view of the
+"/proc/$PID/cgroup" file. The CLONE_NEWCGROUP clone flag can be used with
+clone() and unshare() syscalls to create a new cgroup namespace.  The process
+running inside the cgroup namespace will have its "/proc/$PID/cgroup" output
+restricted to cgroupns root.  The cgroupns root is the cgroup of the process at
+the time of creation of the cgroup namespace.
+
+Prior to cgroup namespaces, the "/proc/$PID/cgroup" file showed the complete
+path of the cgroup of a process. In a container setup where a set of cgroups
+and namespaces are intended to isolate processes the "/proc/$PID/cgroup" file
+may leak potential system level information to the isolated processes.
+
+For Example:
+  # cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+The path '/batchjobs/container_id1' can generally be considered as system-data
+and its desirable to not expose it to the isolated process.
+
+Cgroup namespaces can be used to restrict visibility of this path.
+For example, before creating a cgroup namespace, one would see:
+
+  # ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
+  # cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+After unsharing a new namespace, the view has changed.
+
+  # ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
+  # cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
+
+While a task in the global cgroup namespace sees the full path.
+
+  # cat /proc/$PID/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+If also unsharing the user and mounts namespaces, then when mounting cgroupfs
+then the mount's root will be the task's cgroup.
+
+  # lxc-usernsexec --unshare -m -c
+  # mount -t cgroup cgroup /tmp/cgroup
+  # ls -l /tmp/cgroup
+  total 0
+  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
+  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
+  -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
+  -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
+
+The cgroupns root (/batchjobs/container_id1 in above example) becomes the
+filesystem root for the namespace specific cgroupfs mount.
+
+The virtualization of /proc/self/cgroup file combined with restricting
+the view of cgroup hierarchy by namespace-private cgroupfs mount
+should provide a completely isolated cgroup view inside the container.
+
+In its current form, the cgroup namespaces patcheset provides following
+behavior:
+
+(1) The 'cgroupns root' for a cgroup namespace is the cgroup in which
+    the process calling unshare is running.
+    For ex. if a process in /batchjobs/container_id1 cgroup calls unshare,
+    cgroup /batchjobs/container_id1 becomes the cgroupns root.
+    For the init_cgroup_ns, this is the real root ('/') cgroup
+    (identified in code as cgrp_dfl_root.cgrp).
+
+(2) The cgroupns root cgroup does not change even if the namespace
+    creator process later moves to a different cgroup.
+    # ~/unshare -c # unshare cgroupns in some cgroup
+     # cat /proc/self/cgroup
+     0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
+     # mkdir sub_cgrp_1
+     # echo 0 > sub_cgrp_1/cgroup.procs
+     # cat /proc/self/cgroup
+     0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+
+(3) Each process gets its namespace-specific view of "/proc/$PID/cgroup"
+
+(a) Processes running inside the cgroup namespace will be able to see
+    cgroup paths (in /proc/self/cgroup) only inside their root cgroup.
+    From within an unshared cgroupns:
+    # sleep 100000 &
+    [1] 7353
+    # echo 7353 > sub_cgrp_1/cgroup.procs
+    # cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+
+(b) From the initial cgroup namespace, the real cgroup path will be visible:
+    $ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1/sub_cgrp_1
+
+(c) From a sibling cgroup namespace (that is, a namespace rooted at a
+    different cgroup), the cgroup path relative to its own cgroup namespace
+    root will be shown.  For instance, if PID 7353's cgroup namespace root is
+    at '/batchjobs/container_id2', then it will see
+
+    # cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2/sub_cgrp_1
+
+    Note that the relative path always starts with '/' to indicate that its
+    relative to the cgroup namespace root of the caller.
+
+(4) Processes inside a cgroup namespace can move into and out of the namespace
+    root if they have proper access to external cgroups.  So from inside a
+    namespace with cgroupns root at /batchjobs/container_id1, and
+    assuming that the global hierarchy is still accessible inside cgroupns:
+
+    # cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+    # echo 7353 > batchjobs/container_id2/cgroup.procs
+    # cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2
+
+    Note that this kind of setup is not encouraged. A task inside cgroup
+    namespace should only be exposed to its own cgroupns hierarchy. Otherwise
+    it makes the virtualization of "/proc/$PID/cgroup" less useful.
+
+(5) Setns to another cgroup namespace is allowed when:
+    (a) the process has CAP_SYS_ADMIN against its current user namespace
+    (b) the process has CAP_SYS_ADMIN against the target cgroup namespace's
+        userns
+    No implicit cgroup changes happen with attaching to another cgroup
+    namespace. It is expected that the somone moves the attaching process under
+    the target cgroup namespace root.
+
+(6) When some thread from a multi-threaded process unshares its
+    cgroup namespace, the new cgroupns gets applied to the entire process (all
+    the threads). For the unified hierarchy this is expected as it only allows
+    process level containerization.  For the legacy hierarchies this may be
+    unexpected.  So all the threads in the process will have the same cgroup.
+
+(7) The cgroup namespace is alive as long as there is at least 1
+    process inside it.  When the last process exits, the cgroup
+    namespace is destroyed. The cgroupns root and the actual cgroups
+    remain.
+
+(8) Namespace specific cgroup hierarchy can be mounted by a process running
+    inside a non-init cgroup namespace:
+
+    # mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
+
+    This will mount the unified cgroup hierarchy with cgroupns root as the
+    filesystem root. The process needs CAP_SYS_ADMIN against its user and
+    mounts namespaces.
+
 P. Information on Kernel Programming
 
 This section contains kernel programming information in the areas
-- 
1.7.9.5
