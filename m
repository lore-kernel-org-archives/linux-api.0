From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: kdbus: add node and filesystem implementation
Date: Fri, 21 Nov 2014 08:56:38 -0800
Message-ID: <20141121165638.GA24866@kroah.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
 <546F606D.40407@oracle.com>
 <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 05:13:26PM +0100, David Herrmann wrote:
> Hi
> 
> On Fri, Nov 21, 2014 at 4:55 PM, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On 11/21/2014 12:02 AM, Greg Kroah-Hartman wrote:
> >> +static struct dentry *fs_dir_iop_lookup(struct inode *dir,
> >> +                                     struct dentry *dentry,
> >> +                                     unsigned int flags)
> >> +{
> >> +     struct dentry *dnew = NULL;
> >> +     struct kdbus_node *parent;
> >> +     struct kdbus_node *node;
> >> +     struct inode *inode;
> >> +
> >> +     parent = kdbus_node_from_dentry(dentry->d_parent);
> >> +     if (!kdbus_node_acquire(parent))
> >> +             return NULL;
> >> +
> >> +     /* returns reference to _acquired_ child node */
> >> +     node = kdbus_node_find_child(parent, dentry->d_name.name);
> >> +     if (node) {
> >> +             dentry->d_fsdata = node;
> >> +             inode = fs_inode_get(dir->i_sb, node);
> >> +             if (IS_ERR(inode))
> >> +                     dnew = ERR_CAST(inode);
> >> +             else
> >> +                     dnew = d_materialise_unique(dentry, inode);
> >
> > d_materialise_unique() is gone in Al's fs tree:
> >
> > [mandatory]
> >         d_materialise_unique() is gone; d_splice_alias() does everything you
> >         need now.  Remember that they have opposite orders of arguments ;-/
> 
> That was actually pushed after we prepared v2, so I haven't seen it
> yet. I now rebased on top of vfs.git#for-next, with
> d_materialise_unique() -> d_splice_alias(). Thanks for the hint!
> 
> > Maybe it's worth basing your git tree on top of Al's rather than a random
> > -rc, since it's now a filesystem?
> 
> Sure, sounds good.

No, I'll keep it as is, we can handle the merge issues later when it
hits Linus's tree, this makes it easier for me and others to test it
out properly.

thanks,

greg k-h
