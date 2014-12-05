From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 0/8] CGroup Namespaces
Date: Thu,  4 Dec 2014 17:55:42 -0800
Message-ID: <1417744550-6461-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <adityakali-cgroupns>
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

Another spin for CGroup Namespaces feature.

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

---
 Documentation/cgroups/namespace.txt | 147 +++++++++++++++++++++++++++
 fs/kernfs/dir.c                     | 195 ++++++++++++++++++++++++++++++++----
 fs/kernfs/mount.c                   |  48 +++++++++
 fs/proc/namespaces.c                |   1 +
 include/linux/cgroup.h              |  52 +++++++++-
 include/linux/cgroup_namespace.h    |  36 +++++++
 include/linux/kernfs.h              |   5 +
 include/linux/nsproxy.h             |   2 +
 include/linux/proc_ns.h             |   4 +
 include/uapi/linux/sched.h          |   3 +-
 kernel/Makefile                     |   2 +-
 kernel/cgroup.c                     | 106 +++++++++++++++-----
 kernel/cgroup_namespace.c           | 140 ++++++++++++++++++++++++++
 kernel/fork.c                       |   2 +-
 kernel/nsproxy.c                    |  19 +++-
 15 files changed, 711 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/cgroups/namespace.txt
 create mode 100644 include/linux/cgroup_namespace.h
 create mode 100644 kernel/cgroup_namespace.c

[PATCHv3 1/8] kernfs: Add API to generate relative kernfs path
[PATCHv3 2/8] sched: new clone flag CLONE_NEWCGROUP for cgroup
[PATCHv3 3/8] cgroup: add function to get task's cgroup on default
[PATCHv3 4/8] cgroup: export cgroup_get() and cgroup_put()
[PATCHv3 5/8] cgroup: introduce cgroup namespaces
[PATCHv3 6/8] cgroup: cgroup namespace setns support
[PATCHv3 7/8] cgroup: mount cgroupns-root when inside non-init cgroupns
[PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
