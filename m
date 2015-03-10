From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/9] epoll: Introduce new syscalls, epoll_ctl_batch and epoll_pwait1
Date: Tue, 10 Mar 2015 09:49:06 +0800
Message-ID: <1425952155-27603-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Changes from v3:

  - Add "size" field in epoll_wait_params. [Jon, Ingo, Seymour]
  - Input validation for ncmds in epoll_ctl_batch. [Dan]
  - Return -EFAULT if copy_to_user failed in epoll_ctl_batch. [Omar, Michael]
  - Change "timeout" in epoll_wait_params to pointer, to get the same
    convention of 'no wait', 'wait indefinitely' and 'wait for specified time'
    with epoll_pwait. [Seymour]
  - Add compat implementation of epoll_pwait1.

Justification
=============

QEMU, among many select/poll based applications, considers epoll as an
alternative when its event loop needs to handle a big number of FDs. However,
there are currently two concerns with epoll which prevents the switching:

The major one is the timeout precision. For example in QEMU, the main loop
takes care of calling callbacks at a specific timeout - the QEMU timer API. The
timeout value in ppoll depends on the next firing timer. epoll_pwait's
millisecond timeout is so coarse that rounding up the timeout will hurt
performance badly.

The minor one is the number of system call to update fd set. While epoll can
handle a large number of fds quickly, it still requires one epoll_ctl per fd
update, compared to the one-shot call to select/poll with an fd array. This may
as well make epoll inferior to ppoll in the cases where a small, but frequently
changing set of fds are polled by the event loop.

This series introduces two new epoll sys calls to address them respectively.
The idea of epoll_ctl_batch is suggested by Andy Lutomirski in [1], who also
suggested clockid as a parameter in epoll_pwait1.

[1]: http://lists.openwall.net/linux-kernel/2015/01/08/542

Benchmark for epoll_pwait1
==========================

By running fio tests inside VM with both original and modified QEMU, we can
compare their difference in performance.

With a small VM setup [t1], the original QEMU (ppoll based) has an 4k read
latency overhead around 37 us. In this setup, the main loop polls 10~20 fds.

With a slightly larger VM instance [t2] - attached a virtio-serial device so
that there are 80~90 fds in the main loop - the original QEMU has a latency
overhead around 49 us. By adding more such devices [t3], we can see the latency
go even higher - 83 us with ~200 FDs.

Now modify QEMU to use epoll_pwait1 and test again, the latency numbers are
repectively 36us, 37us, 47us for t1, t2 and t3.

Previous Changelogs
===================

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

1) epoll_ctl_batch
------------------

NAME
       epoll_ctl_batch - batch control interface for an epoll descriptor

SYNOPSIS

       #include <sys/epoll.h>

       int epoll_ctl_batch(int epfd, int flags,
                           int ncmds, struct epoll_ctl_cmd *cmds);

DESCRIPTION

       This system call is an extension of epoll_ctl(). The primary difference
       is that this system call allows you to batch multiple operations with
       the one system call. This provides a more efficient interface for
       updating events on this epoll file descriptor epfd.

       The flags argument is reserved and must be 0.

       The argument ncmds is the number of cmds entries being passed in.
       This number must be greater than 0.

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

       This system call is not atomic when updating the epoll descriptor.  All
       entries in cmds are executed in the provided order. If any cmds entry
       fails to be processed, no further entries are processed and the number
       of successfully processed entries is returned.

       Each single operation defined by a struct epoll_ctl_cmd has the same
       semantics as an epoll_ctl(2) call. See the epoll_ctl() manual page for
       more information about how to correctly setup the members of a struct
       epoll_ctl_cmd.

       Upon completion of the call the result member of each struct
       epoll_ctl_cmd may be set to 0 (sucessfully completed) or an error code
       depending on the result of the command. If the kernel fails to change
       the result (for example the location of the cmds argument is fully or
       partly read only) the result member of each struct epoll_ctl_cmd may be
       unchanged. 

RETURN VALUE

       epoll_ctl_batch() returns a number greater than 0 to indicate the number
       of cmnd entries processed. If all entries have been processed this will
       equal the ncmds parameter passed in.

       If one or more parameters are incorrect the value returned is -1 with
       errno set appropriately - no cmds entries have been processed when this
       happens.

       If processing any entry in the cmds argument results in an error, the
       number returned is the index of the failing entry - this number will be
       less than ncmds. Since ncmds must be greater than 0, a return value of 0
       indicates an error associated with the very first cmds entry. A return
       value of 0 does not indicate a successful system call.

       To correctly test the return value from epoll_ctl_batch() use code
       similar to the following:

		ret = epoll_ctl_batch(epfd, flags, ncmds, &cmds);
		if (ret < ncmds) {
			if (ret == -1) {
				/* An argument was invalid */
			} else {
				/* ret contains the number of successful entries
                                 * processed. If you (mis?)use it as a C index it
                                 * will index directly to the failing entry to
                                 * get the result use cmds[ret].result which may 
                                 * contain the errno value associated with the
                                 * entry.
                                 */
			}
		} else {
			/* Success */
		}

ERRORS

       EINVAL flags is non-zero; ncmds is less than or equal to zero, or
              greater than (INT_MAX / sizeof(struct epoll_ctl_cmd); cmds is
              NULL;

       ENOMEM There was insufficient memory to handle the requested op control
              operation.

       EFAULT The memory area pointed to by cmds is not accessible.

       In the event that the return value is not the same as the ncmds
       parameter, the result member of the failing struct epoll_ctl_cmd will
       contain a negative errno value related to the error, unless the memory
       area is not writable (EFAULT returned). The errno values that can be set
       are those documented on the epoll_ctl(2) manual page.
       

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

       The epoll_pwait1() syscall has more elaborate parameters compared to
       epoll_pwait(), in order to allow fine control of the wait.

       The epfd, events and maxevents parameters are the same
       as in epoll_wait() and epoll_pwait(). The flags and params are new.

       The flags is reserved and must be zero.

       The params is a pointer to a struct epoll_wait_params which is
       defined as:

           struct epoll_wait_params {
               int clockid;
               struct timespec *timeout;
               sigset_t *sigmask;
               size_t sigsetsize;
           };

       The clockid member must be either CLOCK_REALTIME or CLOCK_MONOTONIC.
       This will choose the clock type to use for timeout. This differs to
       epoll_pwait(2) which has an implicit clock type of CLOCK_MONOTONIC.
       
       The timeout member specifies the minimum time that epoll_wait(2) will
       block. The time spent waiting will be rounded up to the clock
       granularity. Kernel scheduling delays mean that the blocking
       interval may overrun by a small amount. Specifying NULL will cause
       causes epoll_pwait1(2) to block indefinitely. Specifying a timeout
       equal to zero (both tv_sec and tv_nsec are zero) causes epoll_pwait1(2)
       to return immediately, even if no events are available.

       Both sigmask and sigsetsize have the same semantics as epoll_pwait(2).
       The sigmask field may be specified as NULL, in which case
       epoll_pwait1(2) will behave like epoll_wait(2).

   User visibility of sigsetsize

       In epoll_pwait(2) and other syscalls, sigsetsize is not visible to
       an application developer as glibc has a wrapper around epoll_pwait(2).
       Now we pack several parameters in epoll_wait_params. In
       order to hide sigsetsize from application code this system call also
       needs to be wrapped either by expanding parameters and building the
       structure in the wrapper function, or by only asking application to
       provide this part of the structure:

           struct epoll_wait_params_user {
               int clockid;
               struct timespec *timeout;
               sigset_t *sigmask;
           };

      In the wrapper function it would be copied to a full structure with
      sigsetsize filled in.

RETURN VALUE

       When successful, epoll_wait1() returns the number of file descriptors
       ready for the requested I/O, or zero if no file descriptor became ready
       during the requested timeout nanoseconds. When an error occurs,
       epoll_wait1() returns -1 and errno is set appropriately.

ERRORS

       This system call can set errno to the same values as epoll_pwait(2), 
       as well as the following additional reasons:

       EINVAL flags is not zero, or clockid is not one of CLOCK_REALTIME or
              CLOCK_MONOTONIC, or the timespec data pointed to by timeout is
              not valid.

       EFAULT The memory area pointed to by params, params.sigmask or
              params.timeout is not accessible.

CONFORMING TO

       epoll_pwait1() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)

Fam Zheng (9):
  epoll: Extract epoll_wait_do and epoll_pwait_do
  epoll: Specify clockid explicitly
  epoll: Extract ep_ctl_do
  epoll: Add implementation for epoll_ctl_batch
  x86: Hook up epoll_ctl_batch syscall
  epoll: Add implementation for epoll_pwait1
  x86: Hook up epoll_pwait1 syscall
  epoll: Add compat version implementation of epoll_pwait1
  x86: Hook up 32 bit compat epoll_pwait1 syscall

 arch/x86/syscalls/syscall_32.tbl |   2 +
 arch/x86/syscalls/syscall_64.tbl |   2 +
 fs/eventpoll.c                   | 308 ++++++++++++++++++++++++++++-----------
 include/linux/compat.h           |   6 +
 include/linux/syscalls.h         |   9 ++
 include/uapi/linux/eventpoll.h   |  19 +++
 6 files changed, 262 insertions(+), 84 deletions(-)

-- 
1.9.3
