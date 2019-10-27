From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sun, 27 Oct 2019 19:04:35 +0300
Message-ID: <c6e044cc-5596-90b7-4418-6ad7009d6d79@yandex-team.ru>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <30394.1571936252@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30394.1571936252@warthog.procyon.org.uk>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 24/10/2019 19.57, David Howells wrote:
> pipe: Add fsync() support
> 
> The keyrings testsuite needs the ability to wait for all the outstanding
> notifications in the queue to have been processed so that it can then go
> through them to find out whether the notifications it expected have been
> emitted.

Similar synchronization is required for reusing memory after vmsplice()?
I don't see other way how sender could safely change these pages.

> 
> Implement fsync() support for pipes to provide this.  The tailmost buffer
> at the point of calling is marked and fsync adds itself to the list of
> waiters, noting the tail position to be waited for and marking the buffer
> as no longer mergeable.  Then when the buffer is consumed, if the flag is
> set, any matching waiters are woken up.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>   fs/fuse/dev.c             |    1
>   fs/pipe.c                 |   61 ++++++++++++++++++++++++++++++++++++++++++++++
>   fs/splice.c               |    3 ++
>   include/linux/pipe_fs_i.h |   22 ++++++++++++++++
>   lib/iov_iter.c            |    2 -
>   5 files changed, 88 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5ef57a322cb8..9617a35579cb 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1983,6 +1983,7 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
>   		if (rem >= ibuf->len) {
>   			*obuf = *ibuf;
>   			ibuf->ops = NULL;
> +			pipe_wake_fsync(pipe, ibuf, tail);
>   			tail++;
>   			pipe_commit_read(pipe, tail);
>   		} else {
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 6a982a88f658..8e5fd7314be1 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -30,6 +30,12 @@
>   
>   #include "internal.h"
>   
> +struct pipe_fsync {
> +	struct list_head	link;		/* Link in pipe->fsync */
> +	struct completion	done;
> +	unsigned int		tail;		/* The buffer being waited for */
> +};
> +
>   /*
>    * The max size that a non-root user is allowed to grow the pipe. Can
>    * be set by root in /proc/sys/fs/pipe-max-size
> @@ -269,6 +275,58 @@ static bool pipe_buf_can_merge(struct pipe_buffer *buf)
>   	return buf->ops == &anon_pipe_buf_ops;
>   }
>   
> +/*
> + * Wait for all the data currently in the pipe to be consumed.
> + */
> +static int pipe_fsync(struct file *file, loff_t a, loff_t b, int datasync)
> +{
> +	struct pipe_inode_info *pipe = file->private_data;
> +	struct pipe_buffer *buf;
> +	struct pipe_fsync fsync;
> +	unsigned int head, tail, mask;
> +
> +	pipe_lock(pipe);
> +
> +	head = pipe->head;
> +	tail = pipe->tail;
> +	mask = pipe->ring_size - 1;
> +
> +	if (pipe_empty(head, tail)) {
> +		pipe_unlock(pipe);
> +		return 0;
> +	}
> +
> +	init_completion(&fsync.done);
> +	fsync.tail = tail;
> +	buf = &pipe->bufs[tail & mask];
> +	buf->flags |= PIPE_BUF_FLAG_FSYNC;
> +	pipe_buf_mark_unmergeable(buf);
> +	list_add_tail(&fsync.link, &pipe->fsync);
> +	pipe_unlock(pipe);
> +
> +	if (wait_for_completion_interruptible(&fsync.done) < 0) {
> +		pipe_lock(pipe);
> +		list_del(&fsync.link);
> +		pipe_unlock(pipe);
> +		return -EINTR;
> +	}
> +
> +	return 0;
> +}
> +
> +void __pipe_wake_fsync(struct pipe_inode_info *pipe, unsigned int tail)
> +{
> +	struct pipe_fsync *fsync, *p;
> +
> +	list_for_each_entry_safe(fsync, p, &pipe->fsync, link) {
> +		if (fsync->tail == tail) {
> +			list_del_init(&fsync->link);
> +			complete(&fsync->done);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(__pipe_wake_fsync);
> +
>   static ssize_t
>   pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   {
> @@ -325,6 +383,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   			if (!buf->len) {
>   				pipe_buf_release(pipe, buf);
>   				spin_lock_irq(&pipe->wait.lock);
> +				pipe_wake_fsync(pipe, buf, tail);
>   				tail++;
>   				pipe_commit_read(pipe, tail);
>   				do_wakeup = 1;
> @@ -717,6 +776,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
>   		pipe->ring_size = pipe_bufs;
>   		pipe->user = user;
>   		mutex_init(&pipe->mutex);
> +		INIT_LIST_HEAD(&pipe->fsync);
>   		return pipe;
>   	}
>   
> @@ -1060,6 +1120,7 @@ const struct file_operations pipefifo_fops = {
>   	.llseek		= no_llseek,
>   	.read_iter	= pipe_read,
>   	.write_iter	= pipe_write,
> +	.fsync		= pipe_fsync,
>   	.poll		= pipe_poll,
>   	.unlocked_ioctl	= pipe_ioctl,
>   	.release	= pipe_release,
> diff --git a/fs/splice.c b/fs/splice.c
> index 3f72bc31b6ec..e106367e1be6 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -523,6 +523,7 @@ static int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_des
>   
>   		if (!buf->len) {
>   			pipe_buf_release(pipe, buf);
> +			pipe_wake_fsync(pipe, buf, tail);
>   			tail++;
>   			pipe_commit_read(pipe, tail);
>   			if (pipe->files)
> @@ -771,6 +772,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>   				ret -= buf->len;
>   				buf->len = 0;
>   				pipe_buf_release(pipe, buf);
> +				pipe_wake_fsync(pipe, buf, tail);
>   				tail++;
>   				pipe_commit_read(pipe, tail);
>   				if (pipe->files)
> @@ -1613,6 +1615,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
>   			 */
>   			*obuf = *ibuf;
>   			ibuf->ops = NULL;
> +			pipe_wake_fsync(ipipe, ibuf, i_tail);
>   			i_tail++;
>   			pipe_commit_read(ipipe, i_tail);
>   			input_wakeup = true;
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index 90055ff16550..1a3027089558 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -8,6 +8,7 @@
>   #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
>   #define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
>   #define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
> +#define PIPE_BUF_FLAG_FSYNC	0x10	/* fsync() is waiting for this buffer to die */
>   
>   /**
>    *	struct pipe_buffer - a linux kernel pipe buffer
> @@ -43,6 +44,7 @@ struct pipe_buffer {
>    *	@w_counter: writer counter
>    *	@fasync_readers: reader side fasync
>    *	@fasync_writers: writer side fasync
> + *	@fsync: Waiting fsyncs
>    *	@bufs: the circular array of pipe buffers
>    *	@user: the user who created this pipe
>    **/
> @@ -62,6 +64,7 @@ struct pipe_inode_info {
>   	struct page *tmp_page;
>   	struct fasync_struct *fasync_readers;
>   	struct fasync_struct *fasync_writers;
> +	struct list_head fsync;
>   	struct pipe_buffer *bufs;
>   	struct user_struct *user;
>   };
> @@ -268,6 +271,25 @@ extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
>   long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
>   struct pipe_inode_info *get_pipe_info(struct file *file);
>   
> +void __pipe_wake_fsync(struct pipe_inode_info *pipe, unsigned int tail);
> +
> +/**
> + * pipe_wake_fsync - Wake up anyone waiting with fsync for this point
> + * @pipe: The pipe that owns the buffer
> + * @buf: The pipe buffer in question
> + * @tail: The index in the ring of the buffer
> + *
> + * Check to see if anyone is waiting for the pipe ring to clear up to and
> + * including this buffer, and, if they are, wake them up.
> + */
> +static inline void pipe_wake_fsync(struct pipe_inode_info *pipe,
> +				   struct pipe_buffer *buf,
> +				   unsigned int tail)
> +{
> +	if (unlikely(buf->flags & PIPE_BUF_FLAG_FSYNC))
> +		__pipe_wake_fsync(pipe, tail);
> +}
> +
>   int create_pipe_files(struct file **, int);
>   unsigned int round_pipe_size(unsigned long size);
>   
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index e22f4e283f6d..38d52524cd21 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -404,7 +404,7 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
>   	buf->offset = offset;
>   	buf->len = bytes;
>   
> -	pipe_commit_read(pipe, i_head);
> +	pipe_commit_write(pipe, i_head);
>   	i->iov_offset = offset + bytes;
>   	i->head = i_head;
>   out:
> 
> 
