From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Date: Fri, 12 Dec 2008 20:18:11 -0500
Message-ID: <cfd18e0f0812121718s735c492ev43b25950d9c0e3b2@mail.gmail.com>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Gerd,

Please CC linux-api on patches that change the API!

Cheers,

Michael

On Fri, Dec 12, 2008 at 9:00 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> This patch adds preadv and pwritev system calls.  These syscalls are a
> pretty straightforward combination of pread and readv (same for write).
> They are quite useful for doing vectored I/O in threaded applications.
> Using lseek+readv instead opens race windows you'll have to plug with
> locking.
>
> Other systems have such system calls too, for example NetBSD, check
> here: http://www.daemon-systems.org/man/preadv.2.html
>
> The patch sports the actual system call implementation and the windup in
> the x86 system call tables.  Other archs are TBD.
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/ia32/ia32entry.S          |    2 +
>  arch/x86/include/asm/unistd_32.h   |    2 +
>  arch/x86/include/asm/unistd_64.h   |    4 ++
>  arch/x86/kernel/syscall_table_32.S |    2 +
>  fs/compat.c                        |   61 ++++++++++++++++++++++++++++++++++++
>  fs/read_write.c                    |   48 ++++++++++++++++++++++++++++
>  6 files changed, 119 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 256b00b..9a8501b 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -826,4 +826,6 @@ ia32_sys_call_table:
>        .quad sys_dup3                  /* 330 */
>        .quad sys_pipe2
>        .quad sys_inotify_init1
> +       .quad compat_sys_preadv
> +       .quad compat_sys_pwritev
>  ia32_syscall_end:
> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> index f2bba78..6e72d74 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -338,6 +338,8 @@
>  #define __NR_dup3              330
>  #define __NR_pipe2             331
>  #define __NR_inotify_init1     332
> +#define __NR_preadv            333
> +#define __NR_pwritev           334
>
>  #ifdef __KERNEL__
>
> diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
> index d2e415e..f818294 100644
> --- a/arch/x86/include/asm/unistd_64.h
> +++ b/arch/x86/include/asm/unistd_64.h
> @@ -653,6 +653,10 @@ __SYSCALL(__NR_dup3, sys_dup3)
>  __SYSCALL(__NR_pipe2, sys_pipe2)
>  #define __NR_inotify_init1                     294
>  __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
> +#define __NR_preadv                            295
> +__SYSCALL(__NR_preadv, sys_preadv)
> +#define __NR_pwritev                           296
> +__SYSCALL(__NR_pwritev, sys_pwritev)
>
>
>  #ifndef __NO_STUBS
> diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
> index d44395f..a1a5506 100644
> --- a/arch/x86/kernel/syscall_table_32.S
> +++ b/arch/x86/kernel/syscall_table_32.S
> @@ -332,3 +332,5 @@ ENTRY(sys_call_table)
>        .long sys_dup3                  /* 330 */
>        .long sys_pipe2
>        .long sys_inotify_init1
> +       .long sys_preadv
> +       .long sys_pwritev
> diff --git a/fs/compat.c b/fs/compat.c
> index e5f49f5..3a25cf3 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1214,6 +1214,67 @@ out:
>        return ret;
>  }
>
> +asmlinkage ssize_t
> +compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
> +                  unsigned long vlen, loff_t pos)
> +{
> +       struct file *file;
> +       ssize_t ret = -EBADF;
> +
> +       if (pos < 0)
> +               return -EINVAL;
> +
> +       file = fget(fd);
> +       if (!file)
> +               return -EBADF;
> +
> +       if (!(file->f_mode & FMODE_READ))
> +               goto out;
> +
> +       ret = -EINVAL;
> +       if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
> +               goto out;
> +
> +       ret = compat_do_readv_writev(READ, file, vec, vlen, &pos);
> +
> +out:
> +       if (ret > 0)
> +               add_rchar(current, ret);
> +       inc_syscr(current);
> +       fput(file);
> +       return ret;
> +}
> +
> +asmlinkage ssize_t
> +compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
> +                   unsigned long vlen, loff_t pos)
> +{
> +       struct file *file;
> +       ssize_t ret = -EBADF;
> +
> +       if (pos < 0)
> +               return -EINVAL;
> +
> +       file = fget(fd);
> +       if (!file)
> +               return -EBADF;
> +       if (!(file->f_mode & FMODE_WRITE))
> +               goto out;
> +
> +       ret = -EINVAL;
> +       if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
> +               goto out;
> +
> +       ret = compat_do_readv_writev(WRITE, file, vec, vlen, &pos);
> +
> +out:
> +       if (ret > 0)
> +               add_wchar(current, ret);
> +       inc_syscw(current);
> +       fput(file);
> +       return ret;
> +}
> +
>  asmlinkage long
>  compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
>                    unsigned int nr_segs, unsigned int flags)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 969a6d9..89f273d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -701,6 +701,54 @@ sys_writev(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
>        return ret;
>  }
>
> +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> +                              unsigned long vlen, loff_t pos)
> +{
> +       struct file *file;
> +       ssize_t ret = -EBADF;
> +       int fput_needed;
> +
> +       if (pos < 0)
> +               return -EINVAL;
> +
> +       file = fget_light(fd, &fput_needed);
> +       if (file) {
> +               ret = -ESPIPE;
> +               if (file->f_mode & FMODE_PREAD)
> +                       ret = vfs_readv(file, vec, vlen, &pos);
> +               fput_light(file, fput_needed);
> +       }
> +
> +       if (ret > 0)
> +               add_rchar(current, ret);
> +       inc_syscr(current);
> +       return ret;
> +}
> +
> +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> +                               unsigned long vlen, loff_t pos)
> +{
> +       struct file *file;
> +       ssize_t ret = -EBADF;
> +       int fput_needed;
> +
> +       if (pos < 0)
> +               return -EINVAL;
> +
> +       file = fget_light(fd, &fput_needed);
> +       if (file) {
> +               ret = -ESPIPE;
> +               if (file->f_mode & FMODE_PWRITE)
> +                       ret = vfs_writev(file, vec, vlen, &pos);
> +               fput_light(file, fput_needed);
> +       }
> +
> +       if (ret > 0)
> +               add_wchar(current, ret);
> +       inc_syscw(current);
> +       return ret;
> +}
> +
>  static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>                           size_t count, loff_t max)
>  {
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
