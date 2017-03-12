From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sun, 12 Mar 2017 02:13:02 +0000
Message-ID: <20170312021257.GP29622@ZenIV.linux.org.uk>
References: <20170221145746.GA31914@redhat.com>
 <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <20170312015430.GO29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170312015430.GO29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 12, 2017 at 01:54:38AM +0000, Al Viro wrote:
> On Tue, Mar 07, 2017 at 12:05:16AM +0100, Alexey Gladkov wrote:
> 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 83de8b6..5bd1b84 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1759,6 +1759,8 @@ struct super_operations {
> >  	int (*thaw_super) (struct super_block *);
> >  	int (*unfreeze_fs) (struct super_block *);
> >  	int (*statfs) (struct dentry *, struct kstatfs *);
> > +	int (*getattr_fs) (struct vfsmount *, struct dentry *, struct kstat *);
> > +	int (*mount_fs) (struct vfsmount *, int *, char *);
> >  	int (*remount_fs) (struct super_block *, int *, char *);
> >  	void (*umount_begin) (struct super_block *);
> >  
> > diff --git a/include/linux/mount.h b/include/linux/mount.h
> > index 1172cce..4bd364e 100644
> > --- a/include/linux/mount.h
> > +++ b/include/linux/mount.h
> > @@ -67,6 +67,7 @@ struct vfsmount {
> >  	struct dentry *mnt_root;	/* root of the mounted tree */
> >  	struct super_block *mnt_sb;	/* pointer to superblock */
> >  	int mnt_flags;
> > +	void *fs_data;			/* fs-specific data */
> 
> 	No.  This is really asking for trouble - you *can't* hang
> fs-specific data structures off vfsmount.  Lifetimes make no
> sense whatsoever.
>
> 	BTW, your patch leaks supreblock reference on failure, and
> is kludgy as hell wrt to what it's doing in procfs itself, but
> that's secondary - the quoted part is enough for a hard NAK on
> architectural grounds.  Don't go there.

PS: AFAICS, simple mount --bind of your pid-only mount will suddenly
expose the full thing.  And as for the lifetimes making no sense...
note that you are simply not freeing these structures of yours.
Try to handle that and you'll get a serious PITA all over the
place.

What are you trying to achieve, anyway?  Why not add a second vfsmount
pointer per pid_namespace and make it initialized on demand, at the
first attempt of no-pid mount?  Just have a separate no-pid instance
created for those namespaces where it had been asked for, with
separate superblock and dentry tree not containing anything other
that pid-only parts + self + thread-self...
