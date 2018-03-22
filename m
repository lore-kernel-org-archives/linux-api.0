From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 04/24] fpga: add device feature list support
Date: Thu, 22 Mar 2018 12:40:06 +0800
Message-ID: <20180322044006.GA8305@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-5-git-send-email-hao.wu@intel.com>
 <CANk1AXT0dBT9qejdbSyi75e956OHA0-y0V7de7H=XkOZzVhRqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXT0dBT9qejdbSyi75e956OHA0-y0V7de7H=XkOZzVhRqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 06:54:58PM -0500, Alan Tull wrote:
> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> > +static int
> > +build_info_create_dev(struct build_feature_devs_info *binfo,
> > +                     enum fpga_id_type type, const char *name,
> > +                     void __iomem *ioaddr)
> > +{
> > +       struct platform_device *fdev;
> > +       int ret;
> > +
> > +       /* we will create a new device, commit current device first */
> > +       ret = build_info_commit_dev(binfo);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /*
> > +        * we use -ENODEV as the initialization indicator which indicates
> > +        * whether the id need to be reclaimed
> > +        */
> > +       fdev = platform_device_alloc(name, -ENODEV);
> > +       if (!fdev)
> > +               return -ENOMEM;
> > +
> > +       binfo->feature_dev = fdev;
> > +       binfo->feature_num = 0;
> > +       binfo->ioaddr = ioaddr;
> > +       INIT_LIST_HEAD(&binfo->sub_features);
> > +
> > +       fdev->id = alloc_fpga_id(type, &fdev->dev);
> > +       if (fdev->id < 0)
> > +               return fdev->id;
> 
> Do we need platform_device_put if returning here?

Hi Alan,

Actually if any error returned by this build_info_create_dev, it will cause
parse_feature_list returns error code and finally build_info_free is invoked.
In build_info_free function, it will do platform_device_put there, so we don't
have to add code to do put here. : )

Thanks
Hao

> 
> Alan
> 
> > +
> > +       fdev->dev.parent = &binfo->cdev->region.dev;
> > +
> > +       return 0;
> > +}
> > +
