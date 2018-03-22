From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 23/24] fpga: dfl: afu: add user afu sub feature support
Date: Thu, 22 Mar 2018 12:41:56 +0800
Message-ID: <20180322044156.GB8305@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-24-git-send-email-hao.wu@intel.com>
 <CANk1AXQpPXhNoPt1Uj=YvbtO+jun7e2Yzvyp+wuR1ZXx6+-i8Q@mail.gmail.com>
 <20180320071037.GB31239@hao-dev>
 <CANk1AXSyh1ZcbgVbj3DxjULEeYKMfq_4CA6P0DK6+_z-pnBMUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSyh1ZcbgVbj3DxjULEeYKMfq_4CA6P0DK6+_z-pnBMUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 06:50:54PM -0500, Alan Tull wrote:
> On Tue, Mar 20, 2018 at 2:10 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> >> > +static int afu_mmap(struct file *filp, struct vm_area_struct *vma)
> >> > +{
> >> > +       struct fpga_afu_region region;
> >> > +       struct platform_device *pdev = filp->private_data;
> >> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> >> > +       u64 size = vma->vm_end - vma->vm_start;
> >> > +       u64 offset;
> >> > +       int ret;
> >> > +
> >> > +       if (!(vma->vm_flags & VM_SHARED))
> >> > +               return -EINVAL;
> >> > +
> >> > +       offset = vma->vm_pgoff << PAGE_SHIFT;
> >> > +       ret = afu_get_region_by_offset(pdata, offset, size, &region);
> 
> Most of the functions here are afu_region_*, but there's also
> afu_get_region_by_*.  Better if afu_region_get_by_* to be consistent.

Agree, will fix it in the next version, thanks a lot for the comments.

Hao
