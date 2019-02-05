From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 5 Feb 2019 09:58:39 -0700
Message-ID: <90ebd7ce-6821-aa71-fdba-1e59d30f3d69@kernel.dk>
References: <20190201152414.23296-1-axboe@kernel.dk>
 <20190201152414.23296-6-axboe@kernel.dk>
 <x49sgx3t9yv.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49sgx3t9yv.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On 2/4/19 4:22 PM, Jeff Moyer wrote:
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

Fixed, thanks.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
