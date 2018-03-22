From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 06/28] aio: implement IOCB_CMD_POLL
Date: Thu, 22 Mar 2018 18:16:53 +0000
Message-ID: <20180322181653.GJ30522@ZenIV.linux.org.uk>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-7-hch@lst.de>
 <20180322165255.GI30522@ZenIV.linux.org.uk>
 <20180322172410.GC5542@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180322172410.GC5542@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 22, 2018 at 06:24:10PM +0100, Christoph Hellwig wrote:

> -static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
> +static bool aio_complete(struct aio_kiocb *iocb, long res, long res2,
> +		unsigned complete_flags)

Looks like all callers are following that with "if returned true,
fput(something)".  Does it really make any sense to keep that struct
file * in different fields?

Wait a sec...  What ordering do we want for
	* call(s) of ->ki_complete
	* call (if any) of ->ki_cancel
	* dropping reference to struct file
and what are the expected call chains for all of those?

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
