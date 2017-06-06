From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 00/26] Fixing wait, exit, ptrace, exec, and CLONE_THREAD
Date: Tue, 06 Jun 2017 14:01:54 -0500
Message-ID: <877f0pym71.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
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
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


All,

I am posting this patches in the hope of some review of the strategy I
am taking and to let the individual patches be reviewed.

The intersection of wait, exit, ptrace, exec, and CLONE_THREAD does not
work correctly in the linux kernel.

An easy entry point into seeing the problem is that exec can wait
forever holding a mutex while waiting for userspace to call waitpid on a
ptraced thread.  This is bad enough it has been observed to cause
deadlocks in real world situations today.

Another easy entry point is to see that a multi-threaded setuid won't
change the credentials on a zombie thread group leader.  Which can allow
sending signals to a process that the credential change should forbid.
This is in violation of posix and the semantics we attempt to enforce in
linux.

I have been silent the last couple of weeks reading up on the history
and seeing if I could come up with a solution to the buggy semantics and
great big piles of technical debt that exists in this area of the
kernel.  It unfortunately requires understanding all of the pieces to
come up with a satisfactory long term solution to this problem.  My goal
is to fix enough of the issues that futher cleanups and bug fixes won't
require such comprehensive knowledge.

In large the solution I have found is to:

- Fix the semantics of wait.

  This makes it clear what the semantics the rest of the fixes need to
  maintain.

- To move everything possible from release_task to do_exit.

  Moving code from release_task to do_exit means that zombie
  threads can no longer be used to access shared thread group state,
  removing the problem of stale credentials on zombie threads.

  Much of the state that is freed in release_task instead of do_exit
  is freed there because originally during the CLONE_THREAD development
  there was no where else to put code that freed thread group state.
  And my changes largely move state freeing back where it used to
  be in 2.4 and earlier.

- To remove the concept of thread group leader (and allowing the first
  thread to exit).

  The concept of thread group leader keeps leading people into false
  mental models of what the kernel actually does.

  There is a lot of code that makes the mistake of assuming the thread
  group leader is always alive.  When the code doesn't make that mistake
  it requires additional code complexity to deal with zombie thread
  group leaders.  As seen in the signal code which still doesn't
  handle zombie thread group leaders correctly from a permission
  checking perspective.

- To promote tgid to a first class concept in the kernel.

  This is necessary if there isn't a thread group leader, and a
  significant part of the functional changes I am making.

- To only allow sending signals through living threads.

  This is a subset of removing the concept of thread group leader.  But
  worth calling out because signal handling is the most significant
  offender.

My first batch of changes includes some trivial cleanups and then
includes the small semantic changes (AKA user visible) I noticed that
are necessary to give userspace consistent semantics.

The full set of changes that I have come up with is at:
   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git exit-cleanups-for-testing

Unless someone has a better suggestion I intend to collect this up as
a topic branch and merge this through my tree.

Review on the details and of the concept would be very much appreciated.

Eric W. Biederman (26):
      alpha: Remove unused TASK_GROUP_LEADER
      cgroup: Don't open code tasklist_empty()
      signal: Do not perform permission checks when sending pdeath_signal
      signal: Make group_send_sig_info static
      exit:  Remove the pointless clearing of SIGPENDING in __exit_signal
      rlimit: Remove unnecessary grab of tasklist_lock
      pidns: Improve the error handling in alloc_pid
      exit: Make the runqueue rcu safe
      signal: Don't allow sending SIGKILL or SIGSTOP to init
      ptrace: Simplify ptrace_detach & exit_ptrace
      wait: Properly implement __WCLONE handling in the presence of exec and ptrace
      wait: Directly test for the two cases where wait_task_zombie is called
      wait: Remove unused delay_group_leader
      wait: Move changing of ptrace from wait_consider_task into wait_task_stopped
      wait: Don't delay !ptrace_reparented leaders
      exit: Fix reporting a ptraced !reparented leader has exited
      exit: Rework the exit states for ptracees
      wait: Fix WSTOPPED on a ptraced child
      wait: Simpler code for clearing notask_error in wait_consider_task
      wait: Don't pass the list to wait_consider_task
      wait: Optmize waitpid
      exit: Fix auto-wait of ptraced children
      signal:  Fix SIGCONT before group stop completes.
      signal: In ptrace_stop improve identical signal detection
      signal: In ptrace_stop use CLD_TRAPPED in all ptrace signals
      pidns: Ensure zap_pid_ns_processes always terminates

 arch/alpha/kernel/asm-offsets.c |   1 -
 include/linux/sched.h           |   7 +-
 include/linux/sched/signal.h    |  29 ++--
 include/linux/sched/task.h      |   4 +-
 include/linux/signal.h          |   1 -
 kernel/cgroup/cgroup.c          |   2 +-
 kernel/exit.c                   | 375 ++++++++++++++++------------------------
 kernel/fork.c                   |   3 +-
 kernel/pid.c                    |   8 +-
 kernel/pid_namespace.c          |   2 +-
 kernel/ptrace.c                 |  44 ++---
 kernel/sched/core.c             |   2 +-
 kernel/sched/fair.c             |   2 +-
 kernel/signal.c                 | 122 +++++++------
 kernel/sys.c                    |  13 +-
 15 files changed, 267 insertions(+), 348 deletions(-)

Eric
