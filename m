From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 3/3] fs: Add aio iopriority support for block_dev
Date: Fri, 18 May 2018 09:06:36 -0700
Message-ID: <20180518160636.GH22791@infradead.org>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
 <20180517203803.2664-4-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180517203803.2664-4-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org, mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Looks fine, although I'd split it into a aio and block_dev patch.

Also please wire this up for the fs/iomap.c direct I/O code, it should
be essentially the same sniplet as in the block_dev.c code.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
