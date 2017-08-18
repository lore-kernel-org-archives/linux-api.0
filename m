From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 09/22] fpga: intel: pcie: adds fpga_for_each_port
 callback for fme device
Date: Fri, 18 Aug 2017 15:03:31 +0800
Message-ID: <20170818070331.GE25457@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-10-git-send-email-hao.wu@intel.com>
 <CANk1AXRQfGViXn+vEErmN6N8LtOsX7Arh-VPPbDjKiEyGGvV-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRQfGViXn+vEErmN6N8LtOsX7Arh-VPPbDjKiEyGGvV-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 17, 2017 at 04:31:56PM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> Hi Hao,
> 
> > For FPGA Management Engine (FME), it requires fpga_for_each_port callback
> > for actions on ports, so export this function from PCIe driver by adding
> > the callback to the platform data.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > v2: rebased
> > ---
> >  drivers/fpga/intel-feature-dev.h |  9 +++++++++
> >  drivers/fpga/intel-pcie.c        | 24 ++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
> > index d64a51e..06b3fb6 100644
> > --- a/drivers/fpga/intel-feature-dev.h
> > +++ b/drivers/fpga/intel-feature-dev.h
> > @@ -235,6 +235,9 @@ struct feature_platform_data {
> >         struct platform_device *dev;
> >         unsigned int disable_count;     /* count for port disable */
> >
> > +       struct platform_device *(*fpga_for_each_port)(struct platform_device *,
> > +                       void *, int (*match)(struct platform_device *, void *));
> > +
> >         int num;                        /* number of features */
> >         struct feature features[0];
> >  };
> > @@ -354,4 +357,10 @@ static inline int fpga_port_reset(struct platform_device *pdev)
> >
> >         return pdata->features[index].ioaddr;
> >  }
> > +
> > +static inline struct device *
> > +fpga_feature_dev_to_pcidev(struct platform_device *dev)
> > +{
> > +       return dev->dev.parent->parent;
> > +}
> >  #endif
> > diff --git a/drivers/fpga/intel-pcie.c b/drivers/fpga/intel-pcie.c
> > index 54c0e3a..86ea5c7 100644
> > --- a/drivers/fpga/intel-pcie.c
> > +++ b/drivers/fpga/intel-pcie.c
> > @@ -209,6 +209,27 @@ static int parse_switch_to(struct build_feature_devs_info *binfo, int bar)
> >         return parse_start_from(binfo, bar);
> >  }
> >
> > +static struct platform_device *fpga_for_each_port(struct platform_device *pdev,
> 
> Regarding the name of this function, isn't this more of a 'find'
> function like class_find_device() than a 'for_each' function?
> 
> Also please document that the caller will need to put_device().

Yes, agree, fpga_find_port() should be a better name.
I will fix this and add comments for this function.

Thanks for your comments.
Hao

> 
> Thanks,
> Alan
> 
> > +                    void *data, int (*match)(struct platform_device *, void *))
> > +{
> > +       struct device *pci_dev = fpga_feature_dev_to_pcidev(pdev);
> > +       struct cci_drvdata *drvdata = dev_get_drvdata(pci_dev);
> > +       struct feature_platform_data *pdata;
> > +       struct platform_device *port_dev;
> > +
> > +       mutex_lock(&drvdata->lock);
> > +       list_for_each_entry(pdata, &drvdata->port_dev_list, node) {
> > +               port_dev = pdata->dev;
> > +
> > +               if (match(port_dev, data) && get_device(&port_dev->dev))
> > +                       goto exit;
> > +       }
> > +       port_dev = NULL;
> > +exit:
> > +       mutex_unlock(&drvdata->lock);
> > +       return port_dev;
> > +}
> > +
> >  static struct build_feature_devs_info *
> >  build_info_alloc_and_init(struct pci_dev *pdev)
> >  {
> > @@ -310,6 +331,9 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
> >         if (!pdata)
> >                 return -ENOMEM;
> >
> > +       if (type == FME_ID)
> > +               pdata->fpga_for_each_port = fpga_for_each_port;
> > +
> >         /*
> >          * the count should be initialized to 0 to make sure
> >          *__fpga_port_enable() following __fpga_port_disable()
> > --
> > 1.8.3.1
> >
