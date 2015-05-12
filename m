From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Define syscall number for fchmodat4
Date: Tue, 12 May 2015 10:49:01 +0200
Message-ID: <CAHO5Pa1nvKB1g1i6vXqFkT1+BRwnV4KbCQi34F3Z=AmHci7jdg@mail.gmail.com>
References: <1431310042-52247-1-git-send-email-will@worrbase.com> <1431310042-52247-3-git-send-email-will@worrbase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431310042-52247-3-git-send-email-will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: William Orr <will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Ayer <agwa-vM4+sZUQx5cvLxMWut27OA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[expanding CC]

On Mon, May 11, 2015 at 4:07 AM, William Orr <will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org> wrote:
> ---
>  arch/x86/syscalls/syscall_32.tbl  | 1 +
>  arch/x86/syscalls/syscall_64.tbl  | 1 +
>  include/uapi/asm-generic/unistd.h | 4 +++-
>  3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index ef8187f..cc8ada8 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -365,3 +365,4 @@
>  356    i386    memfd_create            sys_memfd_create
>  357    i386    bpf                     sys_bpf
>  358    i386    execveat                sys_execveat                    stub32_execveat
> +359    i386    fchmodat4               sys_fchmodat4
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 9ef32d5..bbf8c6b 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -329,6 +329,7 @@
>  320    common  kexec_file_load         sys_kexec_file_load
>  321    common  bpf                     sys_bpf
>  322    64      execveat                stub_execveat
> +323    common  fchmodat4               sys_fchmodat4
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index e016bd9..6e362a2 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
>  __SYSCALL(__NR_bpf, sys_bpf)
>  #define __NR_execveat 281
>  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
> +#define __NR_fchmodat4 282
> +__SYSCALL(__NR_fchmodat4, sys_fchmodat4);
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 282
> +#define __NR_syscalls 283
>
>  /*
>   * All syscalls below here should go away really,
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
