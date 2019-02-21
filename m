From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v15] io_uring IO interface
Date: Thu, 21 Feb 2019 10:48:22 -0700
Message-ID: <e9b96cd8-71a1-d5bc-e3cf-8248f9654deb@kernel.dk>
References: <20190211190049.7888-1-axboe@kernel.dk>
 <20190221121022.7867-1-marek@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190221121022.7867-1-marek@cloudflare.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Marek Majkowski <marek@cloudflare.com>
Cc: avi@scylladb.com, hch@lst.de, jannh@google.com, jmoyer@redhat.com, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/21/19 5:10 AM, Marek Majkowski wrote:
>> From: Jens Axboe <axboe@kernel.dk>
>> Subject: [PATCHSET v15] io_uring IO interface
>> Message-ID: <20190211190049.7888-1-axboe@kernel.dk> (raw)
>>
>> Some final tweaks, mostly cosmetic, but also two important fixes:
>>
>> 1) Ensure that we account the skb appropriately against the socket.
>>    Some network config options apparently return is an skb with
>>    ->truesize != 0 when allocated with a size of 0, ensure we add
>>    those as references against sock->sk_wmem_alloc. Reported by
>>    Matt Mullins.
> 
> Jens,
> 
> I tried using io_uring with network sockets. It seem to be doing the
> right thing. One bit is missing though: "flags" as in recv(2).
> 
> In perfect world I would like to specify at least:
>  - MSG_DONTWAIT
>  - MSG_WAITALL
>  - MSG_NOSIGNAL
> 
> Right now, unless I'm missing something, io_uring_sqe doesn't have a
> place where we could store these. "flags" is needed for any
> non-trivial network I/O.

We have flags for sqes, depending on the type. You can add to the
union that already holds rw_flags/fsync_flags/poll_events? There's
also a (smaller) flags field that applies for all types, which
currently only holds the fixed file flag.

If you're talking on a per-syscall type of flag, io_uring_enter(2)
does take a flags member.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
