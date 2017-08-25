From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 00/13] [PATCH V1 for-next 00/13] IB/core: SG
 IOCTL based RDMA ABI
Date: Fri, 25 Aug 2017 09:08:12 -0600
Message-ID: <20170825150812.GA1027@obsidianresearch.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
 <1501773437.117042.10.camel@redhat.com>
 <1503612368.78641.69.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503612368.78641.69.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 24, 2017 at 06:06:08PM -0400, Doug Ledford wrote:
> On Thu, 2017-08-03 at 11:17 -0400, Doug Ledford wrote:
> > On Thu, 2017-08-03 at 16:06 +0300, Matan Barak wrote:
> > > Hi Doug,
> > > 
> > > This patch series adds ioctl() interface to the existing write()
> > > interface and
> > > provide an easy route to backport this change to legacy supported
> > > systems.
> > 
> > [ snip ]
> > 
> > Hi Matan,
> > 
> > Thanks for getting this to the linux-api mailing list, I was about to
> > suggest the same.
> 
> This has now been on the linux-api mailing list for 21 days with no
> objections.  I very well may take this into my for-next branch, so
> should anyone want to look at this before hand, now is the time. 
> Thanks.

I think you should wait until after plumbers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
