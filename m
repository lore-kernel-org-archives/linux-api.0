From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CGroup Namespaces (v6)
Date: Tue, 8 Dec 2015 09:22:58 -0600
Message-ID: <20151208152257.GA12530@mail.hallyn.com>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
	<CAMXgnP7vq1v+DeBMcu0wQ+LznBiXujkN-_Q21NE5FPiuNw3BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMXgnP7vq1v+DeBMcu0wQ+LznBiXujkN-_Q21NE5FPiuNw3BUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 08, 2015 at 11:10:03AM +0100, Alban Crequy wrote:
> Hi,
> 
> Thanks for the patches!
> 
> On 8 December 2015 at 00:06,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi,
> >
> > following is a revised set of the CGroup Namespace patchset which Aditya
> > Kali has previously sent.  The code can also be found in the cgroupns.v6
> > branch of
> >
> > https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/
> >
> > To summarize the semantics:
> >
> > 1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED
> >
> > 2. unsharing a cgroup namespace makes all your current cgroups your new
> > cgroup root.
> >
> > 3. /proc/pid/cgroup always shows cgroup paths relative to the reader's
> > cgroup namespce root.  A task outside of  your cgroup looks like
> >
> >         8:memory:/../../..
> >
> > 4. when a task mounts a cgroupfs, the cgroup which shows up as root depends
> > on the mounting task's  cgroup namespace.
> >
> > 5. setns to a cgroup namespace switches your cgroup namespace but not
> > your cgroups.
> >
> > With this, using github.com/hallyn/lxc #2015-11-09/cgns (and
> > github.com/hallyn/lxcfs #2015-11-10/cgns) we can start a container in a full
> > proper cgroup namespace, avoiding either cgmanager or lxcfs cgroup bind mounts.
> 
> I tested cgroupns.v6 with systemd-nspawn + patches from
> https://github.com/systemd/systemd/pull/2112 using
> unshare(CLONE_NEWCGROUP) booted with
> systemd.unified_cgroup_hierarchy=1 in Fedora22. Tested with and
> without userns. It worked for me :)

Great, thanks for testing.

> Do you need people to run more tests, with other scenarios?

Certainly the more testing the better.  There is a particular set of
cases which I'd earlier tested just in the shell, which could stand
to have a testcase.  That's to basically test all of the '..' possibilities
for /proc/self/cgroup and make sure it's all sane.  I.e. place task t1
into cgroups: '/', '/x1', '/x1/x2', '/x1/x2/x3';  place task t2 into
various relative paths '/', '/x1', '/x1/x2', '/y1', etc;  have t1
check where t2 is, then have t2 setns into t1's namespace and check where
t1 is.

> Do you have patches already for /usr/bin/unshare and /usr/bin/nsenter?

Nope, I don't have patch for util-linux yet, I just used a custom unshare
and setns program.

> > This is completely backward compatible and will be completely invisible
> > to any existing cgroup users (except for those running inside a cgroup
> > namespace and looking at /proc/pid/cgroup of tasks outside their
> > namespace.)
> >
> > Changes from V5:
> > 1. To get a root dentry for cgroup namespace mount, walk the path from the
> >    kernfs root dentry.
> >
> > Changes from V4:
> > 1. Move the FS_USERNS_MOUNT flag to last patch
> > 2. Rebase onto cgroup/for-4.5
> > 3. Don't non-init user namespaces to bind new subsystems when mounting.
> > 4. Address feedback from Tejun (thanks).  Specificaly, not addressed:
> >    . kernfs_obtain_root - walking dentry from kernfs root.
> >      (I think that's the only piece)
> > 5. Dropped unused get_task_cgroup fn/patch.
> > 6. Reworked kernfs_path_from_node_locked() to try to simplify the logic.
> >    It now finds a common ancestor, walks from the source to it, then back
> >    up to the target.
> >
> > Changes from V3:
> > 1. Rebased onto latest cgroup changes.  In particular switch to
> >    css_set_lock and ns_common.
> > 2. Support all hierarchies.
> >
> > Changes from V2:
> > 1. Added documentation in Documentation/cgroups/namespace.txt
> > 2. Fixed a bug that caused crash
> > 3. Incorporated some other suggestions from last patchset:
> >    - removed use of threadgroup_lock() while creating new cgroupns
> >    - use task_lock() instead of rcu_read_lock() while accessing
> >      task->nsproxy
> >    - optimized setns() to own cgroupns
> >    - simplified code around sane-behavior mount option parsing
> > 4. Restored ACKs from Serge Hallyn from v1 on few patches that have
> >    not changed since then.
> >
> > Changes from V1:
> > 1. No pinning of processes within cgroupns. Tasks can be freely moved
> >    across cgroups even outside of their cgroupns-root. Usual DAC/MAC policies
> >    apply as before.
> > 2. Path in /proc/<pid>/cgroup is now always shown and is relative to
> >    cgroupns-root. So path can contain '/..' strings depending on cgroupns-root
> >    of the reader and cgroup of <pid>.
> > 3. setns() does not require the process to first move under target
> >    cgroupns-root.
> >
> > Changes form RFC (V0):
> > 1. setns support for cgroupns
> > 2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
> >    mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
> > 3. writes to cgroup files outside of cgroupns-root are not allowed
> > 4. visibility of /proc/<pid>/cgroup is further restricted by not showing
> >    anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
> >    your cgroupns-root.
> >
> >
> > _______________________________________________
> > Containers mailing list
> > Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/containers
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
