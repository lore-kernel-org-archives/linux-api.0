From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: io_pgetevents & aio fsync V4
Date: Thu, 10 May 2018 19:05:07 +0100
Message-ID: <20180510180507.GO30522@ZenIV.linux.org.uk>
References: <20180502211448.18276-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180502211448.18276-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 11:14:41PM +0200, Christoph Hellwig wrote:
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
> 
> A git tree is available here:
> 
>     git://git.infradead.org/users/hch/vfs.git aio-fsync.4

I can live with that.  Merged.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
