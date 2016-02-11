From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [lxc-devel] CGroup Namespaces (v10)
Date: Fri, 12 Feb 2016 00:18:28 +0100
Message-ID: <CAMXgnP6eSQjsuPXdrbaHytujVSkizPd4cJJQwQcuSCLAgVcYJw@mail.gmail.com>
References: <1454057651-23959-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454057651-23959-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 29 January 2016 at 09:54,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> following is a revised set of the CGroup Namespace patchset which Aditya
> Kali has previously sent.  The code can also be found in the cgroupns.v10
> branch of
>
> https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/
>
> To summarize the semantics:
>
> 1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED
>
> 2. unsharing a cgroup namespace makes all your current cgroups your new
> cgroup root.
>
> 3. /proc/pid/cgroup always shows cgroup paths relative to the reader's
> cgroup namespce root.  A task outside of  your cgroup looks like
>
>         8:memory:/../../..
>
> 4. when a task mounts a cgroupfs, the cgroup which shows up as root depends
> on the mounting task's  cgroup namespace.
>
> 5. setns to a cgroup namespace switches your cgroup namespace but not
> your cgroups.
>
> With this, using github.com/hallyn/lxc #2015-11-09/cgns (and
> github.com/hallyn/lxcfs #2015-11-10/cgns) we can start a container in a full
> proper cgroup namespace, avoiding either cgmanager or lxcfs cgroup bind mounts.
>
> This is completely backward compatible and will be completely invisible
> to any existing cgroup users (except for those running inside a cgroup
> namespace and looking at /proc/pid/cgroup of tasks outside their
> namespace.)

Hi,

I just noticed commit c38c4597e4bf ("netfilter: implement xt_cgroup
cgroup2 path match") which, as far as I understand, introduces a new
userland facing API containing the full cgroup path. Does it mean that
the cgroupns patchset should include cgroup path translation in
xt_cgroup?

> Changes from V9:
> 1. Update to latest Linus tree
> 2. A few locking fixes
>
> Changes from V8:
> 1. Incorporate updated documentation from tj.
> 2. Put lookup_one_len() under inode lock
> 3. Make cgroup_path non-namespaced, so only calls to cgroup_path_ns() are
>    namespaced.
> 4. Make cgroup_path{,_ns} take the needed locks, since external callers cannot
>    do so.
> 5. Fix the bisectability problem of to_cg_ns() being defined after use
>
> Changes from V7:
> 1. Rework kernfs_path_from_node_locked to return the string length
> 2. Rename and reorder args to kernfs_path_from_node
> 3. cgroup.c: undo accidental conversoins to inline
> 4. cgroup.h: move ns declarations to bottom.
> 5. Rework the documentation to fit the style of the rest of cgroup.txt
>
> Changes from V6:
> 1. Switch to some WARN_ONs to provide stack traces
> 2. Rename kernfs_node_distance to kernfs_depth
> 3. Make sure kernfs_common_ancestor() nodes are from same root
> 4. Split kernfs changes for cgroup_mount into separate patch
> 5. Rename kernfs_obtain_root to kernfs_node_dentry
> (And more, see patch changelogs)
>
> Changes from V5:
> 1. To get a root dentry for cgroup namespace mount, walk the path from the
>    kernfs root dentry.
>
> Changes from V4:
> 1. Move the FS_USERNS_MOUNT flag to last patch
> 2. Rebase onto cgroup/for-4.5
> 3. Don't non-init user namespaces to bind new subsystems when mounting.
> 4. Address feedback from Tejun (thanks).  Specificaly, not addressed:
>    . kernfs_obtain_root - walking dentry from kernfs root.
>      (I think that's the only piece)
> 5. Dropped unused get_task_cgroup fn/patch.
> 6. Reworked kernfs_path_from_node_locked() to try to simplify the logic.
>    It now finds a common ancestor, walks from the source to it, then back
>    up to the target.
>
> Changes from V3:
> 1. Rebased onto latest cgroup changes.  In particular switch to
>    css_set_lock and ns_common.
> 2. Support all hierarchies.
>
> Changes from V2:
> 1. Added documentation in Documentation/cgroups/namespace.txt
> 2. Fixed a bug that caused crash
> 3. Incorporated some other suggestions from last patchset:
>    - removed use of threadgroup_lock() while creating new cgroupns
>    - use task_lock() instead of rcu_read_lock() while accessing
>      task->nsproxy
>    - optimized setns() to own cgroupns
>    - simplified code around sane-behavior mount option parsing
> 4. Restored ACKs from Serge Hallyn from v1 on few patches that have
>    not changed since then.
>
> Changes from V1:
> 1. No pinning of processes within cgroupns. Tasks can be freely moved
>    across cgroups even outside of their cgroupns-root. Usual DAC/MAC policies
>    apply as before.
> 2. Path in /proc/<pid>/cgroup is now always shown and is relative to
>    cgroupns-root. So path can contain '/..' strings depending on cgroupns-root
>    of the reader and cgroup of <pid>.
> 3. setns() does not require the process to first move under target
>    cgroupns-root.
>
> Changes form RFC (V0):
> 1. setns support for cgroupns
> 2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
>    mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
> 3. writes to cgroup files outside of cgroupns-root are not allowed
> 4. visibility of /proc/<pid>/cgroup is further restricted by not showing
>    anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
>    your cgroupns-root.
>
>
> _______________________________________________
> lxc-devel mailing list
> lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
> http://lists.linuxcontainers.org/listinfo/lxc-devel
