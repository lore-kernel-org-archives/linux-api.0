From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/19] io_uring: add file set registration
Date: Sat, 9 Feb 2019 10:50:54 +0100
Message-ID: <d9af9360-fc31-581c-c5c1-bd32bd4814af@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-15-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-15-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> We normally have to fget/fput for each IO we do on a file. Even with
> the batching we do, the cost of the atomic inc/dec of the file usage
> count adds up.
> 
> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
> for the io_uring_register(2) system call. The arguments passed in must
> be an array of __s32 holding file descriptors, and nr_args should hold
> the number of file descriptors the application wishes to pin for the
> duration of the io_uring instance (or until IORING_UNREGISTER_FILES is
> called).
> 
> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
> to the index in the array passed in to IORING_REGISTER_FILES.
> 
> Files are automatically unregistered when the io_uring instance is torn
> down. An application need only unregister if it wishes to register a new
> set of fds.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c                 | 256 ++++++++++++++++++++++++++++++----
>   include/uapi/linux/io_uring.h |   9 +-
>   2 files changed, 235 insertions(+), 30 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
