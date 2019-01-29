From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 13:12:55 +0100
Message-ID: <87tvhrpsqg.fsf@oldenburg2.str.redhat.com>
References: <20190128213538.13486-1-axboe@kernel.dk>
	<20190128213538.13486-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128213538.13486-6-axboe@kernel.dk> (Jens Axboe's message of
	"Mon, 28 Jan 2019 14:35:25 -0700")
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

* Jens Axboe:

> +#define IORING_MAX_ENTRIES	4096

Where does this constant come from?  Should it really be exposed to
userspace?

> +struct io_uring_params {
> +	__u32 sq_entries;
> +	__u32 cq_entries;
> +	__u32 flags;
> +	__u16 resv[10];
> +	struct io_sqring_offsets sq_off;
> +	struct io_cqring_offsets cq_off;
> +};

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

Should the reserved fields include a __u64 member, to increase struct
alignment on architectures that might need it in the future?

> +#define IORING_ENTER_GETEVENTS	(1 << 0)

Should this be unsigned, to match the u32 flags argument?  (Otherwise
using 32 flags can be difficult).

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
