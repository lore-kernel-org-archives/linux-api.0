From: Bert Wesarg <bert.wesarg@googlemail.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 08:12:08 +0100
Message-ID: <CAKPyHN2UyExWDRqO=oTZP2UdR8naYO_Tv2eVw+CQBEfs7_uuVg@mail.gmail.com>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-6-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 10:35 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> The submission queue (SQ) and completion queue (CQ) rings are shared
> between the application and the kernel. This eliminates the need to
> copy data back and forth to submit and complete IO.
>
> IO submissions use the io_uring_sqe data structure, and completions
> are generated in the form of io_uring_sqe data structures. The SQ
> ring is an index into the io_uring_sqe array, which makes it possible
> to submit a batch of IOs without them being contiguous in the ring.
> The CQ ring is always contiguous, as completion events are inherently
> unordered, and hence any io_uring_cqe entry can point back to an
> arbitrary submission.
>
> Two new system calls are added for this:
>
> io_uring_setup(entries, params)
>         Sets up a context for doing async IO. On success, returns a file
>         descriptor that the application can mmap to gain access to the
>         SQ ring, CQ ring, and io_uring_sqes.
>
> io_uring_enter(fd, to_submit, min_complete, flags, sigset, sigsetsize)
>         Initiates IO against the rings mapped to this fd, or waits for
>         them to complete, or both. The behavior is controlled by the
>         parameters passed in. If 'to_submit' is non-zero, then we'll
>         try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>         kernel will wait for 'min_complete' events, if they aren't
>         already available. It's valid to set IORING_ENTER_GETEVENTS
>         and 'min_complete' == 0 at the same time, this allows the
>         kernel to return already completed events without waiting
>         for them. This is useful only for polling, as for IRQ
>         driven IO, the application can just check the CQ ring
>         without entering the kernel.
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
>  arch/x86/entry/syscalls/syscall_32.tbl |    2 +
>  arch/x86/entry/syscalls/syscall_64.tbl |    2 +
>  fs/Makefile                            |    1 +
>  fs/io_uring.c                          | 1090 ++++++++++++++++++++++++
>  include/linux/syscalls.h               |    6 +
>  include/uapi/asm-generic/unistd.h      |    6 +-
>  include/uapi/linux/io_uring.h          |   96 +++
>  init/Kconfig                           |    9 +
>  kernel/sys_ni.c                        |    2 +
>  9 files changed, 1213 insertions(+), 1 deletion(-)
>  create mode 100644 fs/io_uring.c
>  create mode 100644 include/uapi/linux/io_uring.h
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> new file mode 100644
> index 000000000000..ce65db9269a8
> --- /dev/null
> +++ b/include/uapi/linux/io_uring.h
> @@ -0,0 +1,96 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Header file for the io_uring interface.
> + *
> + * Copyright (C) 2019 Jens Axboe
> + * Copyright (C) 2019 Christoph Hellwig
> + */
> +#ifndef LINUX_IO_URING_H
> +#define LINUX_IO_URING_H
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +
> +#define IORING_MAX_ENTRIES     4096
> +
> +/*
> + * IO submission data structure (Submission Queue Entry)
> + */
> +struct io_uring_sqe {
> +       __u8    opcode;         /* type of operation for this sqe */
> +       __u8    flags;          /* as of now unused */
> +       __u16   ioprio;         /* ioprio for the request */
> +       __s32   fd;             /* file descriptor to do IO on */
> +       __u64   off;            /* offset into file */
> +       __u64   addr;           /* pointer to buffer or iovecs */
> +       __u32   len;            /* buffer size or number of iovecs */
> +       union {
> +               __kernel_rwf_t  rw_flags;
> +               __u32           __resv;
> +       };
> +       __u64   user_data;      /* data to be passed back at completion time */
> +       __u64   __pad2[3];
> +};
> +
> +#define IORING_OP_NOP          0
> +#define IORING_OP_READV                1
> +#define IORING_OP_WRITEV       2
> +
> +/*
> + * IO completion data structure (Completion Queue Entry)
> + */
> +struct io_uring_cqe {
> +       __u64   user_data;      /* sqe->data submission passed back */
> +       __s32   res;            /* result code for this event */
> +       __u32   flags;
> +};
> +
> +/*
> + * Magic offsets for the application to mmap the data it needs
> + */
> +#define IORING_OFF_SQ_RING             0ULL
> +#define IORING_OFF_CQ_RING             0x8000000ULL
> +#define IORING_OFF_SQES                        0x10000000ULL
> +
> +/*
> + * Filled with the offset for mmap(2)
> + */
> +struct io_sqring_offsets {
> +       __u32 head;
> +       __u32 tail;
> +       __u32 ring_mask;
> +       __u32 ring_entries;
> +       __u32 flags;
> +       __u32 dropped;
> +       __u32 array;
> +       __u32 resv[3];
> +};
> +
> +struct io_cqring_offsets {
> +       __u32 head;
> +       __u32 tail;
> +       __u32 ring_mask;
> +       __u32 ring_entries;
> +       __u32 overflow;
> +       __u32 cqes;
> +       __u32 resv[4];
> +};
> +
> +/*
> + * io_uring_enter(2) flags
> + */
> +#define IORING_ENTER_GETEVENTS (1 << 0)
> +
> +/*
> + * Passed in for io_uring_setup(2). Copied back with updated info on success
> + */
> +struct io_uring_params {
> +       __u32 sq_entries;
> +       __u32 cq_entries;
> +       __u32 flags;
> +       __u16 resv[10];
> +       struct io_sqring_offsets sq_off;
> +       struct io_cqring_offsets cq_off;
> +};
> +
> +#endif

from a user perspective, it should always be easier if all exported
symbols and macros have a common prefix. Here it seems particular
worrisome, because of the missing 'u' in in the defines.

Best,
Bert

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
