From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/32] fs: introduce new ->get_poll_head and ->poll_mask
 methods
Date: Fri, 6 Apr 2018 05:58:33 +0100
Message-ID: <20180406045833.GW30522@ZenIV.linux.org.uk>
References: <20180330150809.28094-1-hch@lst.de>
 <20180330150809.28094-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180330150809.28094-6-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 30, 2018 at 05:07:42PM +0200, Christoph Hellwig wrote:

> +  get_poll_head: Returns the struct wait_queue_head that poll, select,
> +  epoll or aio poll should wait on in case this instance only has single
> +  waitqueue.  Can return NULL to indicate polling is not supported,
> +  or a POLL* value using the POLL_TO_PTR helper in case a grave error
> +  occured and ->poll_mask shall not be called.

> +		if (IS_ERR(head))
> +			return PTR_TO_POLL(head);

> + * ->get_poll_head can return a __poll_t in the PTR_ERR, use these macros
> + * to return the value and recover it.  It takes care of the negation as
> + * well as off the annotations.
> + */
> +#define POLL_TO_PTR(mask)	(ERR_PTR(-(__force int)(mask)))

Uh-oh...
static inline bool __must_check IS_ERR(__force const void *ptr)
{
        return IS_ERR_VALUE((unsigned long)ptr);
}
#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
#define MAX_ERRNO       4095

IOW, your trick relies upon arguments of PTR_TO_POLL being no greater
than 4095.  Now, consider
#define EPOLLRDHUP      (__force __poll_t)0x00002000
which is to say, 8192...

So anything that tries e.g. POLL_TO_PTR(EPOLLRDHUP | EPOLLERR) will be in
for a quiet unpleasant surprise...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
