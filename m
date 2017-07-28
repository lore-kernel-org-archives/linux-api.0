From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/22] fpga: add FPGA device framework
Date: Fri, 28 Jul 2017 15:55:17 +0800
Message-ID: <20170728075517.GA6083@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-3-git-send-email-hao.wu@intel.com>
 <CANk1AXR-nSB-6TKpVyskbvfj_F2=jbSv48hpp+UXtKxkTseLqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXR-nSB-6TKpVyskbvfj_F2=jbSv48hpp+UXtKxkTseLqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 27, 2017 at 11:44:01AM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > During FPGA device (e.g PCI-based) discovery, platform devices are
> > registered for different FPGA function units. But the device node path
> > isn't quite friendly to applications.
> >
> 
> Hi Hao,
> 
> Please add a document for fpga-dev under Documentation/fpga to help
> future users.  The header of this patch explains things pretty well
> and could be used with a little formatting for the document.

Sure, will include one document for fpga-dev in the next version patch set.

Thanks
Hao

> 
> Alan
