From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 13/19] net: split out functions related to registering
 inflight socket files
Date: Fri, 08 Feb 2019 11:49:09 -0800 (PST)
Message-ID: <20190208.114909.2274258441884310233.davem@davemloft.net>
References: <20190208173423.27014-1-axboe@kernel.dk>
	<20190208173423.27014-14-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-14-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: axboe@kernel.dk
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk, netdev@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Fri,  8 Feb 2019 10:34:17 -0700

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

No objections on my end, feel free to merge this in with your series.

Acked-by: David S. Miller <davem@davemloft.net>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
