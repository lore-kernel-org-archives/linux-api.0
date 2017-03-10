From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sat, 11 Mar 2017 00:46:22 +0100
Message-ID: <20170310234622.GD4554@comp-core-i7-2640m-0182e6>
References: <20170307174909.GA24112@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170307174909.GA24112-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 07, 2017 at 06:49:09PM +0100, Oleg Nesterov wrote:
> I can't really review this... but in any case I think you should split
> this patch to separate the vfs and proc changes.
> 
> On 03/07, Alexey Gladkov wrote:
> >
> > @@ -962,6 +963,14 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
> >  	mnt->mnt.mnt_sb = root->d_sb;
> >  	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
> >  	mnt->mnt_parent = mnt;
> > +
> > +	err = do_mount_sb(&mnt->mnt, flags, data);
> > +	if(err) {
> > +		mnt_free_id(mnt);
> > +		free_vfsmnt(mnt);
> > +		return ERR_PTR(err);
> > +	}
> 
> This duplicates the error handling, we do the same if mount_fs() fails.
> Perhaps you should move these 2 lines into cleanup block and add goto's.
> 
> > +int proc_getattrfs(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> > +{
> > +	struct inode *inode = d_inode(dentry);
> > +	struct pid *pid = proc_pid(dentry->d_inode);
> > +	struct proc_options *opts = mnt->fs_data;
> > +
> > +	if (opts && opts->pid_only && mnt->mnt_root != dentry && !pid)
> > +		return -ENOENT;
> 
> Hmm. I don't quite understand why do we need this, and how this should work.
> 
> Yes, "/bin/ls /pidonly-proc/sys" or opendir(/pidonly-proc/sys) should fail,
> but only because they both do stat() ?
> 
> Afaics you still can do open("/pidonly-proc/sys") + getdents() and this should
> work ?

Yes, you're right! I thought that getattr is called always together with
open(). I wanted to prevent all attempts open() for not-pid directories.

> I still think proc_dir_operations.open() makes more sense. Yes, as you pointed
> out we also need to update proc_sys_dir_file_operations too and may be something
> else...

My main task was to hide all possible direcitrices from the /proc
(in pidonly mode)... even those which we do not know. In this case we
can't rely on the fact that everyone will follow the rules and to
properly handle open().

My current attempt was to force filesystem level check of mountpoint flag.
This is necessary to avoid even the theoretical possibility of ignoring
"pidonly" parameter.

I guess I need to add callback to vfs_open or something to can be sure
that we will not open the wrong file or directory in pidonly mode.

-- 
Rgrds, legion
