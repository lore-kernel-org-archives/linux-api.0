From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/7] Add a new flags-accepting interface for anonymous inodes
Date: Mon, 14 Oct 2019 17:38:45 +0200
Message-ID: <CAG48ez3yOPAC3mTJdQ5_8aARQPe+siid5jaa8U+aMtfj-bUJ2g@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-2-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-2-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, nosh@google.com, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 9:16 PM Daniel Colascione <dancol@google.com> wrote:
> Add functions forwarding from the old names to the new ones so we
> don't need to change any callers.

This patch does more than the commit message says; it also refactors
the body of the function. (I would've moved that refactoring over into
patch 2, but I guess this works, too.)

[...]
> -struct file *anon_inode_getfile(const char *name,
> -                               const struct file_operations *fops,
> -                               void *priv, int flags)
> +struct file *anon_inode_getfile2(const char *name,
> +                                const struct file_operations *fops,
> +                                void *priv, int flags, int anon_inode_flags)

(AFAIK, normal kernel style is to slap a "__" prefix in front of the
function name instead of appending a digit, but I guess it doesn't
really matter.)

>  {
> +       struct inode *inode;
>         struct file *file;
>
> -       if (IS_ERR(anon_inode_inode))
> -               return ERR_PTR(-ENODEV);
> -
> -       if (fops->owner && !try_module_get(fops->owner))
> -               return ERR_PTR(-ENOENT);
> +       if (anon_inode_flags)
> +               return ERR_PTR(-EINVAL);
>
> +       inode = anon_inode_inode;
> +       if (IS_ERR(inode))
> +               return ERR_PTR(-ENODEV);
>         /*
> -        * We know the anon_inode inode count is always greater than zero,
> -        * so ihold() is safe.
> +        * We know the anon_inode inode count is always
> +        * greater than zero, so ihold() is safe.
>          */

This looks like maybe you started editing the comment, then un-did the
change, but left the modified line wrapping in your patch? Please
avoid that - code changes with no real reason make "git blame" output
more annoying and create trouble when porting patches between kernel
versions.

[...]
>  EXPORT_SYMBOL_GPL(anon_inode_getfile);
> +EXPORT_SYMBOL_GPL(anon_inode_getfile2);
[...]
>  EXPORT_SYMBOL_GPL(anon_inode_getfd);
> +EXPORT_SYMBOL_GPL(anon_inode_getfd2);

Since anon_inode_getfd() is now a static inline function in
include/linux/anon_inodes.h, exporting it doesn't make sense anymore.
Same for anon_inode_getfile().

[...]
> +#define ANON_INODE_SECURE 1

That #define belongs in a later patch, right?
