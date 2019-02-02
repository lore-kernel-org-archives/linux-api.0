From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v11] io_uring IO interface
Date: Sat, 2 Feb 2019 06:52:09 -0700
Message-ID: <1cb6406f-1408-c38c-e8ed-520bce965569@kernel.dk>
References: <20190201152414.23296-1-axboe@kernel.dk>
 <1549061551.164323.17.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <1549061551.164323.17.camel@acm.org>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Bart Van Assche <bvanassche@acm.org>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com
List-Id: linux-api@vger.kernel.org

On 2/1/19 3:52 PM, Bart Van Assche wrote:
> On Fri, 2019-02-01 at 08:23 -0700, Jens Axboe wrote:
>> Here's v11 of the io_uring project. Main fixes in this release is a
>> rework of how we grab the ctx->uring_lock, never using trylock for it in
>> a user visible way. Outside of that, fixes around locking for the polled
>> list when we hit -EAGAIN conditions on IO submit. This fixes list
>> corruption issues with polling that some users have reported.
>>
>> As far as I'm concerned, this project is ready to get staged for 5.1.
>> Please do review carefully so we can fix any minor nits that might still
>> exist.
>>
>> The liburing git repo has a full set of man pages for this, though they
>> could probably still use a bit of polish. I'd also like to see a
>> io_uring(7) man page to describe the overall design of the project,
>> expect that in the not-so-distant future. You can clone that here:
>>
>> git://git.kernel.dk/liburing
>>
>> Patches are against 5.0-rc4, and can also be found in my io_uring branch
>> here:
>>
>> git://git.kernel.dk/linux-block io_uring
>>
>> Changes since v10:
>> - Rework uring_lock locking
>> - Ensure that async contexts lock when fiddling with polled lists
>> - Minor tweak to io_iopoll_check() continue looping condition
>> - Fold __io_uring_enter() into io_uring_enter()
> 
> Hi Jens,
> 
> Which goal(s) do you want to realize with this new API? Is the goal
> perhaps to reduce the overhead of submitting I/O and receiving I/O
> completions?  If so, where can I find a comparison of the performance
> of this API with libaio and synchronous I/O?

Yes, it's to reduce the overhead of the interface, since aio isn't very
good. It's also to provide something that's more feature rich. It's
embarassing that we STILL don't have async buffered IO support, for
instance. With this infrastructure, we do.

In terms of benchmarks against aio, I included some in the v5 posting:

https://lore.kernel.org/linux-block/20190116175003.17880-1-axboe@kernel.dk/

I haven't done any against sync IO, but since you can use this interface
in a sync manner (just have min_complete == to_submit), there won't be
much of a difference, if any. If you use some of the more advanced
features, like pre-mapped buffers, it'll be faster than the current sync
IO.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
