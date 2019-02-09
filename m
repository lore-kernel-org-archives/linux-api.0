From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/19] net: split out functions related to registering
 inflight socket files
Date: Sat, 9 Feb 2019 10:49:05 +0100
Message-ID: <a1332a6b-8fff-3a28-e5be-82a434edbe18@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-14-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-14-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> We need this functionality for the io_uring file registration, but
> we cannot rely on it since CONFIG_UNIX can be modular. Move the helpers
> to a separate file, that's always builtin to the kernel if CONFIG_UNIX is
> m/y.
> 
> No functional changes in this patch, just moving code around.
> 
> Cc: netdev@vger.kernel.org
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/net/af_unix.h |   1 +
>   net/unix/Kconfig      |   5 ++
>   net/unix/Makefile     |   2 +
>   net/unix/af_unix.c    |  63 +-----------------
>   net/unix/garbage.c    |  71 +-------------------
>   net/unix/scm.c        | 146 ++++++++++++++++++++++++++++++++++++++++++
>   net/unix/scm.h        |  10 +++
>   7 files changed, 168 insertions(+), 130 deletions(-)
>   create mode 100644 net/unix/scm.c
>   create mode 100644 net/unix/scm.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
