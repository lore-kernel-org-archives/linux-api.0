From: Dave Chinner <david@fromorbit.com>
Subject: Re: aio fsync revisited
Date: Fri, 19 Jan 2018 09:46:14 +1100
Message-ID: <20180118224614.GI16421@dastard>
References: <20180117194747.1631-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180117194747.1631-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 08:47:46PM +0100, Christoph Hellwig wrote:
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
> As the patch is on top of of the aio.c changes in the aio poll
> series I've also provided a git tree:
> 
>     git://git.infradead.org/users/hch/vfs.git aio-fsync
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-fsync

After I get back from LCA (all next week) I'll update the fsmark
aio patches I have and retest this. The code looks pretty similar to
the last "generic aio fsync" patch I wrote, so I'm guessing that the
results will be pretty similar, too.

It would be good to finally get this implemented in the kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
