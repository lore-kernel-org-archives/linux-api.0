From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 06/21] fpga: dfl: adds fpga_cdev_find_port
Date: Tue, 6 Feb 2018 10:37:02 +0800
Message-ID: <20180206023702.GA4084@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-7-git-send-email-hao.wu@intel.com>
 <CANk1AXSNEX_pUTdWDOsXFsgogU2xbBBZwoLJFssqzF+q=hBssA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSNEX_pUTdWDOsXFsgogU2xbBBZwoLJFssqzF+q=hBssA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 05, 2018 at 04:08:19PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> A couple comments below.
> 
> > For feature devices, e.g FPGA Management Engine (FME),
> 
> The first use I see of this function in this patchset is the FME PR,
> not the FME, or am I misunderstanding?

Hi Alan

Thanks for the review.

Yes, the first use is in the FME PR, the description should be more
clear here. I will improve it.

> 
> > it may
> > require fpga_cdev_find_port function to find dedicate port for
> > further actions, so export this function from feature device
> > driver module.
> 
> I understand the need for this function, but I'm having a hard time
> following this explanation here.   Suggestion: "For feature devices,
> we need a method to find the port dedicated to the device.  Add a
> function fpga_cdev_find_port to do that"

Will fix it, thanks for the suggestion.

> 
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ----
> > v3: s/fpga_for_each_port/fpga_cdev_find_port/
> >     move fpga_cdev_find_port to fpga-dfl module.
> > ---
> >  drivers/fpga/fpga-dfl.c | 27 +++++++++++++++++++++++++++
> >  drivers/fpga/fpga-dfl.h | 16 ++++++++++++++++
> >  2 files changed, 43 insertions(+)
> >
> > diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
> > index 9294c0a..ce03b17 100644
> > --- a/drivers/fpga/fpga-dfl.c
> > +++ b/drivers/fpga/fpga-dfl.c
> > @@ -873,6 +873,33 @@ void fpga_remove_feature_devs(struct fpga_cdev *cdev)
> >  }
> >  EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
> >
> > +/**
> > + * __fpga_cdev_find_port - find a port under given container device
> > + * @cdev: container device
> > + * @data: data passed to match function
> > + * @match: match function used to find specific port from the port device list
> > + *
> > + * Find a port device under container device. This function needs to be
> > + * invoked with lock held.
> > + */
> > +struct platform_device *
> > +__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
> > +                     int (*match)(struct platform_device *, void *))
> > +{
> > +       struct feature_platform_data *pdata;
> > +       struct platform_device *port_dev;
> > +
> > +       list_for_each_entry(pdata, &cdev->port_dev_list, node) {
> > +               port_dev = pdata->dev;
> > +
> > +               if (match(port_dev, data) && get_device(&port_dev->dev))
> > +                       return port_dev;
> 
> The caller will need to put the port_dev->dev.  Please document that
> in the function header.  I mentioned that in v2.

Sorry, I missed it, will add description on this function header.

Thanks again for the review and comments.

Hao
