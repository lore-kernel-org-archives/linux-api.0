From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and ->poll_mask
 methods
Date: Wed, 10 Jan 2018 21:04:16 +0000
Message-ID: <20180110210416.GH13338@ZenIV.linux.org.uk>
References: <20180110155853.32348-1-hch@lst.de>
 <20180110155853.32348-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180110155853.32348-4-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 10, 2018 at 04:58:24PM +0100, Christoph Hellwig wrote:
> ->get_poll_head returns the waitqueue that the poll operation is going
> to sleep on.  Note that this means we can only use a single waitqueue
> for the poll, unlike some current drivers that use two waitqueues for
> different events.  But now that we have keyed wakeups and heavily use
> those for poll there aren't that many good reason left to keep the
> multiple waitqueues, and if there are any ->poll is still around, the
> driver just won't support aio poll.

There's another problem with that - currently ->poll() may tell you "sod off,
I've got nothing for you to sleep on, eat your POLLHUP|POLLERR|something
and don't pester me again".  With your API that's hard to express sanely.

Another piece of fun related to that is handling of disconnects in general -

static __poll_t proc_reg_poll(struct file *file, struct poll_table_struct *pts)
{
        struct proc_dir_entry *pde = PDE(file_inode(file));
        __poll_t rv = DEFAULT_POLLMASK;
        __poll_t (*poll)(struct file *, struct poll_table_struct *);
        if (use_pde(pde)) {
                poll = pde->proc_fops->poll;
                if (poll)
                        rv = poll(file, pts);
                unuse_pde(pde);
        }
        return rv;
}

and similar in sysfs.  

Note, BTW, the places like wait->_qproc = NULL; in do_select() and its ilk.
Some of them are "don't bother putting me on any queues, I won't be sleeping
anyway".  Some are "I'm already on all queues I care about, I'm going to
sleep now and the query everything again once woken up".  It would be nice
to have the method splitup reflect that kind of logics...

What about af_alg_poll(), BTW?  Looks like you've missed that one...

Another thing: IMO file_can_poll() should use FMODE_CAN_POLL - either as
"true if set, otherwise check ->f_op and set accordingly" or set in
do_dentry_open() and just check it in file_can_poll()...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
