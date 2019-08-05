From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 11/12] fpga: dfl: fme: add global error reporting
 support
Date: Mon, 5 Aug 2019 17:56:26 +0200
Message-ID: <20190805155626.GD8107@kroah.com>
References: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
 <1564914022-3710-12-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564914022-3710-12-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Luwei Kang <luwei.kang@intel.com>, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 04, 2019 at 06:20:21PM +0800, Wu Hao wrote:
> +static int fme_global_err_init(struct platform_device *pdev,
> +			       struct dfl_feature *feature)
> +{
> +	struct device *dev;
> +	int ret = 0;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->parent = &pdev->dev;
> +	dev->release = err_dev_release;
> +	dev_set_name(dev, "errors");
> +
> +	fme_error_enable(feature);
> +
> +	ret = device_register(dev);
> +	if (ret) {
> +		put_device(dev);
> +		return ret;
> +	}
> +
> +	ret = device_add_groups(dev, error_groups);

cute, but no, you do not create a whole struct device for a subdir.  Use
the attribute group name like you did on earlier patches.

And again, you raced userspace and lost :(

thanks,

greg k-h
