From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/19] io_uring: batch io_kiocb allocation
Date: Sat, 9 Feb 2019 10:43:27 +0100
Message-ID: <e11ef4c5-1b38-cf0e-0906-1ea373691104@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-11-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-11-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> Similarly to how we use the state->ios_left to know how many references
> to get to a file, we can use it to allocate the io_kiocb's we need in
> bulk.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 38 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
