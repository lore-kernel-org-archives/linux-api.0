From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] simple_char: New infrastructure to simplify chardev
 management
Date: Fri, 27 Mar 2015 01:45:46 -0700
Message-ID: <20150327084546.GA5182@infradead.org>
References: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d3ab93173d51cebf00dd2263fd0ce9f8cd6258f7.1423609645.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> Thoughts?  I want to use this for the u2f driver, which will either be
> a chardev driver in its own right or use a simple new iso7816 class.
> 
> Ideally we could convert a bunch of drivers to use this, at least
> where there are no legacy minor number considerations.

I'd really like to see a few consumer posted with it, to see how the
conversion works.

> -			   topology.o container.o
> +			   topology.o container.o simple_char.o

And the code should probably go into fs/char_dev.c, and have simple
char_ names to that people use it naturally.  A bit of documentation
of all the char interfaces and why you'd want to use this one would
also be useful for driver writers.

> +static int simple_char_open(struct inode *inode, struct file *filep)
> +{
> +	struct simple_char_major *major =
> +		container_of(inode->i_cdev, struct simple_char_major,
> +			     cdev);
> +	void *private;
> +	const struct simple_char_ops *ops;
> +	int ret = 0;
> +
> +	mutex_lock(&major->lock);
> +
> +	{
> +		/*
> +		 * This is a separate block to make the locking entirely
> +		 * clear.  The only thing keeping minor alive is major->lock.
> +		 * We need to be completely done with the simple_char_minor
> +		 * by the time we release the lock.
> +		 */
> +		struct simple_char_minor *minor;
> +		minor = idr_find(&major->idr, iminor(inode));
> +		if (!minor || !minor->ops->reference(minor->private)) {
> +			mutex_unlock(&major->lock);
> +			return -ENODEV;
> +		}
> +		private = minor->private;
> +		ops = minor->ops;
> +	}
> +
> +	mutex_unlock(&major->lock);
> +
> +	replace_fops(filep, ops->fops);
> +	filep->private_data = private;

So we're back to replace_fops here.  I would much prefer if this
would the regions interface so that we don't have to rely on a full
major allocation and replacing live file operations.

> +EXPORT_SYMBOL(simple_char_major_create);

new exported function without any documentation

> +
> +void simple_char_major_free(struct simple_char_major *major)
> +{
> +	BUG_ON(!idr_is_empty(&major->idr));
> +
> +	cdev_del(&major->cdev);
> +	unregister_chrdev_region(MKDEV(major->majornum, 0), MAX_MINORS);
> +	idr_destroy(&major->idr);
> +	kfree(major);
> +}

non-static, non-exported function?

> +/**
> + * simple_char_minor_create() - create a chardev minor
> + * @major:	Major to use or NULL for a fully dynamic chardev.
> + * @ops:	simple_char_ops to associate with the minor.
> + * @private:	opaque pointer for @ops's use.
> + *
> + * simple_char_minor_create() creates a minor chardev.  For new code,
> + * @major should be NULL; this will create a minor chardev with fully
> + * dynamic major and minor numbers and without a useful name in
> + * /proc/devices.  (All recent user code should be using sysfs
> + * exclusively to map between devices and device numbers.)  For legacy
> + * code, @major can come from simple_char_major_create().

Sounds like you should not pass @major for the main interface then,
and instead have a low-level interface that takes the major pointer.
