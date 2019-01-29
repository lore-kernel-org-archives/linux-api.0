From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 07/18] io_uring: support for IO polling
Date: Tue, 29 Jan 2019 15:35:30 -0500
Message-ID: <x49o97zi4ml.fsf@segfault.boston.devel.redhat.com>
References: <20190128213538.13486-1-axboe@kernel.dk>
	<20190128213538.13486-8-axboe@kernel.dk>
	<20190129172414.GA15347@lst.de>
	<f21fc281-bbaa-3af5-3d64-a55933f1cbfb@kernel.dk>
	<cd1b43b7-7116-e53c-91fa-168e6c249e63@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <cd1b43b7-7116-e53c-91fa-168e6c249e63@kernel.dk> (Jens Axboe's
	message of "Tue, 29 Jan 2019 12:10:08 -0700")
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 1/29/19 11:31 AM, Jens Axboe wrote:
>>> The code looks a little clumsy to me.  Why not:
>>>
>>> 	while (!list_empty(&ctx->poll_list)) {
>>> 		int ret = io_do_iopoll(ctx, nr_events, min);
>>> 		if (ret)
>>> 			return ret;
>>>
>>> 		if (!min || *nr_events >= min)
>>> 			return 0;
>>> 	}
>>>
>>> 	return 1;
>> 
>> I think you messed up the 0/1 here, how about this:
>> 
>> 	while (!list_empty(&ctx->poll_list)) {
>> 		int ret;
>> 
>> 		ret = io_do_iopoll(ctx, nr_events, min);
>> 		if (ret < 0)
>> 			return ret;
>> 		if (!min || *nr_events >= min)
>> 			return 1;
>> 	}
>> 
>> 	return 0;
>
> Or I did... I think yours is correct.

maybe document the return code?  ;-)

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
