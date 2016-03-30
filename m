From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 09/10] add RWF_DSYNC aand RWF_SYNC
Date: Wed, 30 Mar 2016 08:54:20 +0200
Message-ID: <20160330065420.GA8405@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de> <1459273054-13478-10-git-send-email-hch@lst.de> <53D41BC3-65A3-48BB-B2CC-540EBF86A2EC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53D41BC3-65A3-48BB-B2CC-540EBF86A2EC-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 29, 2016 at 01:34:50PM -0600, Andreas Dilger wrote:
> Is it right that both of these flags are defined as "2"?  From the code
> they look like they should be different values.

Yes, they should.  I did the same trick as we do for __O_SYNC earlier
but then changed it last minute.  I'll fix it up for the next version.
