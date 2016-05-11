From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/6] vfs: add the RWF_HIPRI flag for preadv2/pwritev2
Date: Wed, 11 May 2016 10:55:20 +0200
Message-ID: <20160511085520.GA20377@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <1457017443-17662-5-git-send-email-hch@lst.de> <874ma8usrr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <874ma8usrr.fsf-wvvUuzkyo1HefUI2i7LXDhCRmIWqnp/j@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, May 09, 2016 at 07:47:04AM +1000, NeilBrown wrote:
> On Fri, Mar 04 2016, Christoph Hellwig wrote:
> 
> > This adds a flag that tells the file system that this is a high priority
> > request for which it's worth to poll the hardware.  The flag is purely
> > advisory and can be ignored if not supported.
> 
> Here you say the flag is "advice".
> 
> >  
> > +/* flags for preadv2/pwritev2: */
> > +#define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
> 
> This text makes it sound like a firm "request" ("if possible").

"request" here is in the sense of an I/O request.  Better wording
highly welcome.

> 
> > provides lower latency, but may use additional ressources
> 
> Is this a "latency vs throughput" trade-off, or something more subtle?
> It would be nice to make the decision process as obvious as possible for
> the developer considering the use of this flag.


If you poll you can't do anything else, so you end up using CPU
cycles to wait which otherwise could do something productive.
