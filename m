From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/32] aio: implement IOCB_CMD_POLL
Date: Sun, 20 May 2018 19:32:28 +0200
Message-ID: <20180520173228.GA864@lst.de>
References: <20180515194833.6906-1-hch@lst.de> <20180515194833.6906-11-hch@lst.de> <20180520053219.GZ30522@ZenIV.linux.org.uk> <20180520073332.GA30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180520073332.GA30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, May 20, 2018 at 08:33:39AM +0100, Al Viro wrote:
> > ... get buggered on attempt to dereference a pointer fetched from freed and
> > reused object.
> 
> FWIW, how painful would it be to pull the following trick:
> 	* insert into wait queue under ->ctx_lock
> 	* have wakeup do schedule_work() with aio_complete() done from that
> 	* have ->ki_cancel() grab queue lock, remove from queue and use
> the same schedule_work()
> 
> That way you'd get ->ki_cancel() with the same semantics as originally for
> everything - "ask politely to finish ASAP", and called in the same locking
> environment for everyone - under ->ctx_lock, that is.  queue lock nests
> inside ->ctx_lock; no magical flags, etc.
> 
> The cost is schedule_work() for each async poll-related completion as you
> have for fsync.  I don't know whether that's too costly or not; it certainly
> simplifies the things, but whether it's OK performance-wise...

I think it is doable:

	http://git.infradead.org/users/hch/vfs.git/commitdiff/c441130e405465268ea10c9ddd5639c155f779e8

downside is that sizeof(struct aio_kiocb) grows a bit.

For the completion performance we can use a spin_trylock to still avoid
the context switch for the common case:

	http://git.infradead.org/users/hch/vfs.git/commitdiff/6cc1827afbea87c52fe425cf533bfcf5f3308163
