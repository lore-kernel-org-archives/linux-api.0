From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [Y2038] [PATCH v2 9/9] [media] omap3isp: support 64-bit version of omap3isp_stat_data
Date: Mon, 09 Nov 2015 23:04:36 +0200
Message-ID: <5182415.f83yL8ScIF@avalon>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <5733951.qvCn4pc5g5@avalon> <3870339.ZAkvtJ2orM@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3870339.ZAkvtJ2orM@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Monday 09 November 2015 21:30:41 Arnd Bergmann wrote:
> On Monday 09 November 2015 22:09:26 Laurent Pinchart wrote:
> > On Thursday 17 September 2015 23:19:40 Arnd Bergmann wrote:
> > > C libraries with 64-bit time_t use an incompatible format for
> > > struct omap3isp_stat_data. This changes the kernel code to
> > > support either version, by moving over the normal handling
> > > to the 64-bit variant, and adding compatiblity code to handle
> > > the old binary format with the existing ioctl command code.
> > > 
> > > Fortunately, the command code includes the size of the structure,
> > > so the difference gets handled automatically.
> > 
> > We plan to design a new interface to handle statistics in V4L2. That API
> > should support proper 64-bit timestamps out of the box, and will be
> > implemented by the OMAP3 ISP driver. Userspace should then move to it. I
> > wonder if it's worth it to fix the existing VIDIOC_OMAP3ISP_STAT_REQ ioctl
> > given that I expect it to have a handful of users at most.
> 
> We still need to do something to the driver. The alternative would
> be to make the existing ioctl command optional at kernel compile-time
> so we can still build the driver once we remove the 'struct timeval'
> definition. That patch would add slightly less complexity here
> but also lose functionality.
> 
> As my patch here depends on the struct v4l2_timeval I introduced in
> an earlier patch of the series, we will have to change it anyways,
> but I'd prefer to keep the basic idea. Let's get back to this one
> after the v4l_buffer replacement work is done.

Fine with me. I'll mark the patch as "Obsoleted" in patchwork in the meantime.

-- 
Regards,

Laurent Pinchart
