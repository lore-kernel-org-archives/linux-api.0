From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [RFC PATCH 03/21] pipe: Use head and tail pointers for the ring,
 not cursor and length
Date: Wed, 16 Oct 2019 09:46:10 +0200
Message-ID: <b8799179-d389-8005-4f6d-845febc3bb23@rasmusvillemoes.dk>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
 <157117609543.15019.17103851546424902507.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117609543.15019.17103851546424902507.stgit@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 15/10/2019 23.48, David Howells wrote:
> Convert pipes to use head and tail pointers for the buffer ring rather than
> pointer and length as the latter requires two atomic ops to update (or a
> combined op) whereas the former only requires one.
> 
>  (1) The head pointer is the point at which production occurs and points to
>      the slot in which the next buffer will be placed.  This is equivalent
>      to pipe->curbuf + pipe->nrbufs.
> 
>      The head pointer belongs to the write-side.
> 
>  (2) The tail pointer is the point at which consumption occurs.  It points
>      to the next slot to be consumed.  This is equivalent to pipe->curbuf.
> 
>      The tail pointer belongs to the read-side.
> 
>  (3) head and tail are allowed to run to UINT_MAX and wrap naturally.  They
>      are only masked off when the array is being accessed, e.g.:
> 
> 	pipe->bufs[head & mask]
> 
>      This means that it is not necessary to have a dead slot in the ring as
>      head == tail isn't ambiguous.
> 
>  (4) The ring is empty if "head == tail".
> 
>  (5) The occupancy of the ring is "head - tail".
> 
>  (6) The number of free slots in the ring is "(tail + pipe->ring_size) -
>      head".

Seems an odd way of writing pipe->ring_size - (head - tail) ; i.e.
obviously #free slots is #size minus #occupancy.

>  (7) The ring is full if "head >= (tail + pipe->ring_size)", which can also
>      be written as "head - tail >= pipe->ring_size".
>

No it cannot, it _must_ be written in the latter form. Assuming
sizeof(int)==1 for simplicity, consider ring_size = 16, tail = 240.
Regardless whether head is 240, 241, ..., 255, 0, tail + ring_size wraps
to 0, so the former expression states the ring is full in all cases.

Better spell out somewhere that while head and tail are free-running, at
any point in time they satisfy the invariant head - tail <= pipe_size
(and also 0 <= head - tail, but that's a tautology for unsigned
ints...). Then it's a matter of taste if one wants to write "full" as
head-tail == pipe_size or head-tail >= pipe_size.

> Also split pipe->buffers into pipe->ring_size (which indicates the size of the
> ring) and pipe->max_usage (which restricts the amount of ring that write() is
> allowed to fill).  This allows for a pipe that is both writable by the kernel
> notification facility and by userspace, allowing plenty of ring space for
> notifications to be added whilst preventing userspace from being able to use
> up too much buffer space.

That seems like something that should be added in a separate patch -
adding ->max_usage and switching appropriate users of ->ring_size over,
so it's more clear where you're using one or the other.

> @@ -1949,8 +1950,12 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>  
>  	pipe_lock(pipe);
>  
> -	bufs = kvmalloc_array(pipe->nrbufs, sizeof(struct pipe_buffer),
> -			      GFP_KERNEL);
> +	head = pipe->head;
> +	tail = pipe->tail;
> +	mask = pipe->ring_size - 1;
> +	count = head - tail;
> +
> +	bufs = kvmalloc_array(count, sizeof(struct pipe_buffer), GFP_KERNEL);
>  	if (!bufs) {
>  		pipe_unlock(pipe);
>  		return -ENOMEM;
> @@ -1958,8 +1963,8 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>  
>  	nbuf = 0;
>  	rem = 0;
> -	for (idx = 0; idx < pipe->nrbufs && rem < len; idx++)
> -		rem += pipe->bufs[(pipe->curbuf + idx) & (pipe->buffers - 1)].len;
> +	for (idx = tail; idx < head && rem < len; idx++)
> +		rem += pipe->bufs[idx & mask].len;
>  
>  	ret = -EINVAL;
>  	if (rem < len)
> @@ -1970,16 +1975,16 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>  		struct pipe_buffer *ibuf;
>  		struct pipe_buffer *obuf;
>  
> -		BUG_ON(nbuf >= pipe->buffers);
> -		BUG_ON(!pipe->nrbufs);
> -		ibuf = &pipe->bufs[pipe->curbuf];
> +		BUG_ON(nbuf >= pipe->ring_size);
> +		BUG_ON(tail == head);
> +		ibuf = &pipe->bufs[tail];

I don't see where tail gets masked between tail = pipe->tail; above and
here, but I may be missing it. In any case, how about seeding head and
tail with something like 1<<20 when creating the pipe so bugs like that
are hit more quickly.

> @@ -515,17 +525,19 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>  static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct pipe_inode_info *pipe = filp->private_data;
> -	int count, buf, nrbufs;
> +	int count, head, tail, mask;
>  
>  	switch (cmd) {
>  		case FIONREAD:
>  			__pipe_lock(pipe);
>  			count = 0;
> -			buf = pipe->curbuf;
> -			nrbufs = pipe->nrbufs;
> -			while (--nrbufs >= 0) {
> -				count += pipe->bufs[buf].len;
> -				buf = (buf+1) & (pipe->buffers - 1);
> +			head = pipe->head;
> +			tail = pipe->tail;
> +			mask = pipe->ring_size - 1;
> +
> +			while (tail < head) {
> +				count += pipe->bufs[tail & mask].len;
> +				tail++;
>  			}

This is broken if head has wrapped but tail has not. It has to be "while
(head - tail)" or perhaps just "while (tail != head)" or something along
those lines.

> @@ -1086,17 +1104,21 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>  	}
>  
>  	/*
> -	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
> -	 * expect a lot of shrink+grow operations, just free and allocate
> -	 * again like we would do for growing. If the pipe currently
> +	 * We can shrink the pipe, if arg is greater than the ring occupancy.
> +	 * Since we don't expect a lot of shrink+grow operations, just free and
> +	 * allocate again like we would do for growing.  If the pipe currently
>  	 * contains more buffers than arg, then return busy.
>  	 */
> -	if (nr_pages < pipe->nrbufs) {
> +	mask = pipe->ring_size - 1;
> +	head = pipe->head & mask;
> +	tail = pipe->tail & mask;
> +	n = pipe->head - pipe->tail;

I think it's confusing to "premask" head and tail here. Can you either
drop that (pipe_set_size should hardly be a hot path?), or perhaps call
them something else to avoid a future reader seeing an unmasked
bufs[head] and thinking that's a bug?

> @@ -1254,9 +1290,10 @@ static ssize_t pipe_get_pages(struct iov_iter *i,
>  		   struct page **pages, size_t maxsize, unsigned maxpages,
>  		   size_t *start)
>  {
> +	unsigned int p_tail;
> +	unsigned int i_head;
>  	unsigned npages;
>  	size_t capacity;
> -	int idx;
>  
>  	if (!maxsize)
>  		return 0;
> @@ -1264,12 +1301,15 @@ static ssize_t pipe_get_pages(struct iov_iter *i,
>  	if (!sanity(i))
>  		return -EFAULT;
>  
> -	data_start(i, &idx, start);
> -	/* some of this one + all after this one */
> -	npages = ((i->pipe->curbuf - idx - 1) & (i->pipe->buffers - 1)) + 1;
> -	capacity = min(npages,maxpages) * PAGE_SIZE - *start;
> +	data_start(i, &i_head, start);
> +	p_tail = i->pipe->tail;
> +	/* Amount of free space: some of this one + all after this one */
> +	npages = (p_tail + i->pipe->ring_size) - i_head;

Hm, it's not clear that this is equivalent to the old computation. Since
it seems repeated in a few places, could it be factored to a little
helper (before this patch) and the "some of this one + all after this
one" comment perhaps expanded to explain what is going on?

Rasmus
