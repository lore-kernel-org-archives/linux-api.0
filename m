From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Mon, 28 Jan 2019 11:25:12 -0700
Message-ID: <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
References: <20190123153536.7081-1-axboe@kernel.dk>
 <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190128145700.GA9795@lst.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-block@vger.kernel.org, jmoyer@redhat.com, avi@scylladb.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 1/28/19 7:57 AM, Christoph Hellwig wrote:
> [please make sure linux-api and linux-man are CCed on new syscalls
> so that we get API experts to review them]
> 
>> io_uring_enter(fd, to_submit, min_complete, flags)
>> 	Initiates IO against the rings mapped to this fd, or waits for
>> 	them to complete, or both. The behavior is controlled by the
>> 	parameters passed in. If 'to_submit' is non-zero, then we'll
>> 	try and submit new IO. If IORING_ENTER_GETEVENTS is set, the
>> 	kernel will wait for 'min_complete' events, if they aren't
>> 	already available. It's valid to set IORING_ENTER_GETEVENTS
>> 	and 'min_complete' == 0 at the same time, this allows the
>> 	kernel to return already completed events without waiting
>> 	for them. This is useful only for polling, as for IRQ
>> 	driven IO, the application can just check the CQ ring
>> 	without entering the kernel.
> 
> Especially with poll support now in the series, don't we need a ѕigmask
> argument similar to pselect/ppoll/io_pgetevents now to deal with signal
> blocking during waiting for events?

Is there any way to avoid passing in the sigset_t size? If it's just a
32-bit/64-bit thing, surely the in_compat_syscall() could cover it? Or
are there other cases that need to be catered to?

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
