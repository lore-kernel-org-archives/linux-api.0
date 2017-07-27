From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/22] fpga: mgr: add region_id to fpga_image_info
Date: Thu, 27 Jul 2017 13:14:02 +0800
Message-ID: <20170727051402.GB32273@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-5-git-send-email-hao.wu@intel.com>
 <CANk1AXT_BaeKHMFRiWnTL0owrW0ar+Y1NDDxefwvjUFhNCEO=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXT_BaeKHMFRiWnTL0owrW0ar+Y1NDDxefwvjUFhNCEO=g@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 26, 2017 at 01:33:53PM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> Hi Hao,
> 
> > This patch adds region_id to fpga_image_info data structure, it
> > allows driver to pass region id information to fpga-mgr via
> > fpga_image_info for fpga reconfiguration function.
> >
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  include/linux/fpga/fpga-mgr.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
> > index 66d0e32..b222a57 100644
> > --- a/include/linux/fpga/fpga-mgr.h
> > +++ b/include/linux/fpga/fpga-mgr.h
> > @@ -95,6 +95,7 @@ struct fpga_image_info {
> >         struct sg_table *sgt;
> >         const char *buf;
> >         size_t count;
> > +       int region_id;
> 
> Please add a line to document this region_id above where all the other
> struct members are documented.

Hi Alan

Thanks for the comments, I will fix this in the next version.

  * @sgt: scatter/gather table containing FPGA image
  * @buf: contiguous buffer containing FPGA image
  * @count: size of buf
+ * @region_id: id of target region
  * @overlay: Device Tree overlay
  */
 struct fpga_image_info {

Thanks
Hao

> 
> Alan
> 
> >  #ifdef CONFIG_OF
> >         struct device_node *overlay;
> >  #endif
> > --
> > 1.8.3.1
> >
