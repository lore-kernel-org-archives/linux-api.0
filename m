From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ipc: Modify message queue accounting to reflect both
 total user data and auxiliary kernel data
Date: Tue, 16 Jun 2015 09:36:19 +0200
Message-ID: <557FD1F3.7050705@gmail.com>
References: <20150613194039.GB31082@ramsey.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150613194039.GB31082-W7fNxlbxG8VSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Added a couple of people into CC that I know are interested/participated
in past discussions that were related. Also added linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

Background for those new to the topic:

    The pseudofiles in the mqueue filesystem (usually mounted at
    /dev/mqueue) expose fields with metadata describing a message
    queue. One of these fields, QSIZE, as originally implemented,
    showed the total number of bytes of user data in all messages in
    the message queue, and this feature was documented from the 
    beginning in the mq_overview(7) page. In 3.5, some other (useful)
    work happened to break the user-space API in a couple of places,
    including the value exposed via QSIZE, which now includes a measure 
    of kernel overhead bytes for the queue, a figure that renders QSIZE
    useless for its original purpose, since there's no way to deduce
    the number of overhead bytes consumed by the implementation.
    (The other user-space breakage was subsequently fixed.)


Hi Marcus,

On 06/13/2015 09:40 PM, Marcus Gelderie wrote:
> A while back, the message queue implementation in the kernel was
> improved to use btrees to speed up retrieval of messages (commit
> d6629859b36). The patch introducing the improved kernel handling of
> message queues has, as a by-product, changed the meaning of the 
> QSIZE field in the pseudo-file created for the queue. Before, this 
> field reflected the size of the user-data in the queue. Since, it 
> now also takes kernel data structures into account, this is no no longer
> true. For example, if 13 bytes of user data are in the queue, on my 
> machine the file reports a size of 61 bytes.

Thanks for taking a look at this. This user-space breakage been one of 
those nagging things I've wanted to see fixed for a while now, and since
the earlier discussion, I've heard from one or two people who were 
unpleasantly surprised by this API change.

> There was some discussion on this topic before (for example
> https://lkml.org/lkml/2014/10/1/115). Reporting the size of the
> message queue in kernel has its merits, but doing so in the QSIZE
> field of the pseudo file corresponding to the queue is a breaking
> change. This patch therefore returns the QSIZE field to its original
> meaning. At the same time, it introduces a new field QKERSIZE that
> reflects the size of the queue in kernel (user data + kernel data).
> 
> If the accounting should be improved, I'd be happy to take a look at 
> that, too. I would propose to do that in terms of the newly introduced
> field.

The general approach seems good to me. Making the new QKERSIZE the last
field, as you have done, so that any applications that were parsing
an mqueue file in a really dumb fashion (by ordinal position, rather 
than checking field names) seems good to me.

Acked-by: Michael Kerrisk <mtk,manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Assuming this approach is acceptable, this patch should eventually go 
to stable@ so it is backported to older stable kernels. In the event
that you need to resubmit the patch, I suggest including some of the
background detail I give above in the commit message.

Cheers,

Michael

> Signed-off-by: Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  ipc/mqueue.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 3aaea7f..7d4c464 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -41,7 +41,7 @@
>  
>  #define MQUEUE_MAGIC	0x19800202
>  #define DIRENT_SIZE	20
> -#define FILENT_SIZE	80
> +#define FILENT_SIZE	90
>  
>  #define SEND		0
>  #define RECV		1
> @@ -82,8 +82,12 @@ struct mqueue_inode_info {
>  	/* for tasks waiting for free space and messages, respectively */
>  	struct ext_wait_queue e_wait_q[2];
>  
> -	unsigned long qsize; /* size of queue in memory (sum of all msgs) */
> -};
> +	/* size of queue in memory (sum of all msgs plus kernel
> +	 * data structures) */
> +	unsigned long qsize;
> +
> +	/* size of user data in the queue (sum of all msgs) */
> +	unsigned long q_usersize; };
>  
>  static const struct inode_operations mqueue_dir_inode_operations;
>  static const struct file_operations mqueue_file_operations;
> @@ -151,6 +155,7 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
>  insert_msg:
>  	info->attr.mq_curmsgs++;
>  	info->qsize += msg->m_ts;
> +	info->q_usersize += msg->m_ts;
>  	list_add_tail(&msg->m_list, &leaf->msg_list);
>  	return 0;
>  }
> @@ -210,6 +215,7 @@ try_again:
>  	}
>  	info->attr.mq_curmsgs--;
>  	info->qsize -= msg->m_ts;
> +	info->q_usersize -= msg->m_ts;
>  	return msg;
>  }
>  
> @@ -246,6 +252,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  		info->notify_owner = NULL;
>  		info->notify_user_ns = NULL;
>  		info->qsize = 0;
> +		info->q_usersize = 0;
>  		info->user = NULL;	/* set when all is ok */
>  		info->msg_tree = RB_ROOT;
>  		info->node_cache = NULL;
> @@ -491,13 +498,14 @@ static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
>  
>  	spin_lock(&info->lock);
>  	snprintf(buffer, sizeof(buffer),
> -			"QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d\n",
> -			info->qsize,
> +			"QSIZE:%-10lu NOTIFY:%-5d SIGNO:%-5d NOTIFY_PID:%-6d QKERSIZE:%-10lu\n",
> +			info->q_usersize,
>  			info->notify_owner ? info->notify.sigev_notify : 0,
>  			(info->notify_owner &&
>  			 info->notify.sigev_notify == SIGEV_SIGNAL) ?
>  				info->notify.sigev_signo : 0,
> -			pid_vnr(info->notify_owner));
> +			pid_vnr(info->notify_owner),
> +			info->qsize);
>  	spin_unlock(&info->lock);
>  	buffer[sizeof(buffer)-1] = '\0';
>  
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
