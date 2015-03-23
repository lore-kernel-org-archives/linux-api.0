From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/7] Introduce a new clone4 syscall with more flag bits
 and extensible arguments
Date: Mon, 23 Mar 2015 14:11:45 +0000
Message-ID: <CAHse=S_0G028D2f1vO=1EBO-TM1ZyJZT3-VE4O3a9dS-VcdKzg@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <367b888ef58831b6812c3cf80ca973c65edc67f5.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <367b888ef58831b6812c3cf80ca973c65edc67f5.1426376419.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 15, 2015 at 7:59 AM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 0286735..ba28306 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -483,6 +483,7 @@ GLOBAL(\label)
>         PTREGSCALL stub32_execveat, compat_sys_execveat
>         PTREGSCALL stub32_fork, sys_fork
>         PTREGSCALL stub32_vfork, sys_vfork
> +       PTREGSCALL stub32_clone4, compat_sys_clone4
>
>         ALIGN
>  GLOBAL(stub32_clone)
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1d74d16..ead143f 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -520,6 +520,7 @@ END(\label)
>         FORK_LIKE  clone
>         FORK_LIKE  fork
>         FORK_LIKE  vfork
> +       FORK_LIKE  clone4
>         FIXED_FRAME stub_iopl, sys_iopl
>
>  ENTRY(stub_execve)
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index b3560ec..56fcc90 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -365,3 +365,4 @@
>  356    i386    memfd_create            sys_memfd_create
>  357    i386    bpf                     sys_bpf
>  358    i386    execveat                sys_execveat                    stub32_execveat
> +359    i386    clone4                  sys_clone4                      stub32_clone4
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 8d656fb..af15b0f 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -329,6 +329,7 @@
>  320    common  kexec_file_load         sys_kexec_file_load
>  321    common  bpf                     sys_bpf
>  322    64      execveat                stub_execveat
> +323    64      clone4                  stub_clone4
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> @@ -368,3 +369,4 @@
>  543    x32     io_setup                compat_sys_io_setup
>  544    x32     io_submit               compat_sys_io_submit
>  545    x32     execveat                stub_x32_execveat
> +546    x32     clone4                  stub32_clone4

Doesn't this need an x32 specific wrapper (to ensure the full
set of registers are saved)?
