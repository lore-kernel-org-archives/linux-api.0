From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/2] fs: add AT_REPLACE flag for linkat() which
 replaces the target
Date: Tue, 21 Mar 2017 11:44:01 -0700
Message-ID: <20170321184401.GA32507@vader>
References: <cover.1490103963.git.osandov@fb.com>
 <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
 <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>, Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 21, 2017 at 09:30:30AM -0700, Linus Torvalds wrote:
> On Tue, Mar 21, 2017 at 7:51 AM, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org> wrote:
> >   */
> > -int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry, struct inode **delegated_inode)
> > +int vfs_link(struct dentry *old_dentry, struct inode *dir,
> > +            struct dentry *new_dentry, struct inode **delegated_inode,
> > +            unsigned int flags)
> >  {
> >         struct inode *inode = old_dentry->d_inode;
> > +       struct inode *target = new_dentry->d_inode;
> >         unsigned max_links = dir->i_sb->s_max_links;
> >         int error;
> >
> >         if (!inode)
> >                 return -ENOENT;
> >
> > -       error = may_create(dir, new_dentry);
> > +       if (target) {
> > +               if (flags & AT_REPLACE)
> > +                       error = may_delete(dir, new_dentry, d_is_dir(old_dentry));
> > +               else
> > +                       error = -EEXIST;
> > +       } else {
> > +               error = may_create(dir, new_dentry);
> > +       }

Hi, Linus,

Thanks for taking a look. 

> This looks bogus.
> 
> In particular, that "may_delete()" cannot be right. It should still
> *also* have the right to create something in that directory.
> 
> But even if you replace it with checks for both deletion _and_
> creation, it won't be right, since the test for d_is_negative() on the
> target in may_delete() looks wrong for this situation.
> 
> Normally, you cannot delete a negative entry (think of what that would
> do in a overlay situation), but it should still be ok to link a
> positive entry on top of a negative one.

This is actually the exact same check we have in vfs_rename():

----
if (!target) {
	error = may_create(new_dir, new_dentry);
} else {
	new_is_dir = d_is_dir(new_dentry);

	if (!(flags & RENAME_EXCHANGE))
		error = may_delete(new_dir, new_dentry, is_dir);
	else
		error = may_delete(new_dir, new_dentry, new_is_dir);
}
----

I tried to keep the same semantics as rename().

> Also, I think the above is incorrect for yet another case: moving
> somethign on top of a directory should be disallowed. We do later on
> check that the *source* isn't a directory (since you can't link
> directories), but I'm not seeing where you'd be checking that you
> don't move over a directory either.

That check is happening in may_delete():

----
if (isdir) {
	if (!d_is_dir(victim))
		return -ENOTDIR;
	if (IS_ROOT(victim))
		return -EBUSY;
} else if (d_is_dir(victim))
	return -EISDIR;
----

> So I don't think this patch is acceptable as such. I also suspect that
> it should be done in multiple phases.
> 
>                    Linus
