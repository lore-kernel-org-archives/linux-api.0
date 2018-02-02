From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 19/21] fpga: dfl: afu: add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Fri, 2 Feb 2018 17:08:22 +0800
Message-ID: <20180202090822.GA17015@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-20-git-send-email-hao.wu@intel.com>
 <CANk1AXSfUfVbtbuREwG5Ck8TNZrqBg1fO5AuDDdFk-x=UjRTiw@mail.gmail.com>
 <20180201051625.GD10273@hao-dev>
 <20180201151309.q3jjx42y6ldcrhc6@insfl13.etec.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201151309.q3jjx42y6ldcrhc6-y7F9n2Zoz0NnbPI/LkqVKXLzTDPwzsqGqZgBStWHTEI@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 01, 2018 at 04:13:09PM +0100, Moritz Fischer wrote:
> On Thu, Feb 01, 2018 at 01:16:25PM +0800, Wu Hao wrote:
> > On Wed, Jan 31, 2018 at 08:52:36AM -0600, Alan Tull wrote:
> > > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > 
> > > Hi Hao,
> > > 
> > > I'm adding my "Acked-by' below.  When you post v4, please add it so
> > > that we can keep track of what got acked.
> > 
> > Sure, thanks a lot for the code review. :)
> > 
> > Hao
> > 
> > > 
> > > Thanks,
> > > Alan
> > > 
> > > > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
> > > > need to be supported by all feature devices drivers including FME and AFU.
> > > > This patch implements above 2 ioctls in FPGA Accelerated Function Unit
> > > > (AFU) driver.
> > > >
> > > > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Looks good,

Thanks a lot for the code review. :)

Hao

> 
> Moritz
