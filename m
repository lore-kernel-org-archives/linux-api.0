From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with
 open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Fri, 1 Jun 2018 11:02:49 +0300
Message-ID: <CAOQ4uxjbZEyqNPwE8m0QmCU7OG831r4Lpg+M1RWCOxDrsgErnA@mail.gmail.com>
References: <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[added linux-api]

On Fri, May 25, 2018 at 3:08 AM, David Howells <dhowells@redhat.com> wrote:
> Make it possible to clone a mount tree with a new pair of open flags that
> are used in conjunction with O_PATH:
>
>  (1) O_CLONE_MOUNT - Clone the mount or mount tree at the path.
>
>  (2) O_NON_RECURSIVE - Don't clone recursively.
>
> Note that it's not a good idea to reuse other flags (such as O_CREAT)
> because the open routine for O_PATH does not give an error if any other
> flags are used in conjunction with O_PATH, but rather just masks off any it
> doesn't use.
>
> The resultant file struct is marked FMODE_NEED_UNMOUNT to as it pins an
> extra reference for the mount.  This will be cleared by the upcoming
> move_mount() syscall when it successfully moves a cloned mount into the
> filesystem tree.
>
> Note that care needs to be taken with the error handling in do_o_path() in
> the case that vfs_open() fails as the path may or may not have been
> attached to the file struct and FMODE_NEED_UNMOUNT may or may not be set.
> Note that O_DIRECT | O_PATH could be a problem with error handling too.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
[...]

> @@ -977,8 +979,11 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
>                  * If we have O_PATH in the open flag. Then we
>                  * cannot have anything other than the below set of flags
>                  */
> -               flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
> +               flags &= (O_DIRECTORY | O_NOFOLLOW | O_PATH |
> +                         O_CLONE_MOUNT | O_NON_RECURSIVE);
>                 acc_mode = 0;
> +       } else if (flags & (O_CLONE_MOUNT | O_NON_RECURSIVE)) {
> +               return -EINVAL;

Reject O_NON_RECURSIVE without O_CLONE_MOUNT?
That would free at least one flag combination for future use.

Doesn't it make more sense for user API to opt-into
O_RECURSIVE_CLONE, rather than opt-out of it?


>         }
>
>         op->open_flag = flags;
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index 27dc7a60693e..8f60e2244740 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -9,7 +9,8 @@
>         (O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
>          O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
>          FASYNC | O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
> -        O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
> +        O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | \
> +        O_CLONE_MOUNT | O_NON_RECURSIVE)
>
>  #ifndef force_o_largefile
>  #define force_o_largefile() (BITS_PER_LONG != 32)
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> index 0b1c7e35090c..f533e35ea19b 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -88,6 +88,14 @@
>  #define __O_TMPFILE    020000000
>  #endif
>
> +#ifndef O_CLONE_MOUNT
> +#define O_CLONE_MOUNT  040000000       /* Used with O_PATH to clone the mount subtree at path */
> +#endif
> +
> +#ifndef O_NON_RECURSIVE
> +#define O_NON_RECURSIVE        0100000000      /* Used with O_CLONE_MOUNT to only clone one mount */
> +#endif
> +
>  /* a horrid kludge trying to make sure that this will fail on old kernels */
>  #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
>  #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)
>

I am not sure what are the consequences of opening O_PATH with old kernel
and getting an open file, can't think of anything bad.
Can the same be claimed for O_PATH|O_CLONE_MOUNT?

Wouldn't it be better to apply the O_TMPFILE kludge to the new
open flag, so that apps can check if O_CLONE_MOUNT feature is supported
by kernel?

Thanks,
Amir.
