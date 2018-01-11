From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and
	->poll_mask methods
Date: Thu, 11 Jan 2018 12:36:00 +0100
Message-ID: <20180111113600.GA4120@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-4-hch@lst.de> <20180110210416.GH13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180110210416.GH13338@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 10, 2018 at 09:04:16PM +0000, Al Viro wrote:
> There's another problem with that - currently ->poll() may tell you "sod off,
> I've got nothing for you to sleep on, eat your POLLHUP|POLLERR|something
> and don't pester me again".  With your API that's hard to express sanely.

And what exactly can currently tell 'sod off' right now?  ->poll
can only return the (E)POLL* mask.  But what would probably be sane
is to do the same thing in vfs_poll I already do in aio poll:  call
->poll_mask a first time before calling poll_wait to clear any
already pending events.  That way any early error gets instantly
propagated.

> Another piece of fun related to that is handling of disconnects in general -
> 
> static __poll_t proc_reg_poll(struct file *file, struct poll_table_struct *pts)
> {
>         struct proc_dir_entry *pde = PDE(file_inode(file));
>         __poll_t rv = DEFAULT_POLLMASK;
>         __poll_t (*poll)(struct file *, struct poll_table_struct *);
>         if (use_pde(pde)) {
>                 poll = pde->proc_fops->poll;
>                 if (poll)
>                         rv = poll(file, pts);
>                 unuse_pde(pde);
>         }
>         return rv;
> }
> 
> and similar in sysfs.  

Can't find anything in sysfs, but debugfs has an amazingly bad variant
of the above, including confidence ensuring commit description bits like:

    In order not to pollute debugfs with wrapper definitions that aren't ever
    needed, I chose not to define a wrapper for every struct file_operations
    method possible. Instead, a wrapper is defined only for the subset of
    methods which are actually set by any debugfs users.
    Currently, these are:
		     
      ->llseek()
      ->read()
      ->write()
      ->unlocked_ioctl()
      ->poll()

So anyone implementing say, read_iter/write_iter or compat_ioctl
silently doesn't get the magic protection..

Either way - those two will need updating for the new scheme if
we add proc/debugfs ops, so I better do them now and convert at least
one example each.

> Note, BTW, the places like wait->_qproc = NULL; in do_select() and its ilk.
> Some of them are "don't bother putting me on any queues, I won't be sleeping
> anyway".  Some are "I'm already on all queues I care about, I'm going to
> sleep now and the query everything again once woken up".  It would be nice
> to have the method splitup reflect that kind of logics...

Hmm.  ->poll_mask already is a simple 'are these events pending'
method, and thuse should deal perfectly fine with both cases.  What
additional split do you think would be helpful?

> What about af_alg_poll(), BTW?  Looks like you've missed that one...

Converted for the next iteration.

> Another thing: IMO file_can_poll() should use FMODE_CAN_POLL - either as
> "true if set, otherwise check ->f_op and set accordingly" or set in
> do_dentry_open() and just check it in file_can_poll()...

I don't really see the point of wasting a fmode bit for it.  But
if really want that I cna do it.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
