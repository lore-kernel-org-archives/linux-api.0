From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Thu, 31 Jan 2019 09:37:42 -0700
Message-ID: <58f458d1-f2fd-5d7c-974a-06b35701d92d@kernel.dk>
References: <20190123153536.7081-1-axboe@kernel.dk>
 <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de>
 <CALCETrV30uN2qOUEf+kNGWdphBtps7K3rEk8_8+VAwdtPomRkQ@mail.gmail.com>
 <dab3fa32-3887-3264-9fe1-bc3b7abc58b3@kernel.dk>
 <CALCETrVwHcWcJB4r=14=uB2NHGasW+rRRWVoun6-UY_t3+AU2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CALCETrVwHcWcJB4r=14=uB2NHGasW+rRRWVoun6-UY_t3+AU2A@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-aio@kvack.org, linux-block@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 1/30/19 10:11 PM, Andy Lutomirski wrote:
>>>> On Jan 28, 2019, at 5:20 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 1/28/19 5:47 PM, Andy Lutomirski wrote:
>>>> On Mon, Jan 28, 2019 at 6:57 AM Christoph Hellwig <hch@lst.de> wrote:
>>>>
>>>> [please make sure linux-api and linux-man are CCed on new syscalls
>>>> so that we get API experts to review them]
>>>
>>>>> +static int io_import_iovec(struct io_ring_ctx *ctx, int rw,
>>>>> +                        const struct io_uring_sqe *sqe,
>>>>> +                        struct iovec **iovec, struct iov_iter *iter)
>>>>> +{
>>>>> +     void __user *buf = u64_to_user_ptr(sqe->addr);
>>>>> +
>>>>> +#ifdef CONFIG_COMPAT
>>>>> +     if (ctx->compat)
>>>>> +             return compat_import_iovec(rw, buf, sqe->len, UIO_FASTIOV,
>>>>> +                                             iovec, iter);
>>>>> +#endif
>>>>
>>>> I think we can just check in_compat_syscall() here, which means we
>>>> can kill the ->compat member, and the separate compat version of the
>>>> setup syscall.
>>>
>>> Since this whole API is new, I don't suppose you could introduce a
>>> struct iovec64 or similar and just make the ABI be identical for
>>> 64-bit and 32-bit code?
>>
>> Sure, that would be straight forward. Is there a strong reason to do
>> so outside of "that would be nice"? It's not like it's a huge amount
>> of code.
> 
> Here are some minor-ish benefits:
> 
>  - It avoids having a code path that is only used with 32 bit code on
> 64 bit kernels and is therefore rarely tested.  (In this particular
> case, the code path doesn't diverge much, but for most compat
> syscalls, it's almost an entirely separate implementation of the main
> syscall code.)
> 
>  - It makes life easier for tools like strace.
> 
>  - It minimizes the chance of making a giant mess on x32, which isn't
> really native or compat.

Not really anything major here, at least not to the extent that
suffering the pain of having a different iovec for this is warranted.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
