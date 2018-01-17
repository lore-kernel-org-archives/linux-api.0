From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/32] fs: introduce new ->get_poll_head and
        ->poll_mask methods
Date: Wed, 17 Jan 2018 17:05:43 +0100
Message-ID: <20180117160543.GA5945@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-4-hch@lst.de> <20180110210416.GH13338@ZenIV.linux.org.uk> <20180111113600.GA4120@lst.de> <20180111174750.GL13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111174750.GL13338@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 11, 2018 at 05:47:50PM +0000, Al Viro wrote:
> What I mean is that it would be nice to have do_select() and friends aware of that.
> You are hiding the whole thing behind vfs_poll(); sure, we can't really exploit
> that while we have the mix of converted and unconverted instances, but it would
> be a nice payoff.

I have tried to move it out, but I don't think it makes sense yet,
given that we rely on passing the poll_table_struct everywhere.

Btw, another issue: the procs and debugfs forwarders are in fact
already broken right now for epoll and in-kernel callers.  ->poll
returning does not mean it is safe to release the module - it
may still have an active wait_queue_entry on the waitqueue.

For now I think I'll drop the support for the proc/debugfs forwarders,
because they will need a real fix independent of this series.
