From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/19] io_uring: add fsync support
Date: Sat, 9 Feb 2019 10:37:21 +0100
Message-ID: <7adfa86a-a6bd-0f85-d4b8-0d448174b766@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-7-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-7-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add a new fsync opcode, which either syncs a range if one is passed,
> or the whole file if the offset and length fields are both cleared
> to zero.  A flag is provided to use fdatasync semantics, that is only
> force out metadata which is required to retrieve the file data, but
> not others like metadata.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 40 +++++++++++++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h |  8 ++++++-
>   2 files changed, 47 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
