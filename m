From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Thu,  4 Dec 2014 17:55:50 -0800
Message-ID: <1417744550-6461-9-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
	<1417744550-6461-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
Cc: richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/namespace.txt | 147 ++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 Documentation/cgroups/namespace.txt

diff --git a/Documentation/cgroups/namespace.txt b/Documentation/cgroups/namespace.txt
new file mode 100644
index 0000000..6480379
--- /dev/null
+++ b/Documentation/cgroups/namespace.txt
@@ -0,0 +1,147 @@
+			CGroup Namespaces
+
+CGroup Namespace provides a mechanism to virtualize the view of the
+/proc/<pid>/cgroup file. The CLONE_NEWCGROUP clone-flag can be used with
+clone() and unshare() syscalls to create a new cgroup namespace.
+The process running inside the cgroup namespace will have its /proc/<pid>/cgroup
+output restricted to cgroupns-root. cgroupns-root is the cgroup of the process
+at the time of creation of the cgroup namespace.
+
+Prior to CGroup Namespace, the /proc/<pid>/cgroup file used to show complete
+path of the cgroup of a process. In a container setup (where a set of cgroups
+and namespaces are intended to isolate processes), the /proc/<pid>/cgroup file
+may leak potential system level information to the isolated processes.
+
+For Example:
+  $ cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+The path '/batchjobs/container_id1' can generally be considered as system-data
+and its desirable to not expose it to the isolated process.
+
+CGroup Namespaces can be used to restrict visibility of this path.
+For Example:
+  # Before creating cgroup namespace
+  $ ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
+  $ cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+  # unshare(CLONE_NEWCGROUP) and exec /bin/bash
+  $ ~/unshare -c
+  [ns]$ ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
+  # From within new cgroupns, process sees that its in the root cgroup
+  [ns]$ cat /proc/self/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
+
+  # From global cgroupns:
+  $ cat /proc/<pid>/cgroup
+  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
+
+  # Unshare cgroupns along with userns and mountns
+  # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWNS), then
+  # sets up uid/gid map and execs /bin/bash
+  $ ~/unshare -c -u -m
+  # Originally, we were in /batchjobs/container_id1 cgroup. Mount our own cgroup
+  # hierarchy.
+  [ns]$ mount -t cgroup cgroup /tmp/cgroup
+  [ns]$ ls -l /tmp/cgroup
+  total 0
+  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
+  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
+  -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
+  -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
+
+The cgroupns-root (/batchjobs/container_id1 in above example) becomes the
+filesystem root for the namespace specific cgroupfs mount.
+
+The virtualization of /proc/self/cgroup file combined with restricting
+the view of cgroup hierarchy by namespace-private cgroupfs mount
+should provide a completely isolated cgroup view inside the container.
+
+Note that CGroup Namespaces virtualizes the path on unified hierarchy only. If
+other hierarchies are mounted, /proc/<pid>/cgroup will continue to show the full
+cgroup path for those.
+
+In its current form, the cgroup namespaces patcheset provides following
+behavior:
+
+(1) The 'cgroupns-root' for a cgroup namespace is the cgroup in which
+    the process calling unshare is running.
+    For ex. if a process in /batchjobs/container_id1 cgroup calls unshare,
+    cgroup /batchjobs/container_id1 becomes the cgroupns-root.
+    For the init_cgroup_ns, this is the real root ('/') cgroup
+    (identified in code as cgrp_dfl_root.cgrp).
+
+(2) The cgroupns-root cgroup does not change even if the namespace
+    creator process later moves to a different cgroup.
+    $ ~/unshare -c # unshare cgroupns in some cgroup
+    [ns]$ cat /proc/self/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
+    [ns]$ mkdir sub_cgrp_1
+    [ns]$ echo 0 > sub_cgrp_1/cgroup.procs
+    [ns]$ cat /proc/self/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+
+(3) Each process gets its CGROUPNS specific view of /proc/<pid>/cgroup
+(a) Processes running inside the cgroup namespace will be able to see
+    cgroup paths (in /proc/self/cgroup) only inside their root cgroup
+    [ns]$ sleep 100000 &  # From within unshared cgroupns
+    [1] 7353
+    [ns]$ echo 7353 > sub_cgrp_1/cgroup.procs
+    [ns]$ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+
+(b) From global cgroupns, the real cgroup path will be visible:
+    $ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1/sub_cgrp_1
+
+(c) From a sibling cgroupns (cgroupns root-ed at a different cgroup), cgroup
+    path relative to its own cgroupns-root will be shown:
+    # ns2's cgroupns-root is at '/batchjobs/container_id2'
+    [ns2]$ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2/sub_cgrp_1
+
+    Note that the relative path always starts with '/' to indicate that its
+    relative to the cgroupns-root of the caller.
+
+(4) Processes inside a cgroupns can move in-and-out of the cgroupns-root
+    (if they have proper access to external cgroups).
+    # From inside cgroupns (with cgroupns-root at /batchjobs/container_id1), and
+    # assuming that the global hierarchy is still accessible inside cgroupns:
+    $ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/sub_cgrp_1
+    $ echo 7353 > batchjobs/container_id2/cgroup.procs
+    $ cat /proc/7353/cgroup
+    0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/../container_id2
+
+    Note that this kind of setup is not encouraged. A task inside cgroupns
+    should only be exposed to its own cgroupns hierarchy. Otherwise it makes
+    the virtualization of /proc/<pid>/cgroup less useful.
+
+(5) Setns to another cgroup namespace is allowed when:
+    (a) the process has CAP_SYS_ADMIN in its current userns
+    (b) the process has CAP_SYS_ADMIN in the target cgroupns' userns
+    No implicit cgroup changes happen with attaching to another cgroupns. It
+    is expected that the somone moves the attaching process under the target
+    cgroupns-root.
+
+(6) When some thread from a multi-threaded process unshares its
+    cgroup-namespace, the new cgroupns gets applied to the entire
+    process (all the threads). This should be OK since
+    unified-hierarchy only allows process-level containerization. So
+    all the threads in the process will have the same cgroup.
+
+(7) The cgroup namespace is alive as long as there is atleast 1
+    process inside it. When the last process exits, the cgroup
+    namespace is destroyed. The cgroupns-root and the actual cgroups
+    remain though.
+
+(8) Namespace specific cgroup hierarchy can be mounted by a process running
+    inside cgroupns:
+    $ mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
+
+    This will mount the unified cgroup hierarchy with cgroupns-root as the
+    filesystem root. The process needs CAP_SYS_ADMIN in its userns and mntns.
+
-- 
2.2.0.rc0.207.ga3a616c
