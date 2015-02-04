From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v2 0/7] epoll: Introduce new syscalls, epoll_ctl_batch and epoll_pwait1
Date: Wed,  4 Feb 2015 18:36:46 +0800
Message-ID: <1423046213-7043-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Changes from v1 (https://lkml.org/lkml/2015/1/20/189):

  - As discussed in previous thread [1], split the call to epoll_ctl_batch and
    epoll_pwait. [Michael]

  - Fix memory leaks. [Omar]

  - Add a short comment about the ignored copy_to_user failure. [Omar]

  - Cover letter rewritten.

This adds two new system calls as described below. I mentioned glibc wrapping
of sigarg in epoll_pwait1 description, so don't read it as end user man page
yet.

One caveat is the possible failure of the last copy_to_user in epoll_ctl_batch,
which returns per command error code. Ideas to improve that are welcome!

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
                  int error_hint;
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

       Each error_hint field may be set to the error code or 0, depending on
       the result of the command. If there is some error in returning the error
       to user, it may also be unchanged, even though the command may actually
       be executed. In this case, it's still ensured that the i-th (i = ret)
       command is the failed command.

ERRORS

       Errors for the overall system call (in errno) are:

       EINVAL flags is non-zero, or ncmds is less than or equal to zero, or
              cmds is NULL.

       ENOMEM There was insufficient memory to handle the requested op control
              operation.

       EFAULT The memory area pointed to by cmds is not accessible with write
              permissions.


       Errors for each command (in error_hint) are:

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
                        struct timespec *timeout,
                        struct sigargs *sig);

DESCRIPTION

       The epoll_pwait1 system call differs from epoll_pwait only in parameter
       types. The first difference is timeout, a pointer to timespec structure
       which allows nanosecond presicion; the second difference, which should
       probably be wrapper by glibc and only expose a sigset_t pointer as in
       pselect6.

       If timeout is NULL, it's treated as if 0 is specified in epoll_pwait
       (return immediately). Otherwise it's converted to nanosecond scalar,
       again, with the same convention as epoll_pwait's timeout.

RETURN VALUE

       The same as said in epoll_pwait(2).

ERRORS

       The same as said in man epoll_pwait(2), plus:

       EINVAL flags is not zero.


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
 fs/eventpoll.c                   | 241 ++++++++++++++++++++++++++-------------
 include/linux/syscalls.h         |   9 ++
 include/uapi/linux/eventpoll.h   |  11 ++
 5 files changed, 186 insertions(+), 79 deletions(-)

-- 
1.9.3
