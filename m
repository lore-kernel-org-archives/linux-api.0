From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 14:56:27 -0700
Message-ID: <71018780-ac32-4ea8-b4c8-dd6c8bb3cbe1@kernel.dk>
References: <20190128213538.13486-1-axboe@kernel.dk>
 <20190128213538.13486-6-axboe@kernel.dk>
 <x498sz4wisd.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x498sz4wisd.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

On 1/28/19 2:53 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> +static int __io_uring_enter(struct io_ring_ctx *ctx, unsigned to_submit,
>> +			    unsigned min_complete, unsigned flags,
>> +			    const sigset_t __user *sig, size_t sigsz)
>> +{
>> +	int submitted, ret;
>> +
>> +	submitted = ret = 0;
>> +	if (to_submit) {
>> +		submitted = io_ring_submit(ctx, to_submit);
>> +		if (submitted < 0)
>> +			return submitted;
>> +	}
>> +	if (flags & IORING_ENTER_GETEVENTS) {
> 
> Do we want to disallow any unsupported flags?

Yes good point, we do that in other spots. Fixed.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
