From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] vfs: implement fchmodat2() syscall
Date: Wed, 1 Mar 2017 10:01:53 +0100
Message-ID: <CAHO5Pa2dPUQRXEs7W198M0wbxWAkjKzsVPo4yrc1VPfbNM5R9w@mail.gmail.com>
References: <148830142269.7103.7429913851447595016.stgit@bahia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <148830142269.7103.7429913851447595016.stgit@bahia>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Greg Kurz <groug@kaod.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Eric Blake <eblake@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@vger.kernel.org]

Hello Greg,

Since this is a kernel-user-space API change, please CC linux-api@.
The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api@vger.kernel.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael


On Tue, Feb 28, 2017 at 6:03 PM, Greg Kurz <groug@kaod.org> wrote:
> According to the POSIX.1-2008 manual page [1], the fchmodat() function has
> a flag argument which may be passed the following value:
>
> AT_SYMLINK_NOFOLLOW
>     If path names a symbolic link, then the mode of the symbolic link is
>     changed.
>
> and the following error may be returned:
>
> [EOPNOTSUPP]
>     The AT_SYMLINK_NOFOLLOW bit is set in the flag argument, path names a
>     symbolic link, and the system does not support changing the mode of a
>     symbolic link.
>
> The linux kernel doesn't support changing the mode of a symbolic link, but
> the current implementation doesn't even have a flag argument. It is then
> up to userspace to deal with that. Unfortunately, it is impossible to
> implement the POSIX behavior in a race-free manner.
>
> This patch introduces a new fchmodat2() syscall with a flag argument to
> address the issue.
>
> [1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/chmod.html
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  fs/open.c                         |   23 +++++++++++++++++++----
>  include/linux/syscalls.h          |    2 ++
>  include/uapi/asm-generic/unistd.h |    4 +++-
>  scripts/checksyscalls.sh          |    3 ++-
>  4 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 9921f70bc5ca..66a8c19f72ca 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -558,24 +558,39 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
>         return err;
>  }
>
> -SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode)
> +SYSCALL_DEFINE4(fchmodat2, int, dfd, const char __user *, filename, umode_t,
> +               mode, int, flag)
>  {
>         struct path path;
> -       int error;
> -       unsigned int lookup_flags = LOOKUP_FOLLOW;
> +       int error = -EINVAL;
> +       unsigned int lookup_flags;
> +
> +       if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
> +               goto out;
> +
> +       lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
>  retry:
>         error = user_path_at(dfd, filename, lookup_flags, &path);
>         if (!error) {
> -               error = chmod_common(&path, mode);
> +               error = -EOPNOTSUPP;
> +               if (!d_is_symlink(path.dentry))
> +                       error = chmod_common(&path, mode);
>                 path_put(&path);
>                 if (retry_estale(error, lookup_flags)) {
>                         lookup_flags |= LOOKUP_REVAL;
>                         goto retry;
>                 }
>         }
> +out:
>         return error;
>  }
>
> +SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t,
> +               mode)
> +{
> +       return sys_fchmodat2(dfd, filename, mode, 0);
> +}
> +
>  SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
>  {
>         return sys_fchmodat(AT_FDCWD, filename, mode);
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 91a740f6b884..982089d55b31 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -775,6 +775,8 @@ asmlinkage long sys_futimesat(int dfd, const char __user *filename,
>  asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
>  asmlinkage long sys_fchmodat(int dfd, const char __user * filename,
>                              umode_t mode);
> +asmlinkage long sys_fchmodat2(int dfd, const char __user *filename,
> +                             umode_t mode, int flag);
>  asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
>                              gid_t group, int flag);
>  asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 9b1462e38b82..e8b0a00908b1 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -730,9 +730,11 @@ __SYSCALL(__NR_pkey_mprotect, sys_pkey_mprotect)
>  __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
>  #define __NR_pkey_free 290
>  __SYSCALL(__NR_pkey_free,     sys_pkey_free)
> +#define __NR_fchmodat2 291
> +__SYSCALL(__NR_fchmodat2,     sys_fchmodat2)
>
>  #undef __NR_syscalls
> -#define __NR_syscalls 291
> +#define __NR_syscalls 292
>
>  /*
>   * All syscalls below here should go away really,
> diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> index 2c9082ba6137..2e7471a1d308 100755
> --- a/scripts/checksyscalls.sh
> +++ b/scripts/checksyscalls.sh
> @@ -19,7 +19,7 @@ cat << EOF
>  #define __IGNORE_link          /* linkat */
>  #define __IGNORE_unlink                /* unlinkat */
>  #define __IGNORE_mknod         /* mknodat */
> -#define __IGNORE_chmod         /* fchmodat */
> +#define __IGNORE_chmod         /* fchmodat2 */
>  #define __IGNORE_chown         /* fchownat */
>  #define __IGNORE_mkdir         /* mkdirat */
>  #define __IGNORE_rmdir         /* unlinkat */
> @@ -39,6 +39,7 @@ cat << EOF
>
>  /* Missing flags argument */
>  #define __IGNORE_renameat      /* renameat2 */
> +#define __IGNORE_fchmodat      /* fchmodat2 */
>
>  /* CLOEXEC flag */
>  #define __IGNORE_pipe          /* pipe2 */
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
