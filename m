From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/19] io_uring: add support for IORING_OP_POLL
Date: Sun, 10 Feb 2019 10:28:00 +0100
Message-ID: <3f422430-4e91-316b-9f8a-8b7ff99aad56@suse.de>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-18-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-18-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/9/19 10:13 PM, Jens Axboe wrote:
> This is basically a direct port of bfe4037e722e, which implements a
> one-shot poll command through aio. Description below is based on that
> commit as well. However, instead of adding a POLL command and relying
> on io_cancel(2) to remove it, we mimic the epoll(2) interface of
> having a command to add a poll notification, IORING_OP_POLL_ADD,
> and one to remove it again, IORING_OP_POLL_REMOVE.
> 
> To poll for a file descriptor the application should submit an sqe of
> type IORING_OP_POLL. It will poll the fd for the events specified in the
> poll_events field.
> 
> Unlike poll or epoll without EPOLLONESHOT this interface always works in
> one shot mode, that is once the sqe is completed, it will have to be
> resubmitted.
> 
> Based-on-code-from: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 261 +++++++++++++++++++++++++++++++++-
>   include/uapi/linux/io_uring.h |   3 +
>   2 files changed, 263 insertions(+), 1 deletion(-)
> 
I still would like to be able to properly terminate the I/O on 
aio_cancel. But this can probably be done in a later patch.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
