From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 4 Feb 2015 09:01:57 +0100
Message-ID: <CAHO5Pa3s+QSCVsoGiffgLU-U9gaUbTm7JXe4e1vnefV4Fsx1-w@mail.gmail.com>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de> <1422896713-25367-2-git-send-email-holler@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422896713-25367-2-git-send-email-holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Cc: Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

On Mon, Feb 2, 2015 at 6:05 PM, Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org> wrote:
> Signed-off-by: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
> ---
>  arch/x86/syscalls/syscall_32.tbl      |  1 +
>  arch/x86/syscalls/syscall_64.tbl      |  1 +
>  fs/namei.c                            | 38 ++++++++++++++++++++++++++++++-----
>  include/asm-generic/audit_dir_write.h |  1 +
>  include/linux/fs.h                    |  1 +
>  include/linux/syscalls.h              |  1 +
>  include/uapi/asm-generic/unistd.h     |  4 +++-
>  tools/perf/builtin-trace.c            |  2 ++
>  8 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index 9fe1b5d..7a3d530 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -364,3 +364,4 @@
>  355    i386    getrandom               sys_getrandom
>  356    i386    memfd_create            sys_memfd_create
>  357    i386    bpf                     sys_bpf
> +359    i386    unlinkat_s              sys_unlinkat_s
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 281150b..97eaf01 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -328,6 +328,7 @@
>  319    common  memfd_create            sys_memfd_create
>  320    common  kexec_file_load         sys_kexec_file_load
>  321    common  bpf                     sys_bpf
> +322    common  unlinkat_s              sys_unlinkat_s
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/namei.c b/fs/namei.c
> index db5fe86..1ad3724 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3717,7 +3717,7 @@ EXPORT_SYMBOL(vfs_unlink);
>   * writeout happening, and we don't want to prevent access to the directory
>   * while waiting on the I/O.
>   */
> -static long do_unlinkat(int dfd, const char __user *pathname)
> +static long do_unlinkat(int dfd, const char __user *pathname, bool secure)
>  {
>         int error;
>         struct filename *name;
> @@ -3759,8 +3759,25 @@ exit2:
>                 dput(dentry);
>         }
>         mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
> -       if (inode)
> -               iput(inode);    /* truncate the inode here */
> +       if (inode) {
> +               // TODO:
> +               // if (inode is file and 's' flag is set)
> +               //      secure = true;
> +               if (!secure)
> +                       iput(inode);    /* truncate the inode here */
> +               else {
> +                       struct super_block *sb = inode->i_sb;
> +                       if (sb->s_op->set_secure_delete)
> +                               sb->s_op->set_secure_delete(sb, true);
> +                       // TODO: We should fail if secure isn't supported,
> +                       // look up how that's possible here.
> +                       iput(inode);    /* truncate the inode here */
> +                       // TODO: check if sb is still valid after the inode is gone
> +                       sync_filesystem(sb);
> +                       if (sb->s_op->set_secure_delete)
> +                               sb->s_op->set_secure_delete(sb, false);
> +               }
> +       }
>         inode = NULL;
>         if (delegated_inode) {
>                 error = break_deleg_wait(&delegated_inode);
> @@ -3796,12 +3813,23 @@ SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
>         if (flag & AT_REMOVEDIR)
>                 return do_rmdir(dfd, pathname);
>
> -       return do_unlinkat(dfd, pathname);
> +       return do_unlinkat(dfd, pathname, false);
>  }
>
>  SYSCALL_DEFINE1(unlink, const char __user *, pathname)
>  {
> -       return do_unlinkat(AT_FDCWD, pathname);
> +       return do_unlinkat(AT_FDCWD, pathname, false);
> +}
> +
> +SYSCALL_DEFINE3(unlinkat_s, int, dfd, const char __user *, pathname, int, flag)
> +{
> +       if ((flag & ~AT_REMOVEDIR) != 0)
> +               return -EINVAL;
> +
> +       if (flag & AT_REMOVEDIR)
> +               return do_rmdir(dfd, pathname);
> +
> +       return do_unlinkat(dfd, pathname, true);
>  }
>
>  int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
> diff --git a/include/asm-generic/audit_dir_write.h b/include/asm-generic/audit_dir_write.h
> index 7b61db4..5282aba 100644
> --- a/include/asm-generic/audit_dir_write.h
> +++ b/include/asm-generic/audit_dir_write.h
> @@ -29,4 +29,5 @@ __NR_unlinkat,
>  __NR_renameat,
>  __NR_linkat,
>  __NR_symlinkat,
> +__NR_unlinkat_s,
>  #endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9ab779e..039e969 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1594,6 +1594,7 @@ struct super_operations {
>         int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
>         long (*nr_cached_objects)(struct super_block *, int);
>         long (*free_cached_objects)(struct super_block *, long, int);
> +       void (*set_secure_delete) (struct super_block *, bool);
>  };
>
>  /*
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index bda9b81..b88019b 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -877,4 +877,5 @@ asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
>  asmlinkage long sys_getrandom(char __user *buf, size_t count,
>                               unsigned int flags);
>  asmlinkage long sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
> +asmlinkage long sys_unlinkat_s(int dfd, const char __user * pathname, int flag);
>  #endif
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 22749c1..2ba072e 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -707,9 +707,11 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
>  __SYSCALL(__NR_memfd_create, sys_memfd_create)
>  #define __NR_bpf 280
>  __SYSCALL(__NR_bpf, sys_bpf)
> +#define __NR_unlinkat_s 281
> +__SYSCALL(__NR_unlinkat_s, sys_unlinkat_s)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 281
> +#define __NR_syscalls 282
>
>  /*
>   * All syscalls below here should go away really,
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index fb12645..1507335 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1110,6 +1110,8 @@ static struct syscall_fmt {
>         { .name     = "uname",      .errmsg = true, .alias = "newuname", },
>         { .name     = "unlinkat",   .errmsg = true,
>           .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
> +       { .name     = "unlinkat_s",   .errmsg = true,
> +         .arg_scnprintf = { [0] = SCA_FDAT, /* dfd */ }, },
>         { .name     = "utimensat",  .errmsg = true,
>           .arg_scnprintf = { [0] = SCA_FDAT, /* dirfd */ }, },
>         { .name     = "write",      .errmsg = true,
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
