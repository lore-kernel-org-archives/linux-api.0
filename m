From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 04 Feb 2019 18:52:35 -0500
Message-ID: <x49o97rt8l8.fsf@segfault.boston.devel.redhat.com>
References: <20190201152414.23296-1-axboe@kernel.dk>
	<20190201152414.23296-6-axboe@kernel.dk>
	<x49sgx3t9yv.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49sgx3t9yv.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 04 Feb 2019 18:22:48 -0500")
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Jens,
>
> Jens Axboe <axboe@kernel.dk> writes:
>
>> +static void io_ring_ctx_free(struct io_ring_ctx *ctx)
>> +{
>> +	destroy_workqueue(ctx->sqo_wq);
>
> You need to make sure sqo_wq is non-null before calling
> destroy_workqueue.

You also need to check for non-null sqo_files and sqo_mm.

Basically, you're tearing things down twice if setup of the context
fails in some way.

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
