From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v5 00/28] FPGA Device Feature List (DFL) Device Drivers
Date: Fri, 4 May 2018 08:15:28 +0800
Message-ID: <20180504001528.GA31101@hao-dev>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <CANk1AXSFQzBoZWQu4R9aYQSXFbr76UQ_-39ENe5hSOncKuDq+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSFQzBoZWQu4R9aYQSXFbr76UQ_-39ENe5hSOncKuDq+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 03, 2018 at 04:14:48PM -0500, Alan Tull wrote:
> On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:
> > Hi All,
> >
> > Here is v5 patch-series adding drivers for FPGA DFL devices.
> >
> > This patch series provides a common framework to support FPGA Device Feature
> > List (DFL), and also feature dev drivers under this DFL framework to provide
> > interfaces for userspace applications to configure, enumerate, open, and
> > access FPGA accelerators on DFL based FPGA device and enables system level
> > management functions such as FPGA partial reconfiguration, power management
> > and virtualization.
> 
> Hi Hao,
> 

Hi Alan,

Thanks for your review on this patch set.

> I've started looking at your v5 here.  It's 5212 lines of code, so
> it's not tiny.
> 
> I see a lot of renaming from 'fpga' to 'dfl', thanks for doing that.
> 
> The main thing that stands out at first look is a new method of
> registering port ops.  It would be better if the fpga bridge framework
> were expanded or changed somehow to do that.  It's like we have two
> bridge frameworks now.

I only limit this change in DFL framework, because introduce a port ops
here to DFL framework is to resolve the hard dependency between DFL
driver modules (e.g DFL FME and port), this sounds like a DFL specific
thing, and I am not sure if there is some real need or benefit for other
non-DFL module, so i didn't modify the common fpga bridge code.

> 
> I see that there isn't a way of specifying which FPGA mgr driver to
> use, so dfl-fme-mgr.c is tied to dfl-fme-pr.c.  It would be better if
> the DFL could specify which fpga manager driver to use.

Hm.. I think we discussed this against v4. It could be a different sub
feature with different id to support different PR hardware.  In that
case, we could still reuse sub feature driver provided by dfl-fme-pr.c
(specify a new id which reuses the same pr_mgmt_ops)

        {
                 .id = FME_FEATURE_ID_PR_MGMT,
                 .ops = &pr_mgmt_ops,
        },

Inside dfl-fme-pr.c, it could parse the different id to create different
platform devices for different FPGA mgrs.

Could we leave this a later change? as i don't have a different hardware
like this at this moment (maybe future) and I don't see current framework
block us on reusing these code.

> 
> Maybe I'm repeating myself here, the biggest question I'm asking
> region, how much of this code can be reused?  I would hope that all of
> it could except for the fpga manager/bridge drivers.  That was the
> intent of the original FPGA framework.  

I fully understand that it's better to make code reusable, this is what
we are trying to do in these patchsets. But it's still not very clear that
who others or which products will use this DFL framework and how, what's
the difficulty they will face and what kind of help or changes we could
provide. so maybe we could defer some work when people really need it, if
there is no hard blocking issue on architecture level.

> I'll have more time next week to look in more depth.

Looking forward to your feedback. Thanks again for your review. :)

Hao

> 
> Alan
> 
