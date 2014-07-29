From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/5] fs: Add xgetdents system call and xreaddir file operation
Date: Tue, 29 Jul 2014 10:20:59 +0200
Message-ID: <CAHO5Pa3iZ0ZvNN5ovXmFK4E7PvT-RF64tCBaEPH87zzqNoU4qQ@mail.gmail.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com> <1406309888-10749-3-git-send-email-adas@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406309888-10749-3-git-send-email-adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api]

On Fri, Jul 25, 2014 at 7:38 PM, Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Also add linux_xdirent structure that will be the container for
> dirent, stat and xattr info.
>
> Signed-off-by: Abhi Das <adas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/syscalls/syscall_32.tbl |  1 +
>  arch/x86/syscalls/syscall_64.tbl |  1 +
>  fs/readdir.c                     | 42 ++++++++++++++++++++++++++++++++++++++++
>  fs/stat.c                        |  4 +++-
>  include/linux/fs.h               |  1 +
>  include/linux/stat.h             |  2 ++
>  include/uapi/linux/stat.h        | 33 +++++++++++++++++++++++++++++++
>  7 files changed, 83 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index 6d6ca37..35723e3 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -362,3 +362,4 @@
>  353    i386    renameat2               sys_renameat2
>  354    i386    xstat                   sys_xstat
>  355    i386    fxstat                  sys_fxstat
> +356    i386    xgetdents               sys_xgetdents
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 1308ee3..566aab1 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -325,6 +325,7 @@
>  316    common  renameat2               sys_renameat2
>  317    common  xstat                   sys_xstat
>  318    common  fxstat                  sys_fxstat
> +319    common  xgetdents               sys_xgetdents
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 33fd922..d676088 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -224,6 +224,48 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
>         return error;
>  }
>
> +SYSCALL_DEFINE5(xgetdents, unsigned int, fd, unsigned, flags, unsigned int, mask,
> +               void __user *, buf, unsigned int, count)
> +{
> +       struct fd f;
> +       struct inode *inode;
> +       int error = -ENOTDIR;
> +
> +       if (!count)
> +               return -EINVAL;
> +
> +       if (!access_ok(VERIFY_WRITE, buf, count))
> +               return -EFAULT;
> +
> +       f = fdget(fd);
> +       if (!f.file)
> +               return -EBADF;
> +
> +       inode = f.file->f_path.dentry->d_inode;
> +
> +       error = -ENOTSUPP;
> +       if (!f.file->f_op || !f.file->f_op->xreaddir)
> +               goto out;
> +
> +       error = security_file_permission(f.file, MAY_READ);
> +       if (error)
> +               goto out;
> +
> +       error = mutex_lock_killable(&inode->i_mutex);
> +       if (error)
> +               goto out;
> +
> +       error = -ENOENT;
> +       if (!IS_DEADDIR(inode)) {
> +               error = f.file->f_op->xreaddir(f.file, flags, mask, buf, count);
> +               file_accessed(f.file);
> +       }
> +       mutex_unlock(&inode->i_mutex);
> +out:
> +       fdput(f);
> +       return error;
> +}
> +
>  struct getdents_callback64 {
>         struct dir_context ctx;
>         struct linux_dirent64 __user * current_dir;
> diff --git a/fs/stat.c b/fs/stat.c
> index 1fd0b3e..db45f8b 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -651,7 +651,7 @@ static int xstat_get_params(unsigned int mask, struct xstat __user *buffer,
>   * Otherwise we copy the extended stats to userspace and return the amount of
>   * data written into the buffer (or -EFAULT).
>   */
> -static long xstat_set_result(struct kstat *stat, struct xstat __user *buffer)
> +long xstat_set_result(struct kstat *stat, struct xstat __user *buffer)
>  {
>         u32 mask = stat->result_mask, gran = stat->tv_granularity;
>
> @@ -701,6 +701,8 @@ static long xstat_set_result(struct kstat *stat, struct xstat __user *buffer)
>         return 0;
>  }
>
> +EXPORT_SYMBOL(xstat_set_result);
> +
>  /*
>   * System call to get extended stats by path
>   */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b91f235..79c7d39 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1464,6 +1464,7 @@ struct file_operations {
>         ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
>         ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
>         int (*iterate) (struct file *, struct dir_context *);
> +       size_t (*xreaddir) (struct file *, unsigned int, unsigned int, void __user *, size_t);
>         unsigned int (*poll) (struct file *, struct poll_table_struct *);
>         long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>         long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 552e047..75be415 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -46,4 +46,6 @@ struct kstat {
>         unsigned char   volume_id[16];              /* volume identifier */
>  };
>
> +long xstat_set_result(struct kstat *stat, struct xstat __user *buffer);
> +
>  #endif
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 2907352..d7ea6c5 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -90,6 +90,14 @@
>  #define XSTAT_VOLUME_ID        0x00008000U     /* want/got st_volume_id */
>  #define XSTAT_ALL_STATS        0x0000ffffU     /* all supported stats */
>
> +/* xattr request flags */
> +#define XSTAT_XATTR_USER       0x00010000U     /* user.* xattrs */
> +#define XSTAT_XATTR_SYSTEM     0x00020000U     /* system.* xattrs */
> +#define XSTAT_XATTR_SECURITY   0x00040000U     /* security.* xattrs */
> +#define XSTAT_XATTR_POSIX_ACL  0x00080000U     /* posix acl xattrs */
> +#define XSTAT_XATTR_ALL        0x00ff0000U     /* all xattrs */
> +#define XSTAT_XATTR_VALUES     0x01000000U     /* retrieve values along with keys */
> +
>  /*
>   * Extended stat structures
>   */
> @@ -152,4 +160,29 @@ struct xstat {
>  #define XSTAT_INFO_SYSTEM              0x00001000U /* File is marked system (DOS+) */
>  #define XSTAT_INFO_ARCHIVE             0x00002000U /* File is marked archive (DOS+) */
>
> +struct xdirent_xattr {
> +       size_t       xa_value_len;   /* length of value field */
> +       char         xa_name_val[1]; /* name/value pair, name is NULL terminated and
> +                                     * value is xa_value_len in length */
> +};
> +
> +/*
> + * xb_blob: first contains NULL terminated name, followed by struct xdirent_xattr
> + * objects packed together.
> + */
> +struct xdirent_blob {
> +       unsigned int    xb_xattr_count;
> +       char            xb_blob[1]; /* contains variable length data like
> +                                    * NULL-terminated name, xattrs etc */
> +};
> +
> +struct linux_xdirent {
> +       unsigned long        xd_ino;
> +       char                 xd_type;
> +       unsigned long        xd_off;
> +       struct xstat         xd_stat;
> +       unsigned long        xd_reclen;
> +       struct xdirent_blob  xd_blob;
> +};
> +
>  #endif /* _UAPI_LINUX_STAT_H */
> --
> 1.8.1.4
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
