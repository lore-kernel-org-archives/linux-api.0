From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/19] io_uring: add support for pre-mapped user IO
 buffers
Date: Sat, 9 Feb 2019 10:48:24 +0100
Message-ID: <263c8879-76c7-fd53-d37d-68b2e6993a9b@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-13-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-13-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> If we have fixed user buffers, we can map them into the kernel when we
> setup the io_uring. That avoids the need to do get_user_pages() for
> each and every IO.
> 
> To utilize this feature, the application must call io_uring_register()
> after having setup an io_uring instance, passing in
> IORING_REGISTER_BUFFERS as the opcode. The argument must be a pointer to
> an iovec array, and the nr_args should contain how many iovecs the
> application wishes to map.
> 
> If successful, these buffers are now mapped into the kernel, eligible
> for IO. To use these fixed buffers, the application must use the
> IORING_OP_READ_FIXED and IORING_OP_WRITE_FIXED opcodes, and then
> set sqe->index to the desired buffer index. sqe->addr..sqe->addr+seq->len
> must point to somewhere inside the indexed buffer.
> 
> The application may register buffers throughout the lifetime of the
> io_uring instance. It can call io_uring_register() with
> IORING_UNREGISTER_BUFFERS as the opcode to unregister the current set of
> buffers, and then register a new set. The application need not
> unregister buffers explicitly before shutting down the io_uring
> instance.
> 
> It's perfectly valid to setup a larger buffer, and then sometimes only
> use parts of it for an IO. As long as the range is within the originally
> mapped region, it will work just fine.
> 
> For now, buffers must not be file backed. If file backed buffers are
> passed in, the registration will fail with -1/EOPNOTSUPP. This
> restriction may be relaxed in the future.
> 
> RLIMIT_MEMLOCK is used to check how much memory we can pin. A somewhat
> arbitrary 1G per buffer size is also imposed.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>   arch/x86/entry/syscalls/syscall_64.tbl |   1 +
>   fs/io_uring.c                          | 356 ++++++++++++++++++++++++-
>   include/linux/sched/user.h             |   2 +-
>   include/linux/syscalls.h               |   2 +
>   include/uapi/asm-generic/unistd.h      |   4 +-
>   include/uapi/linux/io_uring.h          |  13 +-
>   kernel/sys_ni.c                        |   1 +
>   8 files changed, 363 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
