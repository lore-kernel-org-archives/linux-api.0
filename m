From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: eliminate the pos variable in
 xfs_file_dio_aio_write
Date: Fri, 8 Apr 2016 08:50:45 +1000
Message-ID: <20160407225045.GA21804@dastard>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
 <1460044324-5298-4-git-send-email-hch@lst.de>
 <20160407223111.GF761@dastard>
 <20160407224312.GA8443@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160407224312.GA8443@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 08, 2016 at 12:43:12AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 08, 2016 at 08:31:11AM +1000, Dave Chinner wrote:
> > On Thu, Apr 07, 2016 at 08:51:57AM -0700, Christoph Hellwig wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_file.c | 17 ++++++++---------
> > >  1 file changed, 8 insertions(+), 9 deletions(-)
> > ....
> > 
> > Looks fine. Do you want me to pull this directly into the XFS tree?
> 
> The following patches depend on it, so everything should really go
> through Al's tree.

No worries, just wanted to make sure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
