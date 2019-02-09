From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/19] Add io_uring IO interface
Date: Sat, 9 Feb 2019 10:35:26 +0100
Message-ID: <d3ded10b-42f0-d289-17fb-ea59e29da023@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-6-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> The submission queue (SQ) and completion queue (CQ) rings are shared
> between the application and the kernel. This eliminates the need to
> copy data back and forth to submit and complete IO.
> 
> IO submissions use the io_uring_sqe data structure, and completions
> are generated in the form of io_uring_cqe data structures. The SQ
> ring is an index into the io_uring_sqe array, which makes it possible
> to submit a batch of IOs without them being contiguous in the ring.
> The CQ ring is always contiguous, as completion events are inherently
> unordered, and hence any io_uring_cqe entry can point back to an
> arbitrary submission.
> 
> Two new system calls are added for this:
> 
> io_uring_setup(entries, params)
> 	Sets up an io_uring instance for doing async IO. On success,
> 	returns a file descriptor that the application can mmap to
> 	gain access to the SQ ring, CQ ring, and io_uring_sqes.
> 
> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
> 	Initiates IO against the rings mapped to this fd, or waits for
> 	them to complete, or both. The behavior is controlled by the
> 	parameters passed in. If 'to_submit' is non-zero, then we'll
> 	try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
> 	kernel will wait for 'min_complete' events, if they aren't
> 	already available. It's valid to set IORING_ENTER_GETEVENTS
> 	and 'min_complete' == 0 at the same time, this allows the
> 	kernel to return already completed events without waiting
> 	for them. This is useful only for polling, as for IRQ
> 	driven IO, the application can just check the CQ ring
> 	without entering the kernel.
> 
> With this setup, it's possible to do async IO with a single system
> call. Future developments will enable polled IO with this interface,
> and polled submission as well. The latter will enable an application
> to do IO without doing ANY system calls at all.
> 
> For IRQ driven IO, an application only needs to enter the kernel for
> completions if it wants to wait for them to occur.
> 
> Each io_uring is backed by a workqueue, to support buffered async IO
> as well. We will only punt to an async context if the command would
> need to wait for IO on the device side. Any data that can be accessed
> directly in the page cache is done inline. This avoids the slowness
> issue of usual threadpools, since cached data is accessed as quickly
> as a sync interface.
> 
> Sample application: http://git.kernel.dk/cgit/fio/plain/t/io_uring.c
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   arch/x86/entry/syscalls/syscall_32.tbl |    2 +
>   arch/x86/entry/syscalls/syscall_64.tbl |    2 +
>   fs/Makefile                            |    1 +
>   fs/io_uring.c                          | 1175 ++++++++++++++++++++++++
>   include/linux/fs.h                     |    9 +
>   include/linux/syscalls.h               |    6 +
>   include/uapi/asm-generic/unistd.h      |    6 +-
>   include/uapi/linux/io_uring.h          |   95 ++
>   init/Kconfig                           |    9 +
>   kernel/sys_ni.c                        |    2 +
>   net/unix/garbage.c                     |    3 +
>   11 files changed, 1309 insertions(+), 1 deletion(-)
>   create mode 100644 fs/io_uring.c
>   create mode 100644 include/uapi/linux/io_uring.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
