From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCHv4 RESEND 1/3] syscalls,x86: implement execveat() system call
Date: Mon, 23 Jun 2014 11:39:28 -0700
Message-ID: <CAGXu5jKDzEaza9gYnjZvyM=tYLrFLZW-mMUShr6rNRHCUekong@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
	<1401975635-6162-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401975635-6162-2-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This patch set adds execveat(2) for x86, and is derived from Meredydd
> Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).
>
> The primary aim of adding an execveat syscall is to allow an
> implementation of fexecve(3) that does not rely on the /proc
> filesystem.  The current glibc version of fexecve(3) is implemented
> via /proc, which causes problems in sandboxed or otherwise restricted
> environments.
>
> Given the desire for a /proc-free fexecve() implementation, HPA
> suggested (https://lkml.org/lkml/2006/7/11/556) that an execveat(2)
> syscall would be an appropriate generalization.
>
> Also, having a new syscall means that it can take a flags argument
> without back-compatibility concerns.  The current implementation just
> defines the AT_SYMLINK_NOFOLLOW flag, but other flags could be added
> in future -- for example, flags for new namespaces (as suggested at
> https://lkml.org/lkml/2006/7/11/474).
>
> Related history:
>  - https://lkml.org/lkml/2006/12/27/123 is an example of someone
>    realizing that fexecve() is likely to fail in a chroot environment.
>  - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043 covered
>    documenting the /proc requirement of fexecve(3) in its manpage, to
>    "prevent other people from wasting their time".
>  - https://bugzilla.kernel.org/show_bug.cgi?id=74481 documented that
>    it's not possible to fexecve() a file descriptor for a script with
>    close-on-exec set (which is possible with the implementation here).
>  - https://bugzilla.redhat.com/show_bug.cgi?id=241609 described a
>    problem where a process that did setuid() could not fexecve()
>    because it no longer had access to /proc/self/fd; this has since
>    been fixed.
>
> This patch in particular (of 3 = 2 kernel + 1 man-pages):
>
> Adds the new system execveat(2) syscall. execveat() is to execve() as
> openat() is to open(): it takes a file descriptor that refers to a
> directory, and resolves the filename relative to that.
>
> In addition, if the filename is NULL, execveat() executes the file
> to which the file descriptor refers. This replicates the functionality
> of fexecve(), which is a system call in other UNIXen, but in Linux
> glibc it depends on /proc being mounted.
>
> Only x86-64, i386 and x32 ABIs are supported in this patch.
>
> Based on patches by Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>
>
> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Al,

Any thoughts on this? I think it would be quite handy.

-Kees

> ---
>  arch/x86/ia32/audit.c             |   1 +
>  arch/x86/ia32/ia32entry.S         |   1 +
>  arch/x86/kernel/audit_64.c        |   1 +
>  arch/x86/kernel/entry_64.S        |  28 +++++++
>  arch/x86/syscalls/syscall_32.tbl  |   1 +
>  arch/x86/syscalls/syscall_64.tbl  |   2 +
>  arch/x86/um/sys_call_table_64.c   |   1 +
>  fs/exec.c                         | 153 ++++++++++++++++++++++++++++++++------
>  include/linux/compat.h            |   3 +
>  include/linux/sched.h             |   4 +
>  include/linux/syscalls.h          |   4 +
>  include/uapi/asm-generic/unistd.h |   4 +-
>  kernel/sys_ni.c                   |   3 +
>  lib/audit.c                       |   3 +
>  14 files changed, 186 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
> index 5d7b381da692..2eccc8932ae6 100644
> --- a/arch/x86/ia32/audit.c
> +++ b/arch/x86/ia32/audit.c
> @@ -35,6 +35,7 @@ int ia32_classify_syscall(unsigned syscall)
>         case __NR_socketcall:
>                 return 4;
>         case __NR_execve:
> +       case __NR_execveat:
>                 return 5;
>         default:
>                 return 1;
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 4299eb05023c..2516c09743e0 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -464,6 +464,7 @@ GLOBAL(\label)
>         PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn
>         PTREGSCALL stub32_sigreturn, sys32_sigreturn
>         PTREGSCALL stub32_execve, compat_sys_execve
> +       PTREGSCALL stub32_execveat, compat_sys_execveat
>         PTREGSCALL stub32_fork, sys_fork
>         PTREGSCALL stub32_vfork, sys_vfork
>
> diff --git a/arch/x86/kernel/audit_64.c b/arch/x86/kernel/audit_64.c
> index 06d3e5a14d9d..f3672508b249 100644
> --- a/arch/x86/kernel/audit_64.c
> +++ b/arch/x86/kernel/audit_64.c
> @@ -50,6 +50,7 @@ int audit_classify_syscall(int abi, unsigned syscall)
>         case __NR_openat:
>                 return 3;
>         case __NR_execve:
> +       case __NR_execveat:
>                 return 5;
>         default:
>                 return 0;
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1e96c3628bf2..f9a6c2fdda15 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -872,6 +872,20 @@ ENTRY(stub_execve)
>         CFI_ENDPROC
>  END(stub_execve)
>
> +ENTRY(stub_execveat)
> +       CFI_STARTPROC
> +       addq $8, %rsp
> +       PARTIAL_FRAME 0
> +       SAVE_REST
> +       FIXUP_TOP_OF_STACK %r11
> +       call sys_execveat
> +       RESTORE_TOP_OF_STACK %r11
> +       movq %rax,RAX(%rsp)
> +       RESTORE_REST
> +       jmp int_ret_from_sys_call
> +       CFI_ENDPROC
> +END(stub_execveat)
> +
>  /*
>   * sigreturn is special because it needs to restore all registers on return.
>   * This cannot be done with SYSRET, so use the IRET return path instead.
> @@ -917,6 +931,20 @@ ENTRY(stub_x32_execve)
>         CFI_ENDPROC
>  END(stub_x32_execve)
>
> +ENTRY(stub_x32_execveat)
> +       CFI_STARTPROC
> +       addq $8, %rsp
> +       PARTIAL_FRAME 0
> +       SAVE_REST
> +       FIXUP_TOP_OF_STACK %r11
> +       call compat_sys_execveat
> +       RESTORE_TOP_OF_STACK %r11
> +       movq %rax,RAX(%rsp)
> +       RESTORE_REST
> +       jmp int_ret_from_sys_call
> +       CFI_ENDPROC
> +END(stub_x32_execveat)
> +
>  #endif
>
>  /*
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index 96bc506ac6de..2ab0712a0e7c 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -359,3 +359,4 @@
>  350    i386    finit_module            sys_finit_module
>  351    i386    sched_setattr           sys_sched_setattr
>  352    i386    sched_getattr           sys_sched_getattr
> +353    i386    execveat                sys_execveat                    stub32_execveat
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index a12bddc7ccea..2e4058c14b4f 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -322,6 +322,7 @@
>  313    common  finit_module            sys_finit_module
>  314    common  sched_setattr           sys_sched_setattr
>  315    common  sched_getattr           sys_sched_getattr
> +316    64      execveat                stub_execveat
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> @@ -358,3 +359,4 @@
>  540    x32     process_vm_writev       compat_sys_process_vm_writev
>  541    x32     setsockopt              compat_sys_setsockopt
>  542    x32     getsockopt              compat_sys_getsockopt
> +543    x32     execveat                stub_x32_execveat
> diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
> index f2f0723070ca..20c3649d0691 100644
> --- a/arch/x86/um/sys_call_table_64.c
> +++ b/arch/x86/um/sys_call_table_64.c
> @@ -31,6 +31,7 @@
>  #define stub_fork sys_fork
>  #define stub_vfork sys_vfork
>  #define stub_execve sys_execve
> +#define stub_execveat sys_execveat
>  #define stub_rt_sigreturn sys_rt_sigreturn
>
>  #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
> diff --git a/fs/exec.c b/fs/exec.c
> index 3d78fccdd723..a8676ce571ce 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -748,7 +748,22 @@ EXPORT_SYMBOL(setup_arg_pages);
>
>  #endif /* CONFIG_MMU */
>
> -static struct file *do_open_exec(struct filename *name)
> +/*
> + * Perform the extra checks that open_exec() needs over and above a normal
> + * open.
> + */
> +static int check_exec_and_deny_write(struct file *file)
> +{
> +       if (!S_ISREG(file_inode(file)->i_mode))
> +               return -EACCES;
> +
> +       if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +               return -EACCES;
> +
> +       return deny_write_access(file);
> +}
> +
> +static struct file *do_open_execat(int fd, struct filename *name, int flags)
>  {
>         struct file *file;
>         int err;
> @@ -758,24 +773,42 @@ static struct file *do_open_exec(struct filename *name)
>                 .intent = LOOKUP_OPEN,
>                 .lookup_flags = LOOKUP_FOLLOW,
>         };
> +       static const struct open_flags open_exec_nofollow_flags = {
> +               .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
> +               .acc_mode = MAY_EXEC | MAY_OPEN,
> +               .intent = LOOKUP_OPEN,
> +               .lookup_flags = 0,
> +       };
>
> -       file = do_filp_open(AT_FDCWD, name, &open_exec_flags);
> -       if (IS_ERR(file))
> -               goto out;
> -
> -       err = -EACCES;
> -       if (!S_ISREG(file_inode(file)->i_mode))
> -               goto exit;
> +       if (flags & ~AT_SYMLINK_NOFOLLOW)
> +               return ERR_PTR(-EINVAL);
>
> -       if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> -               goto exit;
> +       if (name) {
> +               const struct open_flags *oflags = ((flags & AT_SYMLINK_NOFOLLOW)
> +                                                  ? &open_exec_nofollow_flags
> +                                                  : &open_exec_flags);
>
> -       fsnotify_open(file);
> +               file = do_filp_open(fd, name, oflags);
> +               if (IS_ERR(file))
> +                       goto out;
> +       } else {
> +               file = fget(fd);
> +               if (!file)
> +                       return ERR_PTR(-EBADF);
> +
> +               err = inode_permission(file->f_path.dentry->d_inode,
> +                               open_exec_flags.acc_mode);
> +               if (err)
> +                       goto exit;
> +       }
>
> -       err = deny_write_access(file);
> +       err = check_exec_and_deny_write(file);
>         if (err)
>                 goto exit;
>
> +       if (name)
> +               fsnotify_open(file);
> +
>  out:
>         return file;
>
> @@ -787,7 +820,7 @@ exit:
>  struct file *open_exec(const char *name)
>  {
>         struct filename tmp = { .name = name };
> -       return do_open_exec(&tmp);
> +       return do_open_execat(AT_FDCWD, &tmp, 0);
>  }
>  EXPORT_SYMBOL(open_exec);
>
> @@ -1437,10 +1470,12 @@ static int exec_binprm(struct linux_binprm *bprm)
>  /*
>   * sys_execve() executes a new program.
>   */
> -static int do_execve_common(struct filename *filename,
> -                               struct user_arg_ptr argv,
> -                               struct user_arg_ptr envp)
> +static int do_execveat_common(int fd, struct filename *filename,
> +                             struct user_arg_ptr argv,
> +                             struct user_arg_ptr envp,
> +                             int flags)
>  {
> +       char *pathbuf = NULL;
>         struct linux_binprm *bprm;
>         struct file *file;
>         struct files_struct *displaced;
> @@ -1481,7 +1516,7 @@ static int do_execve_common(struct filename *filename,
>         check_unsafe_exec(bprm);
>         current->in_execve = 1;
>
> -       file = do_open_exec(filename);
> +       file = do_open_execat(fd, filename, flags);
>         retval = PTR_ERR(file);
>         if (IS_ERR(file))
>                 goto out_unmark;
> @@ -1489,7 +1524,21 @@ static int do_execve_common(struct filename *filename,
>         sched_exec();
>
>         bprm->file = file;
> -       bprm->filename = bprm->interp = filename->name;
> +       if (filename && fd == AT_FDCWD) {
> +               bprm->filename = filename->name;
> +       } else {
> +               pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
> +               if (!pathbuf) {
> +                       retval = -ENOMEM;
> +                       goto out_unmark;
> +               }
> +               bprm->filename = d_path(&file->f_path, pathbuf, PATH_MAX);
> +               if (IS_ERR(bprm->filename)) {
> +                       retval = PTR_ERR(bprm->filename);
> +                       goto out_unmark;
> +               }
> +       }
> +       bprm->interp = bprm->filename;
>
>         retval = bprm_mm_init(bprm);
>         if (retval)
> @@ -1530,7 +1579,8 @@ static int do_execve_common(struct filename *filename,
>         acct_update_integrals(current);
>         task_numa_free(current);
>         free_bprm(bprm);
> -       putname(filename);
> +       if (filename)
> +               putname(filename);
>         if (displaced)
>                 put_files_struct(displaced);
>         return retval;
> @@ -1547,12 +1597,14 @@ out_unmark:
>
>  out_free:
>         free_bprm(bprm);
> +       kfree(pathbuf);
>
>  out_files:
>         if (displaced)
>                 reset_files_struct(displaced);
>  out_ret:
> -       putname(filename);
> +       if (filename)
> +               putname(filename);
>         return retval;
>  }
>
> @@ -1562,7 +1614,17 @@ int do_execve(struct filename *filename,
>  {
>         struct user_arg_ptr argv = { .ptr.native = __argv };
>         struct user_arg_ptr envp = { .ptr.native = __envp };
> -       return do_execve_common(filename, argv, envp);
> +       return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
> +}
> +
> +int do_execveat(int fd, struct filename *filename,
> +               const char __user *const __user *__argv,
> +               const char __user *const __user *__envp,
> +               int flags)
> +{
> +       struct user_arg_ptr argv = { .ptr.native = __argv };
> +       struct user_arg_ptr envp = { .ptr.native = __envp };
> +       return do_execveat_common(fd, filename, argv, envp, flags);
>  }
>
>  #ifdef CONFIG_COMPAT
> @@ -1578,7 +1640,23 @@ static int compat_do_execve(struct filename *filename,
>                 .is_compat = true,
>                 .ptr.compat = __envp,
>         };
> -       return do_execve_common(filename, argv, envp);
> +       return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
> +}
> +
> +static int compat_do_execveat(int fd, struct filename *filename,
> +                             const compat_uptr_t __user *__argv,
> +                             const compat_uptr_t __user *__envp,
> +                             int flags)
> +{
> +       struct user_arg_ptr argv = {
> +               .is_compat = true,
> +               .ptr.compat = __argv,
> +       };
> +       struct user_arg_ptr envp = {
> +               .is_compat = true,
> +               .ptr.compat = __envp,
> +       };
> +       return do_execveat_common(fd, filename, argv, envp, flags);
>  }
>  #endif
>
> @@ -1618,6 +1696,22 @@ SYSCALL_DEFINE3(execve,
>  {
>         return do_execve(getname(filename), argv, envp);
>  }
> +
> +SYSCALL_DEFINE5(execveat,
> +               int, fd, const char __user *, filename,
> +               const char __user *const __user *, argv,
> +               const char __user *const __user *, envp,
> +               int, flags)
> +{
> +       struct filename *path = NULL;
> +       if (filename) {
> +               path = getname(filename);
> +               if (IS_ERR(path))
> +                       return PTR_ERR(path);
> +       }
> +       return do_execveat(fd, path, argv, envp, flags);
> +}
> +
>  #ifdef CONFIG_COMPAT
>  asmlinkage long compat_sys_execve(const char __user * filename,
>         const compat_uptr_t __user * argv,
> @@ -1625,4 +1719,19 @@ asmlinkage long compat_sys_execve(const char __user * filename,
>  {
>         return compat_do_execve(getname(filename), argv, envp);
>  }
> +
> +asmlinkage long compat_sys_execveat(int fd,
> +       const char __user *filename,
> +       const compat_uptr_t __user *argv,
> +       const compat_uptr_t __user *envp,
> +       int flags)
> +{
> +       struct filename *path = NULL;
> +       if (filename) {
> +               path = getname(filename);
> +               if (IS_ERR(path))
> +                       return PTR_ERR(path);
> +       }
> +       return compat_do_execveat(fd, path, argv, envp, flags);
> +}
>  #endif
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 3f448c65511b..e875a5d97e08 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -341,6 +341,9 @@ asmlinkage long compat_sys_lseek(unsigned int, compat_off_t, unsigned int);
>
>  asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
>                      const compat_uptr_t __user *envp);
> +asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
> +                    const compat_uptr_t __user *argv,
> +                    const compat_uptr_t __user *envp, int flags);
>
>  asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
>                 compat_ulong_t __user *outp, compat_ulong_t __user *exp,
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a781dec1cd0b..92601818b4fb 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2315,6 +2315,10 @@ extern int disallow_signal(int);
>  extern int do_execve(struct filename *,
>                      const char __user * const __user *,
>                      const char __user * const __user *);
> +extern int do_execveat(int, struct filename *,
> +                      const char __user * const __user *,
> +                      const char __user * const __user *,
> +                      int);
>  extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
>  struct task_struct *fork_idle(int);
>  extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index a747a77ea584..309a810cf39d 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -855,4 +855,8 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>                          unsigned long idx1, unsigned long idx2);
>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
> +asmlinkage long sys_execveat(int dfd, const char __user *filename,
> +                       const char __user *const __user *argv,
> +                       const char __user *const __user *envp, int flags);
> +
>  #endif
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index dde8041f40d2..4231bca3f95e 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -696,9 +696,11 @@ __SYSCALL(__NR_finit_module, sys_finit_module)
>  __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
>  #define __NR_sched_getattr 275
>  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
> +#define __NR_execveat 276
> +__SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 276
> +#define __NR_syscalls 277
>
>  /*
>   * All syscalls below here should go away really,
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 7078052284fd..5ea7b8ab9e63 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -209,3 +209,6 @@ cond_syscall(compat_sys_open_by_handle_at);
>
>  /* compare kernel pointers */
>  cond_syscall(sys_kcmp);
> +
> +/* execveat */
> +cond_syscall(sys_execveat);
> diff --git a/lib/audit.c b/lib/audit.c
> index 76bbed4a20e5..712456ed5960 100644
> --- a/lib/audit.c
> +++ b/lib/audit.c
> @@ -48,6 +48,9 @@ int audit_classify_syscall(int abi, unsigned syscall)
>         case __NR_socketcall:
>                 return 4;
>  #endif
> +#ifdef __NR_execveat
> +       case __NR_execveat:
> +#endif
>         case __NR_execve:
>                 return 5;
>         default:
> --
> 1.9.1.423.g4596e3a
>



-- 
Kees Cook
Chrome OS Security
