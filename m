From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] fs: Add dirreadahead syscall and VFS hooks
Date: Tue, 29 Jul 2014 10:21:50 +0200
Message-ID: <CAHO5Pa2fW6mZRTao3uEx2p_X9GvO1btrbb9Bg2ns94+p4biKAQ@mail.gmail.com>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <1406309851-10628-2-git-send-email-adas@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406309851-10628-2-git-send-email-adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cluster-devel <cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC+=linux-api]

On Fri, Jul 25, 2014 at 7:37 PM, Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Also adds a void *opaque field to struct dir_context that can be
> used by filesystems to temporarily store any context as this
> struct gets passed around in the fs.
>
> Signed-off-by: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/syscalls/syscall_32.tbl |  1 +
>  arch/x86/syscalls/syscall_64.tbl |  1 +
>  fs/readdir.c                     | 49 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h               |  3 +++
>  4 files changed, 54 insertions(+)
>
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index d6b8679..3e0ef85 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -360,3 +360,4 @@
>  351    i386    sched_setattr           sys_sched_setattr
>  352    i386    sched_getattr           sys_sched_getattr
>  353    i386    renameat2               sys_renameat2
> +354    i386    dirreadahead            sys_dirreadahead
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index ec255a1..2ec0991 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -323,6 +323,7 @@
>  314    common  sched_setattr           sys_sched_setattr
>  315    common  sched_getattr           sys_sched_getattr
>  316    common  renameat2               sys_renameat2
> +317    common  dirreadahead            sys_dirreadahead
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 33fd922..d216db7 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -198,6 +198,7 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
>         struct linux_dirent __user * lastdirent;
>         struct getdents_callback buf = {
>                 .ctx.actor = filldir,
> +               .ctx.opaque = NULL,
>                 .count = count,
>                 .current_dir = dirent
>         };
> @@ -278,6 +279,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>         struct linux_dirent64 __user * lastdirent;
>         struct getdents_callback64 buf = {
>                 .ctx.actor = filldir64,
> +               .ctx.opaque = NULL,
>                 .count = count,
>                 .current_dir = dirent
>         };
> @@ -304,3 +306,50 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>         fdput(f);
>         return error;
>  }
> +
> +SYSCALL_DEFINE3(dirreadahead, unsigned int, fd,
> +               loff_t __user *, offset, unsigned int, count)
> +{
> +       struct fd f;
> +       struct inode *inode;
> +       int error = -ENOTDIR;
> +       loff_t off = 0;
> +       struct dir_context ctx = {.actor = NULL, .opaque = NULL};
> +
> +       if (!count)
> +               return -EINVAL;
> +
> +       f = fdget(fd);
> +       if (!f.file)
> +               return -EBADF;
> +
> +       inode = f.file->f_path.dentry->d_inode;
> +
> +       error = -ENOTSUPP;
> +       if (!f.file->f_op || !f.file->f_op->dir_readahead)
> +               goto out;
> +
> +       error = security_file_permission(f.file, MAY_READ);
> +       if (error)
> +               goto out;
> +
> +       error = -EFAULT;
> +       if (__get_user(ctx.pos, offset))
> +               goto out;
> +
> +       error = mutex_lock_killable(&inode->i_mutex);
> +       if (error)
> +               goto out;
> +
> +       error = -ENOENT;
> +       if (!IS_DEADDIR(inode)) {
> +               error = f.file->f_op->dir_readahead(f.file, &ctx, count);
> +               if (__put_user(ctx.pos, offset))
> +                       error = -EFAULT;
> +               file_accessed(f.file);
> +       }
> +       mutex_unlock(&inode->i_mutex);
> +out:
> +       fdput(f);
> +       return error;
> +}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 338e6f7..fae4a6e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1438,9 +1438,11 @@ int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
>   * to have different dirent layouts depending on the binary type.
>   */
>  typedef int (*filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
> +
>  struct dir_context {
>         const filldir_t actor;
>         loff_t pos;
> +       void *opaque;
>  };
>
>  struct block_device_operations;
> @@ -1463,6 +1465,7 @@ struct file_operations {
>         ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
>         ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
>         int (*iterate) (struct file *, struct dir_context *);
> +       int (*dir_readahead) (struct file *, struct dir_context *, unsigned int);
>         unsigned int (*poll) (struct file *, struct poll_table_struct *);
>         long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>         long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
