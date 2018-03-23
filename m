From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/28] aio: implement IOCB_CMD_POLL
Date: Fri, 23 Mar 2018 19:05:20 +0100
Message-ID: <20180323180520.GA7837@lst.de>
References: <20180321074032.14211-1-hch@lst.de> <20180321074032.14211-7-hch@lst.de> <20180322165255.GI30522@ZenIV.linux.org.uk> <20180322172410.GC5542@lst.de> <20180322181653.GJ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180322181653.GJ30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 22, 2018 at 06:16:53PM +0000, Al Viro wrote:
> On Thu, Mar 22, 2018 at 06:24:10PM +0100, Christoph Hellwig wrote:
> 
> > -static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
> > +static bool aio_complete(struct aio_kiocb *iocb, long res, long res2,
> > +		unsigned complete_flags)
> 
> Looks like all callers are following that with "if returned true,
> fput(something)".  Does it really make any sense to keep that struct
> file * in different fields?

struct kiocb is used not just for aio, but for our normal read/write_iter
APIs, and it is not suitable for poll or fsync.  So I can't really find
a good way to keep it common except for duplicating it in struct kiocb
and strut aio_iocb.  But maybe we could pass a struct file argument
to aio_complete().

> Wait a sec...  What ordering do we want for
> 	* call(s) of ->ki_complete
> 	* call (if any) of ->ki_cancel
> 	* dropping reference to struct file
> and what are the expected call chains for all of those?

fput must be done exactly once from inside ->ki_complete OR ->ki_cancel
in case it did manage to do the actual completion.  Reference to struct
file isn't needed in aio_complete, but if aio_complete decided who
won the race we'll have to put after it (or inside it if we want to make
it common)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
