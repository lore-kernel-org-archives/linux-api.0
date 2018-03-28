From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/6] aio: remove an outdated comment in aio_complete
Date: Wed, 28 Mar 2018 10:05:40 -0700
Message-ID: <20180328170540.GC639@bombadil.infradead.org>
References: <20180328072639.16885-1-hch@lst.de>
 <20180328072639.16885-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328072639.16885-3-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 09:26:35AM +0200, Christoph Hellwig wrote:
> These days we don't treat sync iocbs special in the aio completion code as
> they never use it.  Remove the old comment and BUG_ON given that the
> current definition of is_sync_kiocb makes it impossible to hit.
> iocb to the top of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like you have a stray line of text in the changelog here ...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
