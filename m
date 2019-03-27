From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH 03/17] fpga: dfl: fme: support 512bit data width PR
Date: Wed, 27 Mar 2019 13:46:37 +0800
Message-ID: <20190327054637.GC20968@hao-dev>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-4-git-send-email-hao.wu@intel.com>
 <127a9356a7bf597d35dd361f2b16bf80460f0370.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <127a9356a7bf597d35dd361f2b16bf80460f0370.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Wood <swood@redhat.com>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 05:53:50PM -0500, Scott Wood wrote:
> On Mon, 2019-03-25 at 11:07 +0800, Wu Hao wrote:
> > @@ -200,21 +228,32 @@ static int fme_mgr_write(struct fpga_manager *mgr,
> >  			pr_credit = FIELD_GET(FME_PR_STS_PR_CREDIT,
> > pr_status);
> >  		}
> >  
> > -		if (count < 4) {
> > +		if (count < priv->pr_datawidth) {
> >  			dev_err(dev, "Invalid PR bitstream size\n");
> >  			return -EINVAL;
> 
> Shouldn't this have become a WARN_ON in patch 2 given that the kernel
> already pads the buffer?

Thanks a lot for the review and comments.

I agree. it's better to use WARN_ON this place.

> 
> >  		}
> >  
> > -		pr_data = 0;
> > -		pr_data |= FIELD_PREP(FME_PR_DATA_PR_DATA_RAW,
> > -				      *(((u32 *)buf) + i));
> > -		writeq(pr_data, fme_pr + FME_PR_DATA);
> > -		count -= 4;
> > +		switch (priv->pr_datawidth) {
> > +		case 4:
> > +			pr_data = 0;
> > +			pr_data |= FIELD_PREP(FME_PR_DATA_PR_DATA_RAW,
> > +					*((u32 *)buf));
> 
> I know it's not new, but why not just "pr_data = FIELD..."?  Const should
> also be preserved in the cast, and you can drop one set of parentheses.

Yes, agree, will fix this.

> 
> > +			writeq(pr_data, fme_pr + FME_PR_DATA);
> > +			break;
> > +		case 64:
> > +			copy512((void *)buf, fme_pr + FME_PR_512_DATA);
> > +			break;
> 
> Unnecessary cast.

Will fix this.

> 
> > +		default:
> > +			ret = -EFAULT;
> > +			goto done;
> 
> How is it EFAULT?  Any other value for pr_datawidth should be WARN_ON
> since it's set by kernel code.

Agree, will fix this in the next version.

> 
> > @@ -159,13 +161,10 @@ static int fme_pr(struct platform_device *pdev,
> > unsigned long arg)
> >  		fpga_bridges_put(&region->bridge_list);
> >  
> >  	put_device(&region->dev);
> > -unlock_exit:
> > -	mutex_unlock(&pdata->lock);
> >  free_exit:
> >  	vfree(buf);
> > -	if (copy_to_user((void __user *)arg, &port_pr, minsz))
> > -		return -EFAULT;
> > -
> 
> Why is the copy_to_user being removed?

This code is not needed at all but added by mistake i think.

Sorry, i should move these code into a separated patch with proper comments
to avoid confusion.

Thanks
Hao

> 
> -Scott
