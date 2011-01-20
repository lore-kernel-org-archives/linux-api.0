From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 10:30:47 +0800
Message-ID: <1295490647.1949.890.camel@sli10-conroe>
References: <1295399718.1949.864.camel@sli10-conroe>
	 <20110119124158.b0348c44.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110119124158.b0348c44.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 04:41 +0800, Andrew Morton wrote:
> On Wed, 19 Jan 2011 09:15:18 +0800
> Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Subject: add metadata_incore ioctl in vfs
> > 
> > Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
> > such info and uses it to do metadata readahead.
> > Filesystem can hook to super_operations.metadata_incore to get metadata in
> > specific approach. Next patch will give an example how to implement
> > .metadata_incore in btrfs.
> > 
> > ...
> >  
> >  /*
> > + * Copy info about metadata in memory to userspace
> > + * Returns:
> > + * = 1, one metadata range copied to userspace
> > + * = 0, no more metadata
> > + * < 0, error
> > + */
> > +static int ioctl_metadata_incore(struct file *filp, void __user *argp)
> > +{
> > +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> > +	struct metadata_incore_args args;
> > +	loff_t offset;
> > +	ssize_t size;
> > +
> > +	if (!sb->s_op->metadata_incore)
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&args, argp, sizeof(args)))
> > +		return -EFAULT;
> > +
> > +	/* we check metadata info in page unit */
> > +	if (args.offset & ~PAGE_CACHE_MASK)
> > +		return -EINVAL;
> > +
> > +	offset = args.offset;
> > +
> > +	if (sb->s_op->metadata_incore(sb, &offset, &size) < 0)
> > +		return 0;
> > +
> > +	args.address = offset;
> > +	args.size = size;
> > +	args.unused = 0;
> > +
> > +	if (copy_to_user(argp, &args, sizeof(args)))
> > +		return -EFAULT;
> > +
> > +	return 1;
> > +}
> 
> So userspace opens any file on the fs and runs this ioctl against it?
> 
> That's a pretty awkward interface - we're doing an fs-wide operation
> but the fs is identified by a single file which happens to live on that
> fs.  For example, this precludes a future extension whereby userspace
> can query the incore metadata for a particular file.  The statfs
> syscall sucks in the same manner.
> 
> I don't know if this is worth addressing.  Perhaps require that the
> filp refers to the root of the fs?
I didn't see why this is needed, but I can limit the fip to the root of
the fs.

> Also, is this a privileged operation?  If not, then that might be a
> problem - could it be used by unprivileged users to work out which
> files have been opened recently or something like that?
it's harmless even a unprivileged user uses it. I don't think
unprivileged user can decode the data returned from the ioctl.

Thanks,
Shaohua
