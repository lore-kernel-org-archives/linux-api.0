From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/6] x86: Opt into HAVE_COPY_THREAD_TLS, for both 32-bit
 and 64-bit
Date: Fri, 13 Mar 2015 15:01:16 -0700
Message-ID: <CALCETrUbQJhE8VCTt5yQ+KBZOJnNC5e3yUneKjhwhKxgvfU2Xg@mail.gmail.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <cf79b9f0c40314e6bfda7c634e378015bd7ba037.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cf79b9f0c40314e6bfda7c634e378015bd7ba037.1426180120.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 12, 2015 at 6:40 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> For 32-bit userspace on a 64-bit kernel, this requires modifying
> stub32_clone to actually swap the appropriate arguments to match
> CONFIG_CLONE_BACKWARDS, rather than just leaving the C argument for tls
> broken.
>
> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Signed-off-by: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/Kconfig             | 1 +
>  arch/x86/ia32/ia32entry.S    | 2 +-
>  arch/x86/kernel/process_32.c | 6 +++---
>  arch/x86/kernel/process_64.c | 8 ++++----
>  4 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b7d31ca..4960b0d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -124,6 +124,7 @@ config X86
>         select MODULES_USE_ELF_REL if X86_32
>         select MODULES_USE_ELF_RELA if X86_64
>         select CLONE_BACKWARDS if X86_32
> +       select HAVE_COPY_THREAD_TLS
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_QUEUE_RWLOCK
>         select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 156ebca..0286735 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -487,7 +487,7 @@ GLOBAL(\label)
>         ALIGN
>  GLOBAL(stub32_clone)
>         leaq sys_clone(%rip),%rax
> -       mov     %r8, %rcx
> +       xchg %r8, %rcx
>         jmp  ia32_ptregs_common

Do I understand correct that whatever function this is a stub for just
takes its arguments in the wrong order?  If so, can we just fix it
instead of using xchg here?

In general, I much prefer C code to new asm where it makes sense to
make this tradeoff.

Other than that, this is a huge improvement.  You'll have minor
conflicts against -tip, though.

--Andy
