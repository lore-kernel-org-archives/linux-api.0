From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v15] io_uring IO interface
Date: Fri, 22 Feb 2019 15:32:49 -0700
Message-ID: <a75ebf28-66c0-4eaf-9c76-03843ce622b6@kernel.dk>
References: <20190211190049.7888-1-axboe@kernel.dk>
 <20190221121022.7867-1-marek@cloudflare.com>
 <e9b96cd8-71a1-d5bc-e3cf-8248f9654deb@kernel.dk>
 <CAJPywTLGBRviKYSf+AQg-0eOZ3pnyTFEhr28no9Zrh8ftsSxmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAJPywTLGBRviKYSf+AQg-0eOZ3pnyTFEhr28no9Zrh8ftsSxmQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Marek Majkowski <marek@cloudflare.com>
Cc: Avi Kivity <avi@scylladb.com>, hch@lst.de, Jann Horn <jannh@google.com>, jmoyer@redhat.com, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/22/19 8:01 AM, Marek Majkowski wrote:
> On Thu, Feb 21, 2019 at 6:48 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/21/19 5:10 AM, Marek Majkowski wrote:
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>> Subject: [PATCHSET v15] io_uring IO interface
>>>> Message-ID: <20190211190049.7888-1-axboe@kernel.dk> (raw)
>>>>
>>>> Some final tweaks, mostly cosmetic, but also two important fixes:
>>>>
>>>> 1) Ensure that we account the skb appropriately against the socket.
>>>>    Some network config options apparently return is an skb with
>>>>    ->truesize != 0 when allocated with a size of 0, ensure we add
>>>>    those as references against sock->sk_wmem_alloc. Reported by
>>>>    Matt Mullins.
>>>
>>> Jens,
>>>
>>> I tried using io_uring with network sockets. It seem to be doing the
>>> right thing. One bit is missing though: "flags" as in recv(2).
>>>
>>> In perfect world I would like to specify at least:
>>>  - MSG_DONTWAIT
>>>  - MSG_WAITALL
>>>  - MSG_NOSIGNAL
>>>
>>> Right now, unless I'm missing something, io_uring_sqe doesn't have a
>>> place where we could store these. "flags" is needed for any
>>> non-trivial network I/O.
>>
>> We have flags for sqes, depending on the type. You can add to the
>> union that already holds rw_flags/fsync_flags/poll_events? There's
>> also a (smaller) flags field that applies for all types, which
>> currently only holds the fixed file flag.
> 
> The "sqe->flags" right now is used by the IOSQE_FIXED_FILE which has
> the same value as MSG_OOB.
> 
> Sticking recv/send flags into the "rw_flags" union perhaps could work,
> barring the discussion about naming. The obvious names don't make
> sense. recv_flags, send_flags or socket_flags don't sound right.
> 
> If we tried to add networking stuff to io_uring (for batchinig and async), then:
>  - send()/recv() could work, only needs the "flags" field
>  - sendmsg()/recvmsg() likewise
>  - sendto()/recvfrom() require two more pointers: (struct sockaddr
> *dest_addr, socklen_t addrlen)
>  - sendmmsg() / recvmmsg() are perhaps irrelevant
> 
> Non-blocking stuff like socket(), setsockopt(), bind() perhaps don't
> need to be considered, although could benefit from batching.

If we just do separate opcodes for them, then there's 32 bits of flag
space for each one. That should be more than adequate.

> Not sure what to think about connect() and accept(). In the
> prehistoric days there seem to have been an attempt to add socket
> things to libaio struct iocb. See:
> 
> https://code.woboq.org/linux/include/libaio.h.html#iocb::(anonymous)::saddr
> 
> struct iocb {
>     ...
>     union {
>         ...
>         struct io_iocb_sockaddr    saddr;
>     } u;
> };
> 
> Are there chances of reserving space for two pointers in io_uring_sqe,
> which could be used for sendto/recvfrom/accept if we decided to add
> more network support?

There is already space for that. We have 3 x 64 bits at the end of the
sqe, 16 of those are used for the fixed buffers which networking
probably wants to support as well. But that still leaves 112 bits of
space for things opcode specific data.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
