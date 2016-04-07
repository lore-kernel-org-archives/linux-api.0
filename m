From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/10] xfs: eliminate the pos variable in
	xfs_file_dio_aio_write
Date: Fri, 8 Apr 2016 00:43:12 +0200
Message-ID: <20160407224312.GA8443@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de> <1460044324-5298-4-git-send-email-hch@lst.de> <20160407223111.GF761@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407223111.GF761@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 08, 2016 at 08:31:11AM +1000, Dave Chinner wrote:
> On Thu, Apr 07, 2016 at 08:51:57AM -0700, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > ---
> >  fs/xfs/xfs_file.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> ....
> 
> Looks fine. Do you want me to pull this directly into the XFS tree?

The following patches depend on it, so everything should really go
through Al's tree.
