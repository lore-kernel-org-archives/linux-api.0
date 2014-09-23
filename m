From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 3/5] drm: add bus_formats and nbus_formats fields to
 drm_display_info
Date: Tue, 23 Sep 2014 16:15:16 +0200
Message-ID: <20140923161516.04262bea@bbrezillon>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
	<1406031827-12432-4-git-send-email-boris.brezillon@free-electrons.com>
	<20140923140439.GA5982@ulmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923140439.GA5982@ulmo>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Thierry,

On Tue, 23 Sep 2014 16:04:40 +0200
Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jul 22, 2014 at 02:23:45PM +0200, Boris BREZILLON wrote:
> > Add bus_formats and nbus_formats fields and
> > drm_display_info_set_bus_formats helper function to specify the bus
> > formats supported by a given display.
> > 
> > This information can be used by display controller drivers to configure
> > the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> > RGB or LVDS busses).
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/gpu/drm/drm_crtc.c | 28 ++++++++++++++++++++++++++++
> >  include/drm/drm_crtc.h     |  8 ++++++++
> >  2 files changed, 36 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> > index c808a09..50c8395 100644
> > --- a/drivers/gpu/drm/drm_crtc.c
> > +++ b/drivers/gpu/drm/drm_crtc.c
> > @@ -825,6 +825,34 @@ static void drm_mode_remove(struct drm_connector *connector,
> >  	drm_mode_destroy(connector->dev, mode);
> >  }
> >  
> > +/*
> > + * drm_display_info_set_bus_formats - set the supported bus formats
> > + * @info: display info to store bus formats in
> > + * @fmts: array containing the supported bus formats
> > + * @nfmts: the number of entries in the fmts array
> > + *
> > + * Store the suppported bus formats in display info structure.
> > + */
> > +int drm_display_info_set_bus_formats(struct drm_display_info *info,
> > +				     const enum video_bus_format *fmts,
> > +				     int nfmts)
> 
> Can you make nfmts unsigned please?


Sure.

> 
> > +{
> > +	enum video_bus_format *formats = NULL;
> > +
> > +	if (fmts && nfmts) {
> > +		formats = kmemdup(fmts, sizeof(*fmts) * nfmts, GFP_KERNEL);
> > +		if (!formats)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	kfree(info->bus_formats);
> > +	info->bus_formats = formats;
> > +	info->nbus_formats = formats ? nfmts : 0;
> 
> And perhaps check for formats == NULL && nfmts != 0 since that's not a
> valid pair of values. Then you can simply assign this directly without
> relying on the value of formats.
> 
> Also other variable names use "num_" as a prefix instead of "n", so if
> you're going to respin anyway might as well make the names more
> consistent.

I'll rename the field and variable and add the proper check before
assigning values.

Thanks for your review.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
