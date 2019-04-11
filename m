From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC-2 PATCH 4/4] samples: show race-free pidfd metadata access
Date: Wed, 10 Apr 2019 17:08:35 -0700
Message-ID: <CAKOZuetKjhWM6Pqi4GfPCSDwzYZY4Digu3h3ThXv1jqwV2Qm6A@mail.gmail.com>
References: <20190410234045.29846-1-christian@brauner.io> <20190410234045.29846-6-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410234045.29846-6-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Joel
List-Id: linux-api@vger.kernel.org

Thanks for providing this example. A new nits below.

On Wed, Apr 10, 2019 at 4:43 PM Christian Brauner <christian@brauner.io> wrote:
>
> This is an sample program to show userspace how to get race-free access to
> process metadata from a pidfd.
> It is really not that difficult and instead of burdening the kernel with
> this task by using fds to /proc/<pid> we can simply add a helper to libc
> that does it for the user.
>
> Signed-off-by: Christian Brauner <christian@brauner.io>
> Signed-off-by: Jann Horn <jann@thejh.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
> Cc: "Dmitry V. Levin" <ldv@altlinux.org>
> Cc: Andy Lutomirsky <luto@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  samples/Makefile               |   2 +-
>  samples/pidfd/Makefile         |   6 ++
>  samples/pidfd/pidfd-metadata.c | 169 +++++++++++++++++++++++++++++++++
>  3 files changed, 176 insertions(+), 1 deletion(-)
>  create mode 100644 samples/pidfd/Makefile
>  create mode 100644 samples/pidfd/pidfd-metadata.c
>
> diff --git a/samples/Makefile b/samples/Makefile
> index b1142a958811..fadadb1c3b05 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -3,4 +3,4 @@
>  obj-$(CONFIG_SAMPLES)  += kobject/ kprobes/ trace_events/ livepatch/ \
>                            hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
>                            configfs/ connector/ v4l/ trace_printk/ \
> -                          vfio-mdev/ statx/ qmi/ binderfs/
> +                          vfio-mdev/ statx/ qmi/ binderfs/ pidfd/
> diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
> new file mode 100644
> index 000000000000..0ff97784177a
> --- /dev/null
> +++ b/samples/pidfd/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +hostprogs-y := pidfd-metadata
> +always := $(hostprogs-y)
> +HOSTCFLAGS_pidfd-metadata.o += -I$(objtree)/usr/include
> +all: pidfd-metadata
> diff --git a/samples/pidfd/pidfd-metadata.c b/samples/pidfd/pidfd-metadata.c
> new file mode 100644
> index 000000000000..c46c6c34a012
> --- /dev/null
> +++ b/samples/pidfd/pidfd-metadata.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define _GNU_SOURCE
> +#include <err.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <inttypes.h>
> +#include <limits.h>
> +#include <sched.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +
> +#ifndef CLONE_PIDFD
> +#define CLONE_PIDFD 0x00001000
> +#endif
> +
> +static int raw_clone_pidfd(void)
> +{
> +       unsigned long flags = CLONE_PIDFD;
> +
> +#if defined(__s390x__) || defined(__s390__) || defined(__CRIS__)
> +       /* On s390/s390x and cris the order of the first and second arguments
> +         * of the system call is reversed.
> +         */
> +       return (int)syscall(__NR_clone, NULL, flags | SIGCHLD);
> +#elif defined(__sparc__) && defined(__arch64__)
> +       {
> +               /*
> +                 * sparc64 always returns the other process id in %o0, and a
> +                 * boolean flag whether this is the child or the parent in %o1.
> +                 * Inline assembly is needed to get the flag returned in %o1.
> +                 */
> +               int in_child;
> +               int child_pid;
> +               asm volatile("mov %2, %%g1\n\t"
> +                            "mov %3, %%o0\n\t"
> +                            "mov 0 , %%o1\n\t"
> +                            "t 0x6d\n\t"
> +                            "mov %%o1, %0\n\t"
> +                            "mov %%o0, %1"
> +                            : "=r"(in_child), "=r"(child_pid)
> +                            : "i"(__NR_clone), "r"(flags | SIGCHLD)
> +                            : "%o1", "%o0", "%g1");
> +
> +               if (in_child)
> +                       return 0;
> +               else
> +                       return child_pid;
> +       }
> +#elif defined(__ia64__)
> +       /* On ia64 the stack and stack size are passed as separate arguments. */
> +       return (int)syscall(__NR_clone, flags | SIGCHLD, NULL, prctl_arg(0));
> +#else
> +       return (int)syscall(__NR_clone, flags | SIGCHLD, NULL);
> +#endif
> +}
> +
> +static inline int sys_pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
> +                                       unsigned int flags)
> +{
> +       return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
> +}
> +
> +static int pidfd_metadata_fd(int pidfd)
> +{
> +       int procfd, ret;
> +       char path[100];
> +       FILE *f;
> +       size_t n = 0;
> +       char *line = NULL;
> +
> +       snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
> +
> +       f = fopen(path, "re");
> +       if (!f)
> +               return -1;
> +
> +       ret = 0;
> +       while (getline(&line, &n, f) != -1) {
> +               char *numstr;
> +               size_t len;
> +
> +               if (strncmp(line, "Pid:\t", 5))
> +                       continue;
> +
> +               numstr = line + 5;
> +               len = strlen(numstr);
> +               if (len > 0 && numstr[len - 1] == '\n')
> +                       numstr[len - 1] = '\0';
> +               ret = snprintf(path, sizeof(path), "/proc/%s", numstr);
> +               break;
> +       }
> +       free(line);
> +       fclose(f);
> +
> +       if (!ret) {
> +               errno = ENOENT;
> +               warn("Failed to parse pid from fdinfo\n");
> +               return -1;
> +       }
> +
> +       procfd = open(path, O_DIRECTORY | O_RDONLY | O_CLOEXEC);
> +       if (procfd < 0) {
> +               warn("Failed to open %s\n", path);
> +               return -1;
> +       }
> +
> +       /*
> +        * Verify that the pid has not been recycled and our /proc/<pid> handle
> +        * is still valid.
> +        */
> +       if (sys_pidfd_send_signal(pidfd, 0, NULL, 0) < 0) {
> +               /* process does not exist */
> +               if (errno == ESRCH) {
> +                       warn("The pid was recycled\n");

ITYM that the process was reaped.

> +                       close(procfd);
> +                       return -1;
> +               }
> +
> +               /* just not allowed to signal it */

I'd look for EPERM specifically instead of just assuming that any
error indicates that a permission failure. I'd also explicitly state
that EPERM still implies process existence.

> +       }
> +
> +       return procfd;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       int procfd, ret = EXIT_FAILURE;
> +       ssize_t bytes;
> +       char buf[4096] = { 0 };
> +
> +       int pidfd = raw_clone_pidfd();
> +       if (pidfd < 0)
> +               return -1;
> +
> +       if (pidfd == 0) {
> +               printf("%d\n", getpid());
> +               exit(EXIT_SUCCESS);
> +       }
> +
> +       procfd = pidfd_metadata_fd(pidfd);
> +       close(pidfd);
> +       if (procfd < 0)
> +               goto out;
> +
> +       int statusfd = openat(procfd, "status", O_RDONLY | O_CLOEXEC);
> +       close(procfd);
> +       if (statusfd < 0)
> +               goto out;
> +
> +       bytes = read(statusfd, buf, sizeof(buf));
> +       if (bytes > 0)
> +               bytes = write(STDOUT_FILENO, buf, bytes);
> +       close(statusfd);
> +
> +out:
> +       (void)wait(NULL);
> +       if (bytes < 0 || ret)
> +               exit(EXIT_FAILURE);
> +
> +       exit(EXIT_SUCCESS);
> +}
> --
> 2.21.0
>
