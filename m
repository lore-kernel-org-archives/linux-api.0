From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 14/24] fpga: dfl: fme: add partial reconfiguration sub
 feature support
Date: Tue, 6 Mar 2018 12:29:35 -0600
Message-ID: <CANk1AXTPhxZq5PaJgVPeADjBLHYN7-A=drZ=3qVqROwXK4-O+Q@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-15-git-send-email-hao.wu@intel.com> <CANk1AXRT6Rd6kjxT9Q_=3T0zNfzLGmdxOzY=pyX0VKMYReh-0Q@mail.gmail.com>
 <20180306020838.GB32057@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306020838.GB32057@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

  On Mon, Mar 5, 2018 at 8:08 PM, Wu Hao <hao.wu@intel.com> wrote:
> On Mon, Mar 05, 2018 at 04:46:02PM -0600, Alan Tull wrote:
>> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
>>
>> Hi Hao,
>
> Hi Alan,
>
> Thanks for the comments.
>
>>
>> We are going to want to be able use different FPGA managers with this
>> framework.  The different manager may be part of a different FME in
>> fabric or it may be a hardware FPGA manager.  Fortunately, at this
>> point now the changes, noted below, to get there are pretty small.
>
> Yes, understand these could be some cases that FME having different PR
> hardware.
>

Or supporting reduced FME plus hardware-based FPGA manager.

Just to re-emphasize, the basic intent of the FPGA manager subsystem
in the first place is to have FPGA managers separate from higher level
frameworks so that the higher level frameworks will be able to able to
use different FPGAs.

>> > +/**
>> > + * fpga_fme_create_mgr - create fpga mgr platform device as child device
>> > + *
>> > + * @pdata: fme platform_device's pdata
>> > + *
>> > + * Return: mgr platform device if successful, and error code otherwise.
>> > + */
>> > +static struct platform_device *
>> > +fpga_fme_create_mgr(struct feature_platform_data *pdata)
>> > +{
>> > +       struct platform_device *mgr, *fme = pdata->dev;
>> > +       struct feature *feature;
>> > +       struct resource res;
>> > +       struct resource *pres;
>> > +       int ret = -ENOMEM;
>> > +
>> > +       feature = get_feature_by_id(&pdata->dev->dev, FME_FEATURE_ID_PR_MGMT);
>> > +       if (!feature)
>> > +               return ERR_PTR(-ENODEV);
>> > +
>> > +       /*
>> > +        * Each FME has only one fpga-mgr, so allocate platform device using
>> > +        * the same FME platform device id.
>> > +        */
>> > +       mgr = platform_device_alloc(FPGA_DFL_FME_MGR, fme->id);
>>
>> At this point, the framework is assuming all FME's include the same
>> FPGA manager device which would use the driver in dfl-fme-mgr.c.
>>
>> I'm thinking of two cases where the manager isn't the same as a
>> dfl-fme-mgr.c manager are a bit different:
>>
>> (1) a FME-based FPGA manager, but different implementation, different
>> registers.  The constraint is that the port implementation has to be
>> similar enough to use the rest of the base FME code.   I am wondering
>> if the FPGA manager can be added to the DFL.  At this point, the DFL
>> would drive which FPGA manager is alloc'd.   That way the user gets to
>> use all this code in dfl-fme-pr.c but with their FPGA manager.
>
> Actually I'm not sure how this will be implemented in the hardware in the
> future, but from my understanding, there may be several methods to add this
> support (a different PR hardware) to FME.
>
> 1) introduce a new PR sub feature to FME.
>    driver knows it by different feature id, and create different fpga
>    manager platform device, but may not be able to reuse dfl-fme-pr.c.

What would prevent reusing dfl-fme-pr.c?  It looks like this is 98% of
the way there and only needs a way of knowing which FPGA manager
driver to alloc here. I am hoping that a new PR sub feature could be
added and that dfl-fme-pr.c can be reused.

>
> 2) add a different PR hardware support to current PR sub feature.
>    It requires hardware to add registers to indicate this is a different
>    PR hardware than dfl-fme-mgr.c, and its register region information
>    (e.g location and size). Then this dfl-fme-pr.c driver could read
>    these information from hardware and create a different fpga manager
>    platform device with correct resources.

So this dfl-fme-pr.c would have to know where some ID registers are
and the enumeration gets messier.  Some of the enumeration would be
DFL and some would be from information that is not in the DFL headers.
The DFL should contain the knowledge of which mgr to use.

>
> I think current driver framework could support both cases above for sure.
>
>>
>> (2) a FPGA manager that can be added by device tree in the case of a
>> platform that is using device tree.  I think this will be pretty
>> simple and can be done later when someone is actually bringing this
>> framework up on a FPGA running under device tree.  I'm thinking that
>> the base DFL device that reads the dfl data from hardware can have a
>> DT property that points to the FPGA manager.  That manager can be
>> saved somewhere handy like the pdata and passed down to this code,
>> which realizes it can use that existing device and doesn't need to
>> alloc a platform device.  But again, that's probably best done later.
>
> Sure, we can discuss further when we really need it. Actually per my
> understanding, if hardware describes itself clearly, we may not have to
> use DT for fpga manager, as driver could create it automatically based
> on information read from hardware. :)

DT exists for busses that don't have that kind of discovery.  For a
concrete example, consider how the Arria10 driver (socfpga-a10.c)
probe function is getting its two mmio spaces and clock.

>
>>
>> > +       if (!mgr)
>> > +               return ERR_PTR(ret);
>> > +
>> > +       mgr->dev.parent = &fme->dev;
>> > +
>> > +       pres = platform_get_resource(fme, IORESOURCE_MEM,
>> > +                                    feature->resource_index);
>> > +       if (!pres) {
>> > +               ret = -ENODEV;
>> > +               goto create_mgr_err;
>> > +       }
>> > +
>> > +       memset(&res, 0, sizeof(struct resource));
>> > +
>> > +       res.start = pres->start;
>> > +       res.end = pres->end;
>> > +       res.name = pres->name;
>> > +       res.flags = IORESOURCE_MEM;
>> > +
>> > +       ret = platform_device_add_resources(mgr, &res, 1);
>> > +       if (ret)
>> > +               goto create_mgr_err;
>> > +
>> > +       ret = platform_device_add(mgr);
>> > +       if (ret)
>> > +               goto create_mgr_err;
>> > +
>> > +       return mgr;
>> > +
>> > +create_mgr_err:
>> > +       platform_device_put(mgr);
>> > +       return ERR_PTR(ret);
>> > +}

>> > diff --git a/drivers/fpga/dfl-fme-pr.h b/drivers/fpga/dfl-fme-pr.h
>> > new file mode 100644
>> > index 0000000..11bd001
>> > --- /dev/null
>> > +++ b/drivers/fpga/dfl-fme-pr.h
>> > @@ -0,0 +1,113 @@
>> > +/* SPDX-License-Identifier: GPL-2.0 */
>> > +/*
>> > + * Header file for FPGA Management Engine (FME) Partial Reconfiguration Driver
>> > + *
>> > + * Copyright (C) 2017 Intel Corporation, Inc.
>> > + *
>> > + * Authors:
>> > + *   Kang Luwei <luwei.kang@intel.com>
>> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
>> > + *   Wu Hao <hao.wu@intel.com>
>> > + *   Joseph Grecco <joe.grecco@intel.com>
>> > + *   Enno Luebbers <enno.luebbers@intel.com>
>> > + *   Tim Whisonant <tim.whisonant@intel.com>
>> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
>> > + *   Henry Mitchel <henry.mitchel@intel.com>
>> > + */
>> > +
>> > +#ifndef __DFL_FME_PR_H
>> > +#define __DFL_FME_PR_H
>> > +
>> > +#include <linux/platform_device.h>
>> > +
>> > +/**
>> > + * struct fme_region - FME fpga region data structure
>> > + *
>> > + * @region: platform device of the FPGA region.
>> > + * @node: used to link fme_region to a list.
>> > + * @port_id: indicate which port this region connected to.
>> > + */
>> > +struct fme_region {
>> > +       struct platform_device *region;
>> > +       struct list_head node;
>> > +       int port_id;
>> > +};
>> > +
>> > +/**
>> > + * struct fme_region_pdata - platform data for FME region platform device.
>> > + *
>> > + * @mgr: platform device of the FPGA manager.
>> > + * @br: platform device of the FPGA bridge.
>> > + * @region_id: region id (same as port_id).
>> > + */
>> > +struct fme_region_pdata {
>> > +       struct platform_device *mgr;
>> > +       struct platform_device *br;
>> > +       int region_id;
>> > +};
>> > +
>> > +/**
>> > + * struct fme_bridge - FME fpga bridge data structure
>> > + *
>> > + * @br: platform device of the FPGA bridge.
>> > + * @node: used to link fme_bridge to a list.
>> > + */
>> > +struct fme_bridge {
>> > +       struct platform_device *br;
>> > +       struct list_head node;
>> > +};
>> > +
>> > +/**
>> > + * struct fme_bridge_pdata - platform data for FME bridge platform device.
>> > + *
>> > + * @port: platform device of the port feature dev.
>> > + */
>> > +struct fme_br_pdata {
>> > +       struct platform_device *port;
>> > +};
>> > +
>> > +#define FPGA_DFL_FME_MGR       "dfl-fme-mgr"
>> > +#define FPGA_DFL_FME_BRIDGE    "dfl-fme-bridge"
>> > +#define FPGA_DFL_FME_REGION    "dfl-fme-region"
>> > +
>>
>> Everything in dfl-fme-pr.h up to this point is good and general and
>> should remain in dfl-fme-pr.h.  The register #defines for this FME's
>> FPGA manager device below should be associated with the FPGA manager
>> driver.  Sorry if the way I stated that in the v3 review wasn't clear.
>
> Actually I put the PR sub feature register set definitions in this header
> file (dfl-fme-pr.h), because it's possible the driver (dfl-fme-pr.c) of
> this PR sub feature access some of the registers in the future. e.g read
> some PR sub feature registers to create different fpga manager platform
> devices as I mentioned above.

That sounds like a workaround.  Since you're adding a new method of
enumeration, you should use that new method of enumeration to choose
which FPGA manager is being used.  Otherwise we are ending up with
multi-level enumeration, i.e. look at the DFL and then look at a
specific register location in the device.

>
> I have to say this is only future consideration, and in this dfl-fme-pr.c
> driver there is no code to access below registers currently. I can move all
> of them to dfl-fme-mgr.h or dfl-fme-mgr.c in the next version if this is
> preferred. : )

That sounds good.  That makes the mgr driver its own separate thing
which is what is supposed to happen in this framework.

>
>>
>> > +/* FME Partial Reconfiguration Sub Feature Register Set */
>> > +#define FME_PR_DFH             0x0
>> > +#define FME_PR_CTRL            0x8
>> > +#define FME_PR_STS             0x10
>> > +#define FME_PR_DATA            0x18
>> > +#define FME_PR_ERR             0x20
>> > +#define FME_PR_INTFC_ID_H      0xA8
>> > +#define FME_PR_INTFC_ID_L      0xB0
>> > +
>> > +/* FME PR Control Register Bitfield */
>> > +#define FME_PR_CTRL_PR_RST     BIT(0)  /* Reset PR engine */
>> > +#define FME_PR_CTRL_PR_RSTACK  BIT(4)  /* Ack for PR engine reset */
>> > +#define FME_PR_CTRL_PR_RGN_ID  GENMASK_ULL(9, 7)       /* PR Region ID */
>> > +#define FME_PR_CTRL_PR_START   BIT(12) /* Start to request for PR service */
>> > +#define FME_PR_CTRL_PR_COMPLETE        BIT(13) /* PR data push complete notification */
>> > +
>> > +/* FME PR Status Register Bitfield */
>> > +/* Number of available entries in HW queue inside the PR engine. */
>> > +#define FME_PR_STS_PR_CREDIT   GENMASK_ULL(8, 0)
>> > +#define FME_PR_STS_PR_STS      BIT(16) /* PR operation status */
>> > +#define FME_PR_STS_PR_STS_IDLE 0
>> > +#define FME_PR_STS_PR_CTRLR_STS        GENMASK_ULL(22, 20)     /* Controller status */
>> > +#define FME_PR_STS_PR_HOST_STS GENMASK_ULL(27, 24)     /* PR host status */
>> > +
>> > +/* FME PR Data Register Bitfield */
>> > +/* PR data from the raw-binary file. */
>> > +#define FME_PR_DATA_PR_DATA_RAW        GENMASK_ULL(32, 0)
>> > +
>> > +/* FME PR Error Register */
>> > +/* PR Operation errors detected. */
>> > +#define FME_PR_ERR_OPERATION_ERR       BIT(0)
>> > +/* CRC error detected. */
>> > +#define FME_PR_ERR_CRC_ERR             BIT(1)
>> > +/* Incompatible PR bitstream detected. */
>> > +#define FME_PR_ERR_INCOMPATIBLE_BS     BIT(2)
>> > +/* PR data push protocol violated. */
>> > +#define FME_PR_ERR_PROTOCOL_ERR                BIT(3)
>> > +/* PR data fifo overflow error detected */
>> > +#define FME_PR_ERR_FIFO_OVERFLOW       BIT(4)
>>
>> This stuff is specific to this FPGA manager device, so it should
>> either be in the dfl-fme-mgr.c or in a dfl-fme-mgr.h
>
> same as above, I can fix this in the next version.
>
> Thanks
> Hao

Thanks,
Alan
