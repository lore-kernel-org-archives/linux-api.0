From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/19] io_uring: support for IO polling
Date: Sat, 9 Feb 2019 10:39:59 +0100
Message-ID: <e158e595-fa04-b035-0ab8-f70164780b76@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-8-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-8-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> Add support for a polled io_uring instance. When a read or write is
> submitted to a polled io_uring, the application must poll for
> completions on the CQ ring through io_uring_enter(2). Polled IO may not
> generate IRQ completions, hence they need to be actively found by the
> application itself.
> 
> To use polling, io_uring_setup() must be used with the
> IORING_SETUP_IOPOLL flag being set. It is illegal to mix and match
> polled and non-polled IO on an io_uring.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 274 ++++++++++++++++++++++++++++++++--
>   include/uapi/linux/io_uring.h |   5 +
>   2 files changed, 270 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
