From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 19/21] fpga: dfl: afu: add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Thu, 1 Feb 2018 13:16:25 +0800
Message-ID: <20180201051625.GD10273@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-20-git-send-email-hao.wu@intel.com>
 <CANk1AXSfUfVbtbuREwG5Ck8TNZrqBg1fO5AuDDdFk-x=UjRTiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSfUfVbtbuREwG5Ck8TNZrqBg1fO5AuDDdFk-x=UjRTiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 31, 2018 at 08:52:36AM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> I'm adding my "Acked-by' below.  When you post v4, please add it so
> that we can keep track of what got acked.

Sure, thanks a lot for the code review. :)

Hao

> 
> Thanks,
> Alan
> 
> > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
> > need to be supported by all feature devices drivers including FME and AFU.
> > This patch implements above 2 ioctls in FPGA Accelerated Function Unit
> > (AFU) driver.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> Acked-by: Alan Tull <atull@kernel.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
