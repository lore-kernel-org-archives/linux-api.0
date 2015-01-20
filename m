From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Date: Tue, 20 Jan 2015 17:57:52 +0800
Message-ID: <1421747878-30744-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This adds a new system call, epoll_mod_wait. It's described as below:

NAME
       epoll_mod_wait - modify and wait for I/O events on an epoll file
                        descriptor

SYNOPSIS

       int epoll_mod_wait(int epfd, int flags,
                          int ncmds, struct epoll_mod_cmd *cmds,
                          struct epoll_wait_spec *spec);

DESCRIPTION

       The epoll_mod_wait() system call can be seen as an enhanced combination
       of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
       call. It is superior in two cases:
       
       1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
       will save context switches between user mode and kernel mode;
       
       2) When you need higher precision than microsecond for wait timeout.

       The epoll_ctl(2) operations are embedded into this call by with ncmds
       and cmds. The latter is an array of command structs:

           struct epoll_mod_cmd {

                  /* Reserved flags for future extension, must be 0 for now. */
                  int flags;

                  /* The same as epoll_ctl() op parameter. */
                  int op;

                  /* The same as epoll_ctl() fd parameter. */
                  int fd;

                  /* The same as the "events" field in struct epoll_event. */
                  uint32_t events;

                  /* The same as the "data" field in struct epoll_event. */
                  uint64_t data;

                  /* Output field, will be set to the return code once this
                   * command is executed by kernel */
                  int error;
           };
       
       There is no guartantee that all the commands are executed in order. Only
       if all the commands are successfully executed (all the error fields are
       set to 0), events are polled.

       The last parameter "spec" is a pointer to struct epoll_wait_spec, which
       contains the information about how to poll the events. If it's NULL, this
       call will immediately return after running all the commands in cmds.

       The structure is defined as below:

           struct epoll_wait_spec {

                  /* The same as "maxevents" in epoll_pwait() */
                  int maxevents;

                  /* The same as "events" in epoll_pwait() */
                  struct epoll_event *events;

                  /* Which clock to use for timeout */
                  int clockid;

                  /* Maximum time to wait if there is no event */
                  struct timespec timeout;

                  /* The same as "sigmask" in epoll_pwait() */
                  sigset_t *sigmask;

                  /* The same as "sigsetsize" in epoll_pwait() */
                  size_t sigsetsize;
           } EPOLL_PACKED;

RETURN VALUE

       When any error occurs, epoll_mod_wait() returns -1 and errno is set
       appropriately. All the "error" fields in cmds are unchanged before they
       are executed, and if any cmds are executed, the "error" fields are set
       to a return code accordingly. See also epoll_ctl for more details of the
       return code.

       When successful, epoll_mod_wait() returns the number of file
       descriptors ready for the requested I/O, or zero if no file descriptor
       became ready during the requested timeout milliseconds.

       If spec is NULL, it returns 0 if all the commands are successful, and -1
       if an error occured.

ERRORS

       These errors apply on either the return value of epoll_mod_wait or error
       status for each command, respectively.

       EBADF  epfd or fd is not a valid file descriptor.

       EFAULT The memory area pointed to by events is not accessible with write
              permissions.

       EINTR  The call was interrupted by a signal handler before either any of
              the requested events occurred or the timeout expired; see
              signal(7).

       EINVAL epfd is not an epoll file descriptor, or maxevents is less than
              or equal to zero, or fd is the same as epfd, or the requested
              operation op is not supported by this interface.

       EEXIST op was EPOLL_CTL_ADD, and the supplied file descriptor fd is
              already registered with this epoll instance.

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

       epoll_mod_wait() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)

Fam Zheng (6):
  epoll: Extract epoll_wait_do and epoll_pwait_do
  epoll: Specify clockid explicitly
  epoll: Add definition for epoll_mod_wait structures
  epoll: Extract ep_ctl_do
  epoll: Add implementation for epoll_mod_wait
  x86: Hook up epoll_mod_wait syscall

 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   1 +
 fs/eventpoll.c                   | 219 +++++++++++++++++++++++++--------------
 include/linux/syscalls.h         |   5 +
 include/uapi/linux/eventpoll.h   |  20 ++++
 5 files changed, 167 insertions(+), 79 deletions(-)

-- 
1.9.3
