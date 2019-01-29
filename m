From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/18] io_uring: add io_kiocb ref count
Date: Tue, 29 Jan 2019 18:26:54 +0100
Message-ID: <20190129172654.GC15347@lst.de>
References: <20190128213538.13486-1-axboe@kernel.dk> <20190128213538.13486-16-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190128213538.13486-16-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 02:35:35PM -0700, Jens Axboe wrote:
> We'll use this for the POLL implementation. Regular requests will
> NOT be using references, so initialize it to 0. Any real use of
> the io_kiocb ref will initialize it to at least 2.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
