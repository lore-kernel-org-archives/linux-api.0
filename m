From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/18] iomap: wire up the iopoll method
Date: Wed, 6 Feb 2019 13:05:01 -0700
Message-ID: <985ef5b8-1078-beb3-69a3-a3a4164d5541@kernel.dk>
References: <20190201152414.23296-1-axboe@kernel.dk>
 <20190201152414.23296-5-axboe@kernel.dk> <1549040392.164323.2.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <1549040392.164323.2.camel@acm.org>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Bart Van Assche <bvanassche@acm.org>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On 2/1/19 9:59 AM, Bart Van Assche wrote:
> On Fri, 2019-02-01 at 08:24 -0700, Jens Axboe wrote:
>> +int iomap_dio_iopoll(struct kiocb *kiocb, bool spin)
>> +{
>> +	struct request_queue *q = READ_ONCE(kiocb->private);
>> +
>> +	if (!q)
>> +		return 0;
>> +	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), spin);
>> +}
>> +EXPORT_SYMBOL_GPL(iomap_dio_iopoll);
> 
> How does this interact with block device removal? My understanding is that this
> function can get called after a request has completed. Which mechanism, if any,
> prevents that request queue 'q' is removed after kiocb->private has been read
> and before blk_poll() is called?

The completion event is split from the reap, the latter being the one that
would put the file. So we're never going to call into ->iopoll() for a
kiocb where we've done the file put.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
