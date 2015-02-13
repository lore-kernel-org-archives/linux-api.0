From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v3 0/7] epoll: Introduce new syscalls, epoll_ctl_batch and epoll_pwait1
Date: Fri, 13 Feb 2015 17:03:56 +0800
Message-ID: <1423818243-15410-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Hi all,

This is the updated series for the new epoll system calls, with the cover
letter rewritten which includes some more explanation. Comments are very
welcome!

Original Motivation
===================

QEMU, and probably many more select/poll based applications, will consider
epoll as an alternative, when its event loop needs to handle a big number of
fds. However, there are currently two concerns with epoll which prevents the
switching from ppoll to epoll. 

The major one is the timeout precision.

For example in QEMU, the main loop takes care of calling callbacks at a
specific timeout - the QEMU timer API. The timeout value in ppoll depends on
the next firing timer. epoll_pwait's millisecond timeout is so coarse that
rounding up the timeout will hurt performance badly.

The minor one is the number of system call to update fd set.

While epoll can handle a large number of fds quickly, it still requires one
epoll_ctl per fd update, compared to the one-shot call to select/poll with an
fd array. This may as well make epoll inferior to ppoll in the cases where a
small, but frequently changing set of fds are polled by the event loop.

This series introduces two new epoll APIs to address them respectively. The
idea of epoll_ctl_batch is suggested by Andy Lutomirski in [1], who also
suggested clockid as a parameter in epoll_pwait1.

Discussion
==========

[Note: This is the question part regarding the interface contract of
epoll_ctl_batch.  If you don't have the context of what is epoll_ctl_batch yet,
please skip this part and probably start with the man page style documentation.
You can resume to this section later.]

[Thanks to Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, who pointed out this in
reviewing v1]

We try to report status for each command in epoll_ctl_batch, by writting to
user provided command array (pointed to cmds). The tricky thing in the
implementation is that, copying the results back to userspace comes last, after
the commands are executed. At this point, if the copy_to_user fails, the
effects are done and no return - or if we add some mechanism to revert it, the
code will be too complicated and slow.

In above corner case, the return value of epoll_ctl_batch is smaller than
ncmds, which assures our caller that last N commands failed, where N = ncmds -
ret.  But they'll also find that cmd.result is not changed to error code.

I suppose this is not a big deal, because 1) it should happen very rarely. 2)
user does know the actual number of commands that succeed.

So, do we leave it as is? Or is there any way to improve?

One tiny improvement (not a complete fix) in my mind is a testing copy_to_user
before we execute the commands. If it succeeds, it's even less likely the last
copy_to_user could fail, so that we can even probably assert it won't. The
testing 'copy_to_user(cmds, &kcmds, ...)' will not hurt functionality if do it
right after 'copy_from_user(&kcmds, cmds, ...)'. But I'm not sure about the
performance impact, especially when @ncmds is big.

Links
=====

[1]: http://lists.openwall.net/linux-kernel/2015/01/08/542

Changelog
=========

Changes from v2 (https://lkml.org/lkml/2015/2/4/105)
----------------------------------------------------

  - Rename epoll_ctl_cmd.error_hint to "result". [Michael]

  - Add background introduction in cover letter. [Michael]

  - Expand the last struct of epoll_pwait1, add clockid and timespec.
  
  - Update man page in cover letter accordingly:

    * "error_hint" -> "result".
    * The result field's caveat in "RETURN VALUE" secion of epoll_ctl_batch.

  Please review!

Changes from v1 (https://lkml.org/lkml/2015/1/20/189)
-----------------------------------------------------

  - As discussed in previous thread [1], split the call to epoll_ctl_batch and
    epoll_pwait. [Michael]

  - Fix memory leaks. [Omar]

  - Add a short comment about the ignored copy_to_user failure. [Omar]

  - Cover letter rewritten.

Documentation of the new system calls
=====================================

[I tried to write in the familiar man page style, but I am not proficient on
this. Thanks for Michael's help and suggestions in helping me improve it
through previous discussions.]

1) epoll_ctl_batch
------------------

NAME
       epoll_ctl_batch - modify an epoll descriptor in batch

SYNOPSIS

       #include <sys/epoll.h>

       int epoll_ctl_batch(int epfd, int flags,
                           int ncmds, struct epoll_ctl_cmd *cmds);

DESCRIPTION

       The system call performs a batch of epoll_ctl operations. It allows
       efficient update of events on this epoll descriptor.

       Flags is reserved and must be 0.

       Each operation is specified as an element in the cmds array, defined as:

           struct epoll_ctl_cmd {

                  /* Reserved flags for future extension, must be 0. */
                  int flags;

                  /* The same as epoll_ctl() op parameter. */
                  int op;

                  /* The same as epoll_ctl() fd parameter. */
                  int fd;

                  /* The same as the "events" field in struct epoll_event. */
                  uint32_t events;

                  /* The same as the "data" field in struct epoll_event. */
                  uint64_t data;

                  /* Output field, will be set to the return code after this
                   * command is executed by kernel */
                  int result;
           };

       Commands are executed in their order in cmds, and if one of them failed,
       the rest after it are not tried.

       Not that this call isn't atomic in terms of updating the epoll
       descriptor, which means a second epoll_ctl or epoll_ctl_batch call
       during the first epoll_ctl_batch may make the operation sequence
       interleaved. However, each single epoll_ctl_cmd operation has the same
       semantics as a epoll_ctl call.

RETURN VALUE

       If one or more of the parameters are incorrect, -1 is returned and errno
       is set appropriately. Otherwise, the number of succeeded commands is
       returned.

       Each 'result' field may be set to the error code or 0, depending on the
       result of the command. If the kernel fails to set the field after the
       commands are completed or failed, it may also be unchanged, even though
       the effects of successful commands are done. In this case, it's still
       ensured that 1) the i-th (i = ret) command is the failed command; 2) all
       the preceeding commands are successfully executed; 3) all the subsequent
       ones are not executed.

ERRORS

       Errors for the overall system call (in errno) are:

       EINVAL flags is non-zero, or ncmds is less than or equal to zero, or
              cmds is NULL.

       ENOMEM There was insufficient memory to handle the requested op control
              operation.

       EFAULT The memory area pointed to by cmds is not accessible with write
              permissions.


       Errors for each command (in result field) are:

       EBADF  epfd or fd is not a valid file descriptor.

       EEXIST op was EPOLL_CTL_ADD, and the supplied file descriptor fd is
              already registered with this epoll instance.

       EINVAL epfd is not an epoll file descriptor, or fd is the same as epfd,
              or the requested operation op is not supported by this interface.

       ENOENT op was EPOLL_CTL_MOD or EPOLL_CTL_DEL, and fd is not registered
              with this epoll instance.

       ENOMEM There was insufficient memory to handle the requested op control
              operation.

       ENOSPC The limit imposed by /proc/sys/fs/epoll/max_user_watches was
              encountered while trying to register (EPOLL_CTL_ADD) a new file
              descriptor on an epoll instance.  See epoll(7) for further
              details.

       EPERM  The target file fd does not support epoll.

CONFORMING TO

       epoll_ctl_batch() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)


2) epoll_pwait1
---------------

NAME
       epoll_pwait1 - wait for an I/O event on an epoll file descriptor

SYNOPSIS

       #include <sys/epoll.h>

       int epoll_pwait1(int epfd, int flags,
                        struct epoll_event *events,
                        int maxevents,
                        struct epoll_wait_params *params);

DESCRIPTION

       The epoll_pwait1 system call differs from epoll_pwait only in
       parameter list. The epfd, events and maxevents parameters are the same
       as in epoll_wait and epoll_pwait. The flags and params are new.

       The flags is reserved and must be zero.

       The params is a pointer to a structure parameters for the epoll_pwait1,
       defined as:

           struct epoll_wait_params {
               int clockid;
               struct timespec timeout;
               sigset_t *sigmask;
               size_t sigsetsize;
           };

       The field clockid must be either CLOCK_REALTIME or CLOCK_MONOTONIC, to
       choose the clock type to use for timeout. Note that CLOCK_MONOTONIC is
       the implicit and only possible clock type for epoll_pwait.
       
       The timeout field specifies the minimum time that epoll_wait() will
       block.  (The effective length will be rounded up to the clock
       granularity, and kernel scheduling delays mean that the blocking
       interval may overrun by a small amount.) Specifying a nagative time
       lenght (for example, timeout.tv_sec = 0 and timeout.tv_nsec = -1, or the
       other way round) causes epoll_pwait1() to block indefinitely, while
       specifying a timeout equal to zero (both fields in timeout are zero)
       causes epoll_wait() to return immediately, even if no events are
       available.

       The sigmask and sigsetsize has the same semantics as epoll_pwait. The
       sigmask field may be specified as NULL, in which case epoll_pwait1()
       will behave like epoll_wait.

   User visibility of sigsetsize

       In epoll_pwait and other syscalls, sigsetsize is not visible to
       application developer as glibc has a wrapper around epoll_pwait system
       call. Now that we pack several parameters in epoll_wait_params, so in
       order to hide sigsetsize from application code, we can still wrap it,
       either by expanding parameters and build the structure in the wrapper
       function, or only ask application to provide the first half:

           struct epoll_wait_params_user {
               int clockid;
               struct timespec timeout;
               sigset_t *sigmask;
           };

      Then in the wrapper function copy to a full structure and fill in
      sigsetsize.

RETURN VALUE

       The same as said in epoll_pwait(2).

ERRORS

       The same as said in man epoll_pwait(2), plus:

       EINVAL flags is not zero, or clockid is neither CLOCK_REALTIME nor
              CLOCK_MONOTONIC.

       EFAULT The memory area pointed to by params is not accessible.


CONFORMING TO

       epoll_pwait1() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)

Fam Zheng (7):
  epoll: Extract epoll_wait_do and epoll_pwait_do
  epoll: Specify clockid explicitly
  epoll: Extract ep_ctl_do
  epoll: Add implementation for epoll_ctl_batch
  x86: Hook up epoll_ctl_batch syscall
  epoll: Add implementation for epoll_pwait1
  x86: Hook up epoll_pwait1 syscall

 arch/x86/syscalls/syscall_32.tbl |   2 +
 arch/x86/syscalls/syscall_64.tbl |   2 +
 fs/eventpoll.c                   | 258 +++++++++++++++++++++++++--------------
 include/linux/syscalls.h         |   9 ++
 include/uapi/linux/eventpoll.h   |  18 +++
 5 files changed, 199 insertions(+), 90 deletions(-)

-- 
1.9.3
