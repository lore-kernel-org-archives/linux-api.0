From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/19] io_uring: allow workqueue item to handle multiple
 buffered requests
Date: Sun, 10 Feb 2019 10:31:53 +0100
Message-ID: <476b621e-85e2-35df-c1e3-50395ca4ebeb@suse.de>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-19-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-19-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/9/19 10:13 PM, Jens Axboe wrote:
> Right now we punt any buffered request that ends up triggering an
> -EAGAIN to an async workqueue. This works fine in terms of providing
> async execution of them, but it also can create quite a lot of work
> queue items. For sequentially buffered IO, it's advantageous to
> serialize the issue of them. For reads, the first one will trigger a
> read-ahead, and subsequent request merely end up waiting on later pages
> to complete. For writes, devices usually respond better to streamed
> sequential writes.
> 
> Add state to track the last buffered request we punted to a work queue,
> and if the next one is sequential to the previous, attempt to get the
> previous work item to handle it. We limit the number of sequential
> add-ons to the a multiple (8) of the max read-ahead size of the file.
> This should be a good number for both reads and wries, as it defines the
> max IO size the device can do directly.
> 
> This drastically cuts down on the number of context switches we need to
> handle buffered sequential IO, and a basic test case of copying a big
> file with io_uring sees a 5x speedup.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 269 ++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 218 insertions(+), 51 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
