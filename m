From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2 1/2] fs: add AT_REPLACE flag for linkat() which
 replaces the target
Date: Tue, 21 Mar 2017 09:30:30 -0700
Message-ID: <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA@mail.gmail.com>
References: <cover.1490103963.git.osandov@fb.com> <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Xi Wang <xi@cs.washington.edu>, Omar Sandoval <osandov@fb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 21, 2017 at 7:51 AM, Omar Sandoval <osandov@osandov.com> wrote:
>   */
> -int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry, struct inode **delegated_inode)
> +int vfs_link(struct dentry *old_dentry, struct inode *dir,
> +            struct dentry *new_dentry, struct inode **delegated_inode,
> +            unsigned int flags)
>  {
>         struct inode *inode = old_dentry->d_inode;
> +       struct inode *target = new_dentry->d_inode;
>         unsigned max_links = dir->i_sb->s_max_links;
>         int error;
>
>         if (!inode)
>                 return -ENOENT;
>
> -       error = may_create(dir, new_dentry);
> +       if (target) {
> +               if (flags & AT_REPLACE)
> +                       error = may_delete(dir, new_dentry, d_is_dir(old_dentry));
> +               else
> +                       error = -EEXIST;
> +       } else {
> +               error = may_create(dir, new_dentry);
> +       }

This looks bogus.

In particular, that "may_delete()" cannot be right. It should still
*also* have the right to create something in that directory.

But even if you replace it with checks for both deletion _and_
creation, it won't be right, since the test for d_is_negative() on the
target in may_delete() looks wrong for this situation.

Normally, you cannot delete a negative entry (think of what that would
do in a overlay situation), but it should still be ok to link a
positive entry on top of a negative one.

Also, I think the above is incorrect for yet another case: moving
somethign on top of a directory should be disallowed. We do later on
check that the *source* isn't a directory (since you can't link
directories), but I'm not seeing where you'd be checking that you
don't move over a directory either.

So I don't think this patch is acceptable as such. I also suspect that
it should be done in multiple phases.

                   Linus
