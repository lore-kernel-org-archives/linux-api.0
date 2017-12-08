From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 09/21] fpga: intel-dfl-pci: add enumeration for
 feature devices
Date: Fri, 8 Dec 2017 17:25:11 +0800
Message-ID: <20171208092511.GA513@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-10-git-send-email-hao.wu@intel.com>
 <CANk1AXQ3+Y6De1i6i0YacUxS+vBzhEfRX_jJ_wQKJOCWmYetxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXQ3+Y6De1i6i0YacUxS+vBzhEfRX_jJ_wQKJOCWmYetxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 07, 2017 at 03:41:41PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > +/* enumerate feature devices under pci device */
> > +static int cci_enumerate_feature_devs(struct pci_dev *pcidev)
> > +{
> > +       struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
> > +       struct fpga_cdev *cdev;
> > +       struct fpga_enum_info *info;
> > +       resource_size_t start, len;
> > +       void __iomem *base;
> > +       int port_num, bar, i, ret = 0;
> > +       u32 offset;
> > +       u64 v;
> > +
> > +       /* allocate enumeration info via pci_dev */
> > +       info = fpga_enum_info_alloc(&pcidev->dev);
> > +       if (!info)
> > +               return -ENOMEM;
> > +
> > +       /* start to find Device Feature List from Bar 0 */
> > +       base = cci_pci_ioremap_bar(pcidev, 0);
> > +       if (!base) {
> > +               ret = -ENOMEM;
> > +               goto enum_info_free_exit;
> > +       }
> > +
> > +       /*
> > +        * PF device has FME and Ports/AFUs, and VF device only has 1 Port/AFU.
> > +        * check them and add related "Device Feature List" info for the next
> > +        * step enumeration.
> > +        */
> > +       if (feature_is_fme(base)) {
> > +               start = pci_resource_start(pcidev, 0);
> > +               len = pci_resource_len(pcidev, 0);
> > +
> > +               fpga_enum_info_add_dfl(info, start, len, base);
> > +
> > +               /*
> > +                * find more Device Feature Lists (e.g Ports) per information
> > +                * indicated by FME module.
> > +                */
> > +               v = readq(base + FME_HDR_CAP);
> > +               port_num = FIELD_GET(FME_CAP_NUM_PORTS, v);
> > +
> > +               WARN_ON(port_num > MAX_FPGA_PORT_NUM);
> > +
> > +               for (i = 0; i < port_num; i++) {
> > +                       v = readq(base + FME_HDR_PORT_OFST(i));
> > +
> > +                       /* skip ports which are not implemented. */
> > +                       if (!(v & FME_PORT_OFST_IMP))
> > +                               continue;
> > +
> > +                       /*
> > +                        * add Port's Device Feature List information for next
> > +                        * step enumeration.
> > +                        */
> > +                       bar = FIELD_GET(FME_PORT_OFST_BAR_ID, v);
> > +                       offset = FIELD_GET(FME_PORT_OFST_DFH_OFST, v);
> > +                       base = cci_pci_ioremap_bar(pcidev, bar);
> > +                       if (!base)
> > +                               continue;
> > +
> > +                       start = pci_resource_start(pcidev, bar) + offset;
> > +                       len = pci_resource_len(pcidev, bar) - offset;
> > +
> > +                       fpga_enum_info_add_dfl(info, start, len, base + offset);
> > +               }
> > +       } else if (feature_is_port(base)) {
> > +               start = pci_resource_start(pcidev, 0);
> > +               len = pci_resource_len(pcidev, 0);
> > +
> > +               fpga_enum_info_add_dfl(info, start, len, base);
> > +       } else {
> > +               ret = -ENODEV;
> > +               goto enum_info_free_exit;
> > +       }
> > +
> > +       /* start enumeration with prepared enumeration information */
> > +       cdev = fpga_enumerate_feature_devs(info);
> 
> Hi Hao,
> 
> I appreciate you separating the DFL enumeration code from this PCIe
> module.  This made the pcie part quite small.  It should work for
> embedded platforms just by adding a platform device whose function is
> to find the DFL structures at some address and then call these same
> fpga_enum_info_add_dfl adn fpga_enumerate_feature_devs functions.

Yes, I think this is the right direction as you suggested. : )

Thanks
Hao

> 
> Alan
