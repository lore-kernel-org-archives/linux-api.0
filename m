From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Fri, 01 Feb 2019 19:20:57 +0100
Message-ID: <871s4r8j5i.fsf@oldenburg2.str.redhat.com>
References: <20190201152414.23296-1-axboe@kernel.dk>
	<20190201152414.23296-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190201152414.23296-6-axboe@kernel.dk> (Jens Axboe's message of
	"Fri, 1 Feb 2019 08:24:01 -0700")
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

* Jens Axboe:

> +/*
> + * Filled with the offset for mmap(2)
> + */
> +struct io_sqring_offsets {
> +	__u32 head;
> +	__u32 tail;
> +	__u32 ring_mask;
> +	__u32 ring_entries;
> +	__u32 flags;
> +	__u32 dropped;
> +	__u32 array;
> +	__u32 resv[3];
> +};
> +
> +struct io_cqring_offsets {
> +	__u32 head;
> +	__u32 tail;
> +	__u32 ring_mask;
> +	__u32 ring_entries;
> +	__u32 overflow;
> +	__u32 cqes;
> +	__u32 resv[4];
> +};
> +
> +/*
> + * io_uring_enter(2) flags
> + */
> +#define IORING_ENTER_GETEVENTS	(1U << 0)
> +
> +/*
> + * Passed in for io_uring_setup(2). Copied back with updated info on success
> + */
> +struct io_uring_params {
> +	__u32 sq_entries;
> +	__u32 cq_entries;
> +	__u32 flags;
> +	__u32 resv[7];
> +	struct io_sqring_offsets sq_off;
> +	struct io_cqring_offsets cq_off;
> +};

I still think it might be a good idea to have one reserved __u64 field
for alignment purposes.

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
