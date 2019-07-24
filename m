From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 09/12] fpga: dfl: afu: add STP (SignalTap) support
Date: Wed, 24 Jul 2019 21:03:47 +0800
Message-ID: <20190724130346.GA8463@hao-dev>
References: <1563857495-26692-1-git-send-email-hao.wu@intel.com>
 <1563857495-26692-10-git-send-email-hao.wu@intel.com>
 <20190724101109.GE29532@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190724101109.GE29532@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 24, 2019 at 12:11:09PM +0200, Greg KH wrote:
> On Tue, Jul 23, 2019 at 12:51:32PM +0800, Wu Hao wrote:
> > STP (SignalTap) is one of the private features under the port for
> > debugging. This patch adds private feature driver support for it
> > to allow userspace applications to mmap related mmio region and
> > provide STP service.
> > 
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Moritz Fischer <mdf@kernel.org>
> > Acked-by: Alan Tull <atull@kernel.org>
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > ---
> >  drivers/fpga/dfl-afu-main.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
> > index 15dd4cb..395f96e 100644
> > --- a/drivers/fpga/dfl-afu-main.c
> > +++ b/drivers/fpga/dfl-afu-main.c
> > @@ -514,6 +514,36 @@ static void port_afu_uinit(struct platform_device *pdev,
> >  	.uinit = port_afu_uinit,
> >  };
> >  
> > +static int port_stp_init(struct platform_device *pdev,
> > +			 struct dfl_feature *feature)
> > +{
> > +	struct resource *res = &pdev->resource[feature->resource_index];
> > +
> > +	dev_dbg(&pdev->dev, "PORT STP Init.\n");
> 
> ftrace is your friend, no need to do a lot of "look I am here!"
> messages.

Hi Greg,

Thanks for the code review!

Sure, let me remove them.

> 
> > +
> > +	return afu_mmio_region_add(dev_get_platdata(&pdev->dev),
> > +				   DFL_PORT_REGION_INDEX_STP,
> > +				   resource_size(res), res->start,
> > +				   DFL_PORT_REGION_MMAP | DFL_PORT_REGION_READ |
> > +				   DFL_PORT_REGION_WRITE);
> > +}
> > +
> > +static void port_stp_uinit(struct platform_device *pdev,
> > +			   struct dfl_feature *feature)
> > +{
> > +	dev_dbg(&pdev->dev, "PORT STP UInit.\n");
> 
> Same here.
> 
> Why have this function at all if it does not do anything?

Let me remove them in the next version. actually uinit callback is
always required in current code, i will add one more patch to change
it, and remove all uinit functions who do nothing, it does save code.

Thanks for the comments.
Hao

> 
> 
> thanks,
> 
> greg k-h
