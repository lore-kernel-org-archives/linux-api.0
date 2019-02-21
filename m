From: Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCHSET v15] io_uring IO interface
Date: Thu, 21 Feb 2019 13:10:22 +0100
Message-ID: <20190221121022.7867-1-marek@cloudflare.com>
References: <20190211190049.7888-1-axboe@kernel.dk>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190211190049.7888-1-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: axboe@kernel.dk
Cc: avi@scylladb.com, hch@lst.de, jannh@google.com, jmoyer@redhat.com, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

> From: Jens Axboe <axboe@kernel.dk>
> Subject: [PATCHSET v15] io_uring IO interface
> Message-ID: <20190211190049.7888-1-axboe@kernel.dk> (raw)
>
> Some final tweaks, mostly cosmetic, but also two important fixes:
> 
> 1) Ensure that we account the skb appropriately against the socket.
>    Some network config options apparently return is an skb with
>    ->truesize != 0 when allocated with a size of 0, ensure we add
>    those as references against sock->sk_wmem_alloc. Reported by
>    Matt Mullins.

Jens,

I tried using io_uring with network sockets. It seem to be doing the
right thing. One bit is missing though: "flags" as in recv(2).

In perfect world I would like to specify at least:
 - MSG_DONTWAIT
 - MSG_WAITALL
 - MSG_NOSIGNAL

Right now, unless I'm missing something, io_uring_sqe doesn't have a
place where we could store these. "flags" is needed for any
non-trivial network I/O.

A separate discussion is about io_uring supporting more complex
network stuff in future like 'struct msghdr', MSG_ERRQUEUE or CMSG.

Cheers,
   Marek

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
