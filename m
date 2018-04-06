From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: io_pgetevents & aio fsync V2
Date: Fri, 6 Apr 2018 04:16:30 +0100
Message-ID: <20180406031630.GU30522@ZenIV.linux.org.uk>
References: <20180328072639.16885-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328072639.16885-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 09:26:33AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this patch adds workqueue based fsync offload.  Version of this
> patch have been floating around for a couple years, but we now
> have a user with seastar used by ScyllaDB (who sponsored this
> work) that really wants this in addition to the aio poll support.
> More details are in the patch itself.
> 
> Because the iocb types have been defined sine day one (and probably
> were supported by RHEL3) libaio already supports these calls as-is.
> 
> This also pulls in the aio cleanups and io_pgetevents support previously
> submitted and review as part of the aio poll series.  The aio poll
> series will be resubmitted on top of this series

BTW, this is only tangentially related, but... does *anything* call
io_submit() for huge amounts of iocb?  Check in do_io_submit() is
insane - "no more than MAX_LONG total of _pointers_".  Compat variant
goes for "no more than a page worth of pointers" and there's
a hard limit in ioctx_alloc() - we can't ever get more than
8M slots in ring buffer...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
