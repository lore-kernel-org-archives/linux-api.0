From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Thu, 18 Jul 2019 17:10:21 +0200
Message-ID: <CAK8P3a33rGhPDFfRBAQyLTMG_WoEgX_toDgWR2O7rSwxKsZG+w@mail.gmail.com>
References: <20190706145737.5299-1-cyphar@cyphar.com> <20190706145737.5299-9-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190706145737.5299-9-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, alpha <linux-alp>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 6, 2019 at 5:00 PM Aleksa Sarai <cyphar@cyphar.com> wrote:

> diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
> index 9e7704e44f6d..1703d048c141 100644
> --- a/arch/alpha/kernel/syscalls/syscall.tbl
> +++ b/arch/alpha/kernel/syscalls/syscall.tbl
> @@ -461,6 +461,7 @@
>  530    common  getegid                         sys_getegid
>  531    common  geteuid                         sys_geteuid
>  532    common  getppid                         sys_getppid
> +533    common  openat2                         sys_openat2
>  # all other architectures have common numbers for new syscall, alpha
>  # is the exception.
>  534    common  pidfd_send_signal               sys_pidfd_send_signal

My plan here was to add new syscalls in the same order as everwhere else,
just with the number 110 higher. In the long run, I hope we can automate
this.

> diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
> index aaf479a9e92d..4ad262698396 100644
> --- a/arch/arm/tools/syscall.tbl
> +++ b/arch/arm/tools/syscall.tbl
> @@ -447,3 +447,4 @@
>  431    common  fsconfig                        sys_fsconfig
>  432    common  fsmount                         sys_fsmount
>  433    common  fspick                          sys_fspick
> +434    common  openat2                         sys_openat2

434 is already used in linux-next, I suggest you use 437 (Palmer
just submitted fchmodat4, which could become 436).

> +/**
> + * Arguments for how openat2(2) should open the target path. If @extra is zero,
> + * then openat2(2) is identical to openat(2).
> + *
> + * @flags: O_* flags (unknown flags ignored).
> + * @mode: O_CREAT file mode (ignored otherwise).
> + * @upgrade_mask: restrict how the O_PATH may be re-opened (ignored otherwise).
> + * @resolve: RESOLVE_* flags (-EINVAL on unknown flags).
> + * @reserved: reserved for future extensions, must be zeroed.
> + */
> +struct open_how {
> +       __u32 flags;
> +       union {
> +               __u16 mode;
> +               __u16 upgrade_mask;
> +       };
> +       __u16 resolve;
> +       __u64 reserved[7]; /* must be zeroed */
> +};

We can have system calls with up to six arguments on all architectures, so
this could still be done more conventionally without the indirection: like

long openat2(int dfd, const char __user * filename, int flags, mode_t
mode_mask, __u16 resolve);

In fact, that seems similar enough to the existing openat() that I think
you could also just add the fifth argument to the existing call when
a newly defined flag is set, similarly to how we only use the 'mode'
argument when O_CREAT or O_TMPFILE are set.

> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h

This file seems to lack a declaration for the system call, which means it
will cause a build failure on some architectures, e.g. arch/arc/kernel/sys.c:

#define __SYSCALL(nr, call) [nr] = (call),
void *sys_call_table[NR_syscalls] = {
        [0 ... NR_syscalls-1] = sys_ni_syscall,
#include <asm/unistd.h>
};

        Arnd
