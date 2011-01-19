From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 12:41:58 -0800
Message-ID: <20110119124158.b0348c44.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1295399718.1949.864.camel@sli10-conroe>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 19 Jan 2011 09:15:18 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Subject: add metadata_incore ioctl in vfs
> 
> Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
> such info and uses it to do metadata readahead.
> Filesystem can hook to super_operations.metadata_incore to get metadata in
> specific approach. Next patch will give an example how to implement
> .metadata_incore in btrfs.
> 
> ...
>  
>  /*
> + * Copy info about metadata in memory to userspace
> + * Returns:
> + * = 1, one metadata range copied to userspace
> + * = 0, no more metadata
> + * < 0, error
> + */
> +static int ioctl_metadata_incore(struct file *filp, void __user *argp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	struct metadata_incore_args args;
> +	loff_t offset;
> +	ssize_t size;
> +
> +	if (!sb->s_op->metadata_incore)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&args, argp, sizeof(args)))
> +		return -EFAULT;
> +
> +	/* we check metadata info in page unit */
> +	if (args.offset & ~PAGE_CACHE_MASK)
> +		return -EINVAL;
> +
> +	offset = args.offset;
> +
> +	if (sb->s_op->metadata_incore(sb, &offset, &size) < 0)
> +		return 0;
> +
> +	args.address = offset;
> +	args.size = size;
> +	args.unused = 0;
> +
> +	if (copy_to_user(argp, &args, sizeof(args)))
> +		return -EFAULT;
> +
> +	return 1;
> +}

So userspace opens any file on the fs and runs this ioctl against it?

That's a pretty awkward interface - we're doing an fs-wide operation
but the fs is identified by a single file which happens to live on that
fs.  For example, this precludes a future extension whereby userspace
can query the incore metadata for a particular file.  The statfs
syscall sucks in the same manner.

I don't know if this is worth addressing.  Perhaps require that the
filp refers to the root of the fs?


Also, is this a privileged operation?  If not, then that might be a
problem - could it be used by unprivileged users to work out which
files have been opened recently or something like that?

