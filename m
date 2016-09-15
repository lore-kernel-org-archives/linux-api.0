From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 1/3] syscalls,x86 Expose arch_prctl on x86-32.
Date: Thu, 15 Sep 2016 16:51:29 -0700
Message-ID: <CALCETrVuW8njC-AzszLP7f2jV=2j7X=Qit131iQT=npL-30nKw@mail.gmail.com>
References: <20160915233324.6060-1-khuey@kylehuey.com> <20160915233324.6060-2-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915233324.6060-2-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Huey <me@kylehuey.com>
Cc: Robert O'Callahan <robert@ocallahan.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Borislav Petkov <bp@suse.de>, Linux API <linux-api@vger.kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, Andy Lutomirski <luto@kernel.org>, Zach Brown <zab@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 15, 2016 at 4:33 PM, Kyle Huey <me@kylehuey.com> wrote:
> arch_prctl is currently 64-bit only. Wire it up for 32-bits, as a no-op for
> now. Rename the second arg to a more generic name.
>
> Signed-off-by: Kyle Huey <khuey@kylehuey.com>
> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |  1 +
>  arch/x86/include/asm/proto.h           |  5 ++++-
>  arch/x86/kernel/process.c              | 10 ++++++++++
>  arch/x86/kernel/process_64.c           | 33 +++++++++++++++++++++------------
>  arch/x86/kernel/ptrace.c               |  8 ++++----
>  arch/x86/um/Makefile                   |  2 +-
>  arch/x86/um/syscalls_32.c              |  7 +++++++
>  arch/x86/um/syscalls_64.c              |  4 ++--
>  include/linux/compat.h                 |  2 ++
>  9 files changed, 52 insertions(+), 20 deletions(-)
>  create mode 100644 arch/x86/um/syscalls_32.c
>
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index f848572..666fa61 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -386,3 +386,4 @@
>  377    i386    copy_file_range         sys_copy_file_range
>  378    i386    preadv2                 sys_preadv2                     compat_sys_preadv2
>  379    i386    pwritev2                sys_pwritev2                    compat_sys_pwritev2
> +380    i386    arch_prctl              compat_sys_arch_prctl           compat_sys_arch_prctl

Let's call this sys_arch_prctl_32, even if it's unconventional.  See below.

> diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> index 9b9b30b..f0e86aa 100644
> --- a/arch/x86/include/asm/proto.h
> +++ b/arch/x86/include/asm/proto.h
> @@ -30,6 +30,9 @@ void x86_report_nx(void);
>
>  extern int reboot_force;
>
> -long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
> +long do_arch_prctl_common(struct task_struct *task, int code, unsigned long addr);
> +#ifdef CONFIG_X86_64
> +long do_arch_prctl_64(struct task_struct *task, int code, unsigned long addr);
> +#endif
>
>  #endif /* _ASM_X86_PROTO_H */
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 62c0b0e..1421451 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -567,3 +567,13 @@ unsigned long get_wchan(struct task_struct *p)
>         } while (count++ < 16 && p->state != TASK_RUNNING);
>         return 0;
>  }
> +
> +long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
> +{
> +       return -EINVAL;
> +}
> +
> +asmlinkage long compat_sys_arch_prctl(int code, unsigned long arg2)

I believe you mean COMPAT_SYSCALL_DEFINE2 here.

But I see what you're doing here.  Could you instead do:

#if defined(CONFIG_IA32_EMULATION) || defined(CONFIG_X86_32)
#ifdef CONFIG_X86_32
COMPAT_SYSCALL_DEFINE2(...)
#else
SYSCALL_DEFINE2(...)
#endif

... body here ...
#endif

and name the thing do_arch_prctl_32?

It's too bad we don't have a SYSCALL_DEFINE_32 macro.  But you could add one...


> diff --git a/arch/x86/um/syscalls_32.c b/arch/x86/um/syscalls_32.c
> new file mode 100644
> index 0000000..c6812c1
> --- /dev/null
> +++ b/arch/x86/um/syscalls_32.c
> @@ -0,0 +1,7 @@
> +#include <linux/syscalls.h>
> +#include <os.h>
> +
> +long compat_sys_arch_prctl(int code, unsigned long arg2)

COMPAT_SYSCALL_DEFINE2

Also, does this really need a new file?

> -long sys_arch_prctl(int code, unsigned long addr)
> +long sys_arch_prctl(int code, unsigned long arg2)

SYSCALL_DEFINE2
