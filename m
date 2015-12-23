From: serge.hallyn@ubuntu.com
Subject: CGroup Namespaces (v8)
Date: Tue, 22 Dec 2015 22:23:21 -0600
Message-ID: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: adityakali@google.com, tj@kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com, gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
List-Id: linux-api@vger.kernel.org

Hi,

following is a revised set of the CGroup Namespace patchset which Aditya
Kali has previously sent.  The code can also be found in the cgroupns.v8
branch of

https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/

To summarize the semantics:

1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED

2. unsharing a cgroup namespace makes all your current cgroups your new
cgroup root.

3. /proc/pid/cgroup always shows cgroup paths relative to the reader's
cgroup namespce root.  A task outside of  your cgroup looks like

	8:memory:/../../..

4. when a task mounts a cgroupfs, the cgroup which shows up as root depends
on the mounting task's  cgroup namespace.

5. setns to a cgroup namespace switches your cgroup namespace but not
your cgroups.

With this, using github.com/hallyn/lxc #2015-11-09/cgns (and
github.com/hallyn/lxcfs #2015-11-10/cgns) we can start a container in a full
proper cgroup namespace, avoiding either cgmanager or lxcfs cgroup bind mounts.

This is completely backward compatible and will be completely invisible
to any existing cgroup users (except for those running inside a cgroup
namespace and looking at /proc/pid/cgroup of tasks outside their
namespace.)

Changes from V7:
1. Rework kernfs_path_from_node_locked to return the string length
2. Rename and reorder args to kernfs_path_from_node
3. cgroup.c: undo accidental conversoins to inline
4. cgroup.h: move ns declarations to bottom.
5. Rework the documentation to fit the style of the rest of cgroup.txt

Changes from V6:
1. Switch to some WARN_ONs to provide stack traces
2. Rename kernfs_node_distance to kernfs_depth
3. Make sure kernfs_common_ancestor() nodes are from same root
4. Split kernfs changes for cgroup_mount into separate patch
5. Rename kernfs_obtain_root to kernfs_node_dentry
(And more, see patch changelogs)

Changes from V5:
1. To get a root dentry for cgroup namespace mount, walk the path from the
   kernfs root dentry.

Changes from V4:
1. Move the FS_USERNS_MOUNT flag to last patch
2. Rebase onto cgroup/for-4.5
3. Don't non-init user namespaces to bind new subsystems when mounting.
4. Address feedback from Tejun (thanks).  Specificaly, not addressed:
   . kernfs_obtain_root - walking dentry from kernfs root.
     (I think that's the only piece)
5. Dropped unused get_task_cgroup fn/patch.
6. Reworked kernfs_path_from_node_locked() to try to simplify the logic.
   It now finds a common ancestor, walks from the source to it, then back
   up to the target.

Changes from V3:
1. Rebased onto latest cgroup changes.  In particular switch to
   css_set_lock and ns_common.
2. Support all hierarchies.

Changes from V2:
1. Added documentation in Documentation/cgroups/namespace.txt
2. Fixed a bug that caused crash
3. Incorporated some other suggestions from last patchset:
   - removed use of threadgroup_lock() while creating new cgroupns
   - use task_lock() instead of rcu_read_lock() while accessing
     task->nsproxy
   - optimized setns() to own cgroupns
   - simplified code around sane-behavior mount option parsing
4. Restored ACKs from Serge Hallyn from v1 on few patches that have
   not changed since then.

Changes from V1:
1. No pinning of processes within cgroupns. Tasks can be freely moved
   across cgroups even outside of their cgroupns-root. Usual DAC/MAC policies
   apply as before.
2. Path in /proc/<pid>/cgroup is now always shown and is relative to
   cgroupns-root. So path can contain '/..' strings depending on cgroupns-root
   of the reader and cgroup of <pid>.
3. setns() does not require the process to first move under target
   cgroupns-root.

Changes form RFC (V0):
1. setns support for cgroupns
2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
   mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
3. writes to cgroup files outside of cgroupns-root are not allowed
4. visibility of /proc/<pid>/cgroup is further restricted by not showing
   anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
   your cgroupns-root.
