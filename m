From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v5 07/28] fpga: dfl: add chardev support for feature
 devices
Date: Fri, 8 Jun 2018 08:11:08 +0800
Message-ID: <20180608001108.GA20571@hao-dev>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <1525229431-3087-8-git-send-email-hao.wu@intel.com>
 <CANk1AXRQx=QtwmSKuWiGprMcfjNnUWcBHNy-hTfP+JaQZsJLLA@mail.gmail.com>
 <20180606122457.GB7681@hao-dev>
 <CANk1AXTmpa1P55qCwZhyn=CGoa3v_hJ-KFCQsy7kMTBpULc6hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXTmpa1P55qCwZhyn=CGoa3v_hJ-KFCQsy7kMTBpULc6hQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 07, 2018 at 01:03:18PM -0500, Alan Tull wrote:
> On Wed, Jun 6, 2018 at 7:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> One more...
> 
> >> > +static dev_t dfl_get_devt(enum dfl_fpga_devt_type type, int id)
> >> > +{
> >> > +       WARN_ON(type >= DFL_FPGA_DEVT_MAX);
> >> > +
> >> > +       return MKDEV(MAJOR(dfl_chrdevs[type].devt), id);
> >> > +}
> >> > +
> >> > +/**
> >> > + * dfl_fpga_register_dev_ops - register cdev ops for feature dev
> >> > + *
> >> > + * @pdev: feature dev.
> >> > + * @fops: file operations for feature dev's cdev.
> >> > + * @owner: owning module/driver.
> >> > + *
> >> > + * Return: 0 on success, negative error code otherwise.
> >> > + */
> >> > +int dfl_fpga_register_dev_ops(struct platform_device *pdev,
> >> > +                             const struct file_operations *fops,
> >> > +                             struct module *owner)
> >> > +{
> >> > +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> >> > +
> >> > +       cdev_init(&pdata->cdev, fops);
> >> > +       pdata->cdev.owner = owner;
> >> > +
> >> > +       /*
> >> > +        * set parent to the feature device so that its refcount is
> >> > +        * decreased after the last refcount of cdev is gone, that
> >> > +        * makes sure the feature device is valid during device
> >> > +        * file's life-cycle.
> >> > +        */
> >> > +       pdata->cdev.kobj.parent = &pdev->dev.kobj;
> >> > +
> >> > +       return cdev_add(&pdata->cdev, pdev->dev.devt, 1);
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(dfl_fpga_register_dev_ops);
> >> > +
> >> > +/**
> >> > + * dfl_fpga_unregister_dev_ops - unregister cdev ops for feature dev
> >> > + * @pdev: feature dev.
> >> > + */
> >> > +void dfl_fpga_unregister_dev_ops(struct platform_device *pdev)
> >> > +{
> >> > +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> >> > +
> >> > +       cdev_del(&pdata->cdev);
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(dfl_fpga_unregister_dev_ops);
> 
> How about dfl_fpga_dev_ops_register/unregister?

Sure, will fix this in the v6. Thanks.

Hao

> 
> Thanks,
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
