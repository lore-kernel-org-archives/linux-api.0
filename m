From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: Add documentation for cgroup namespaces
Date: Mon, 28 Dec 2015 12:47:35 -0500
Message-ID: <20151228174735.GB30165@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <1450844609-9194-8-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450844609-9194-8-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

I did some heavy editing of the documentation.  How does this look?
Did I miss anything?

Thanks.
---
 Documentation/cgroup.txt |  146 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

--- a/Documentation/cgroup.txt
+++ b/Documentation/cgroup.txt
@@ -47,6 +47,11 @@ CONTENTS
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
+6. Namespace
+  6-1. Basics
+  6-2. The Root and Views
+  6-3. Migration and setns(2)
+  6-4. Interaction with Other Namespaces
 P. Information on Kernel Programming
   P-1. Filesystem Support for Writeback
 D. Deprecated v1 Core Features
@@ -1013,6 +1018,147 @@ writeback as follows.
 	vm.dirty[_background]_ratio.
 
 
+6. Namespace
+
+6-1. Basics
+
+cgroup namespace provides a mechanism to virtualize the view of the
+"/proc/$PID/cgroup" file.  The CLONE_NEWCGROUP clone flag can be used
+with clone(2) and unshare(2) to create a new cgroup namespace.  The
+process running inside the cgroup namespace will have its
+"/proc/$PID/cgroup" output restricted to cgroupns root.  The cgroupns
+root is the cgroup of the process at the time of creation of the
+cgroup namespace.
+
+Without cgroup namespace, the "/proc/$PID/cgroup" file shows the
+complete path of the cgroup of a process.  In a container setup where
+a set of cgroups and namespaces are intended to isolate processes the
+"/proc/$PID/cgroup" file may leak potential system level information
+to the isolated processes.  For Example:
+
+  # cat /proc/self/cgroup
+  0::/batchjobs/container_id1
+
+The path '/batchjobs/container_id1' can be considered as system-data
+and undesirable to expose to the isolated processes.  cgroup namespace
+can be used to restrict visibility of this path.  For example, before
+creating a cgroup namespace, one would see:
+
+  # ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
+  # cat /proc/self/cgroup
+  0::/batchjobs/container_id1
+
+After unsharing a new namespace, the view changes.
+
+  # ls -l /proc/self/ns/cgroup
+  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
+  # cat /proc/self/cgroup
+  0::/
+
+When some thread from a multi-threaded process unshares its cgroup
+namespace, the new cgroupns gets applied to the entire process (all
+the threads).  This is natural for the v2 hierarchy; however, for the
+legacy hierarchies, this may be unexpected.
+
+A cgroup namespace is alive as long as there are processes inside it.
+When the last process exits, the cgroup namespace is destroyed.  The
+cgroupns root and the actual cgroups remain.
+
+
+6-2. The Root and Views
+
+The 'cgroupns root' for a cgroup namespace is the cgroup in which the
+process calling unshare(2) is running.  For example, if a process in
+/batchjobs/container_id1 cgroup calls unshare, cgroup
+/batchjobs/container_id1 becomes the cgroupns root.  For the
+init_cgroup_ns, this is the real root ('/') cgroup.
+
+The cgroupns root cgroup does not change even if the namespace creator
+process later moves to a different cgroup.
+
+  # ~/unshare -c # unshare cgroupns in some cgroup
+  # cat /proc/self/cgroup
+  0::/
+  # mkdir sub_cgrp_1
+  # echo 0 > sub_cgrp_1/cgroup.procs
+  # cat /proc/self/cgroup
+  0::/sub_cgrp_1
+
+Each process gets its namespace-specific view of "/proc/$PID/cgroup"
+
+Processes running inside the cgroup namespace will be able to see
+cgroup paths (in /proc/self/cgroup) only inside their root cgroup.
+From within an unshared cgroupns:
+
+  # sleep 100000 &
+  [1] 7353
+  # echo 7353 > sub_cgrp_1/cgroup.procs
+  # cat /proc/7353/cgroup
+  0::/sub_cgrp_1
+
+From the initial cgroup namespace, the real cgroup path will be
+visible:
+
+  $ cat /proc/7353/cgroup
+  0::/batchjobs/container_id1/sub_cgrp_1
+
+From a sibling cgroup namespace (that is, a namespace rooted at a
+different cgroup), the cgroup path relative to its own cgroup
+namespace root will be shown.  For instance, if PID 7353's cgroup
+namespace root is at '/batchjobs/container_id2', then it will see
+
+  # cat /proc/7353/cgroup
+  0::/../container_id2/sub_cgrp_1
+
+Note that the relative path always starts with '/' to indicate that
+its relative to the cgroup namespace root of the caller.
+
+
+6-3. Migration and setns(2)
+
+Processes inside a cgroup namespace can move into and out of the
+namespace root if they have proper access to external cgroups.  For
+example, from inside a namespace with cgroupns root at
+/batchjobs/container_id1, and assuming that the global hierarchy is
+still accessible inside cgroupns:
+
+  # cat /proc/7353/cgroup
+  0::/sub_cgrp_1
+  # echo 7353 > batchjobs/container_id2/cgroup.procs
+  # cat /proc/7353/cgroup
+  0::/../container_id2
+
+Note that this kind of setup is not encouraged.  A task inside cgroup
+namespace should only be exposed to its own cgroupns hierarchy.
+
+setns(2) to another cgroup namespace is allowed when:
+
+(a) the process has CAP_SYS_ADMIN against its current user namespace
+(b) the process has CAP_SYS_ADMIN against the target cgroup
+    namespace's userns
+
+No implicit cgroup changes happen with attaching to another cgroup
+namespace.  It is expected that the someone moves the attaching
+process under the target cgroup namespace root.
+
+
+6-4. Interaction with Other Namespaces
+
+Namespace specific cgroup hierarchy can be mounted by a process
+running inside a non-init cgroup namespace.
+
+  # mount -t cgroup2 none $MOUNT_POINT
+
+This will mount the unified cgroup hierarchy with cgroupns root as the
+filesystem root.  The process needs CAP_SYS_ADMIN against its user and
+mount namespaces.
+
+The virtualization of /proc/self/cgroup file combined with restricting
+the view of cgroup hierarchy by namespace-private cgroupfs mount
+provides a properly isolated cgroup view inside the container.
+
+
 P. Information on Kernel Programming
 
 This section contains kernel programming information in the areas
