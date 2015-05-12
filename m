From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] Implement fchmodat4 syscall
Date: Tue, 12 May 2015 10:48:57 +0200
Message-ID: <CAHO5Pa3ahE8dm6md+Zh+K0B13HjQEjMTBO0xbSM6JqYR9tmVag@mail.gmail.com>
References: <1431310042-52247-1-git-send-email-will@worrbase.com> <1431310042-52247-2-git-send-email-will@worrbase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431310042-52247-2-git-send-email-will@worrbase.com>
Sender: linux-kernel-owner@vger.kernel.org
To: William Orr <will@worrbase.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Linux API <linux-api@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Ayer <agwa@andrewayer.name>
List-Id: linux-api@vger.kernel.org

[expanding CC]

On Mon, May 11, 2015 at 4:07 AM, William Orr <will@worrbase.com> wrote:
> Adds fchmodat4 which more closely matches POSIX by taking 4 arguments,
> including the flags argument. flags are the same as fchownat(2), implementing
> both AT_SYMLINK_NOFOLLOW and AT_EMPTY_PATH
>
> Based heavily off of Andrew Ayer's patch from 2012.
> ---
>  fs/open.c                | 19 +++++++++++++++++--
>  include/linux/syscalls.h |  2 ++
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 98e5a52..00dd0f7 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -504,6 +504,9 @@ static int chmod_common(struct path *path, umode_t mode)
>         struct iattr newattrs;
>         int error;
>
> +       if (S_ISLNK(inode->i_mode))
> +               return -EOPNOTSUPP;
> +
>         error = mnt_want_write(path->mnt);
>         if (error)
>                 return error;
> @@ -541,9 +544,21 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
>
>  SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode)
>  {
> +       return sys_fchmodat4(dfd, filename, mode, 0);
> +}
> +
> +SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename, umode_t, mode, int, flags)
> +{
>         struct path path;
>         int error;
> -       unsigned int lookup_flags = LOOKUP_FOLLOW;
> +       unsigned int lookup_flags;
> +
> +       if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
> +               return -EINVAL;
> +
> +       lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
> +       if (flags & AT_EMPTY_PATH)
> +               lookup_flags |= LOOKUP_EMPTY;
>  retry:
>         error = user_path_at(dfd, filename, lookup_flags, &path);
>         if (!error) {
> @@ -559,7 +574,7 @@ retry:
>
>  SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
>  {
> -       return sys_fchmodat(AT_FDCWD, filename, mode);
> +       return sys_fchmodat4(AT_FDCWD, filename, mode, 0);
>  }
>
>  static int chown_common(struct path *path, uid_t user, gid_t group)
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 76d1e38..d6e9602 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -769,6 +769,8 @@ asmlinkage long sys_futimesat(int dfd, const char __user *filename,
>  asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
>  asmlinkage long sys_fchmodat(int dfd, const char __user * filename,
>                              umode_t mode);
> +asmlinkage long sys_fchmodat4(int dfd, const char __user * filename,
> +                            umode_t mode, int flags);
>  asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
>                              gid_t group, int flag);
>  asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
