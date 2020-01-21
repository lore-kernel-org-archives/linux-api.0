From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/6] clone3 & cgroups: allow spawning processes into cgroups
Date: Tue, 21 Jan 2020 16:48:38 +0100
Message-ID: <20200121154844.411-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey Tejun,

This is v5 of the promised series to enable spawning processes into a
target cgroup different from the parent's cgroup.

/* v1 */
Link: https://lore.kernel.org/r/20191218173516.7875-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org

/* v2 */
Link: https://lore.kernel.org/r/20191223061504.28716-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Rework locking and remove unneeded helper functions. Please see
individual patch changelogs for details.
With this I've been able to run the cgroup selftests and stress tests in
loops for a long time without any regressions or deadlocks; lockdep and
kasan did not complain either.

/* v3 */
Link: https://lore.kernel.org/r/20200117002143.15559-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Split preliminary work into separate patches.
See changelog of individual commits.

/* v4 */
Link: https://lore.kernel.org/r/20200117181219.14542-1-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Verify that we have write access to the target cgroup. This is usually
done by the vfs but since we aren't going through the vfs with
CLONE_INTO_CGROUP we need to do it ourselves.

/* v5 */
Don't pass down the parent task_struct as argument, just use current
directly. Put kargs->cset on error.

With this cgroup migration will be a lot easier, and accounting will be
more exact. It also allows for nice features such as creating a frozen
process by spawning it into a frozen cgroup.
The code simplifies container creation and exec logic quite a bit as
well.

I've tried to contain all core changes for this features in
kernel/cgroup/* to avoid exposing cgroup internals. This has mostly
worked.
When a new process is supposed to be spawned in a cgroup different from
the parent's then we briefly acquire the cgroup mutex right before
fork()'s point of no return and drop it once the child process has been
attached to the tasklist and to its css_set. This is done to ensure that
the cgroup isn't removed behind our back. The cgroup mutex is _only_
held in this case; the usual case, where the child is created in the
same cgroup as the parent does not acquire it since the cgroup can't be
removed.

The series already comes with proper testing. Once we've decided that
this approach is good I'll expand the test-suite even more.

The branch can be found in the following locations:
[1]: kernel.org: https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone_into_cgroup
[2]: github.com: https://github.com/brauner/linux/tree/clone_into_cgroup
[3]: gitlab.com: https://gitlab.com/brauner/linux/commits/clone_into_cgroup

Thanks!
Christian

Christian Brauner (6):
  cgroup: unify attach permission checking
  cgroup: add cgroup_get_from_file() helper
  cgroup: refactor fork helpers
  cgroup: add cgroup_may_write() helper
  clone3: allow spawning processes into cgroups
  selftests/cgroup: add tests for cloning into cgroups

 include/linux/cgroup-defs.h                   |   6 +-
 include/linux/cgroup.h                        |  20 +-
 include/linux/sched/task.h                    |   4 +
 include/uapi/linux/sched.h                    |   5 +
 kernel/cgroup/cgroup.c                        | 297 ++++++++++++++----
 kernel/cgroup/pids.c                          |  15 +-
 kernel/fork.c                                 |  19 +-
 tools/testing/selftests/cgroup/Makefile       |   6 +-
 tools/testing/selftests/cgroup/cgroup_util.c  | 126 ++++++++
 tools/testing/selftests/cgroup/cgroup_util.h  |   4 +
 tools/testing/selftests/cgroup/test_core.c    |  64 ++++
 .../selftests/clone3/clone3_selftests.h       |  19 +-
 12 files changed, 501 insertions(+), 84 deletions(-)


base-commit: b3a987b0264d3ddbb24293ebff10eddfc472f653
-- 
2.25.0
