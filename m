From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] Allow restricting permissions in /proc/sys
Date: Tue, 12 Nov 2019 20:50:50 -0800
Message-ID: <CALCETrUEQMdugz1t6HfK5MvDq_kOw13yuF+98euqVJgZ4WR1VA@mail.gmail.com>
References: <74a91362-247c-c749-5200-7bdce704ed9e@gmail.com> <20191112232239.yevpeemgxz4wy32b@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191112232239.yevpeemgxz4wy32b@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Topi Miettinen <toiwoton@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 12, 2019 at 3:22 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> [Cc+ linux-api@vger.kernel.org]
>
> since that's potentially relevant to quite a few people.
>
> On Sun, Nov 03, 2019 at 04:55:48PM +0200, Topi Miettinen wrote:
> > Several items in /proc/sys need not be accessible to unprivileged
> > tasks. Let the system administrator change the permissions, but only
> > to more restrictive modes than what the sysctl tables allow.
> >
> > Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
> > ---
> >  fs/proc/proc_sysctl.c | 41 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 31 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> > index d80989b6c344..88c4ca7d2782 100644
> > --- a/fs/proc/proc_sysctl.c
> > +++ b/fs/proc/proc_sysctl.c
> > @@ -818,6 +818,10 @@ static int proc_sys_permission(struct inode *inode, int
> > mask)
> >         if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))
> >                 return -EACCES;
> >
> > +       error = generic_permission(inode, mask);
> > +       if (error)
> > +               return error;
> > +
> >         head = grab_header(inode);
> >         if (IS_ERR(head))
> >                 return PTR_ERR(head);
> > @@ -837,9 +841,35 @@ static int proc_sys_setattr(struct dentry *dentry,
> > struct iattr *attr)
> >         struct inode *inode = d_inode(dentry);
> >         int error;
> >
> > -       if (attr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
> > +       if (attr->ia_valid & (ATTR_UID | ATTR_GID))
> >                 return -EPERM;

Supporting at least ATTR_GID would make this much more useful.

> >
> > +       if (attr->ia_valid & ATTR_MODE) {
> > +               struct ctl_table_header *head = grab_header(inode);
> > +               struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> > +               umode_t max_mode = 0777; /* Only these bits may change */
> > +
> > +               if (IS_ERR(head))
> > +                       return PTR_ERR(head);
> > +
> > +               if (!table) /* global root - r-xr-xr-x */
> > +                       max_mode &= ~0222;
> > +               else /*
> > +                     * Don't allow permissions to become less
> > +                     * restrictive than the sysctl table entry
> > +                     */
> > +                       max_mode &= table->mode;

Style nit: please put braces around multi-line if and else branches,
even if they're only multi-line because of comments.

> > +
> > +               sysctl_head_finish(head);
> > +
> > +               /* Execute bits only allowed for directories */
> > +               if (!S_ISDIR(inode->i_mode))
> > +                       max_mode &= ~0111;

Why is this needed?
