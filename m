From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Tue, 7 Mar 2017 18:49:09 +0100
Message-ID: <20170307174909.GA24112@redhat.com>
References: <20170221145746.GA31914@redhat.com>
 <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vasiliy Kulikov <segoon@openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-api@vger.kernel.org

I can't really review this... but in any case I think you should split
this patch to separate the vfs and proc changes.

On 03/07, Alexey Gladkov wrote:
>
> @@ -962,6 +963,14 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
>  	mnt->mnt.mnt_sb = root->d_sb;
>  	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
>  	mnt->mnt_parent = mnt;
> +
> +	err = do_mount_sb(&mnt->mnt, flags, data);
> +	if(err) {
> +		mnt_free_id(mnt);
> +		free_vfsmnt(mnt);
> +		return ERR_PTR(err);
> +	}

This duplicates the error handling, we do the same if mount_fs() fails.
Perhaps you should move these 2 lines into cleanup block and add goto's.

> +int proc_getattrfs(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	struct pid *pid = proc_pid(dentry->d_inode);
> +	struct proc_options *opts = mnt->fs_data;
> +
> +	if (opts && opts->pid_only && mnt->mnt_root != dentry && !pid)
> +		return -ENOENT;

Hmm. I don't quite understand why do we need this, and how this should work.

Yes, "/bin/ls /pidonly-proc/sys" or opendir(/pidonly-proc/sys) should fail,
but only because they both do stat() ?

Afaics you still can do open("/pidonly-proc/sys") + getdents() and this should
work ?

I still think proc_dir_operations.open() makes more sense. Yes, as you pointed
out we also need to update proc_sys_dir_file_operations too and may be something
else...

> +
> +	if (!inode->i_op->getattr) {
> +		generic_fillattr(inode, stat);
> +		return 0;
> +	}
> +
> +	return inode->i_op->getattr(mnt, dentry, stat);
> +}

Oh, it would be nice to not duplicate the code from the caller, imo.

Oleg.
