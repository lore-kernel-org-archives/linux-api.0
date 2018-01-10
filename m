From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 30/32] aio: add delayed cancel support
Date: Wed, 10 Jan 2018 17:59:13 -0500
Message-ID: <x49y3l52uda.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-31-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-31-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 10 Jan 2018 16:58:51 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> The upcoming aio poll support would like to be able to complete the
> iocb inline from the cancellation context, but that would cause
> a lock order reversal.  Add support for optionally moving the cancelation
> outside the context lock to avoid this reversal.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Jeff Moyer <jmoyer@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
