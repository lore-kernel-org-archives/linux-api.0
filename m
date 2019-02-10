From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/19] io_uring: add io_kiocb ref count
Date: Sun, 10 Feb 2019 10:19:43 +0100
Message-ID: <8766cb28-9d25-0862-2f87-828046b590d0@suse.de>
References: <20190209211346.26060-1-axboe@kernel.dk>
 <20190209211346.26060-17-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190209211346.26060-17-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/9/19 10:13 PM, Jens Axboe wrote:
> We'll use this for the POLL implementation. Regular requests will
> NOT be using references, so initialize it to 0. Any real use of
> the io_kiocb ref will initialize it to at least 2.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
