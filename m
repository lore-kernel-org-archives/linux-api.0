From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 5/5] drm: panel: simple-panel: add bus format
 information for foxlink panel
Date: Tue, 23 Sep 2014 16:13:01 +0200
Message-ID: <20140923161301.54dda63c@bbrezillon>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
	<1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
	<20140923140612.GB5982@ulmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140923140612.GB5982@ulmo>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Thierry,

On Tue, 23 Sep 2014 16:06:13 +0200
Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jul 22, 2014 at 02:23:47PM +0200, Boris BREZILLON wrote:
> > Foxlink's fl500wvr00-a0t supports RGB888 format.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/gpu/drm/panel/panel-simple.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> > index 42fd6d1..f1e49fd 100644
> > --- a/drivers/gpu/drm/panel/panel-simple.c
> > +++ b/drivers/gpu/drm/panel/panel-simple.c
> > @@ -428,6 +428,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
> >  		.width = 108,
> >  		.height = 65,
> >  	},
> > +	.bus_format = VIDEO_BUS_FMT_RGB888_1X24,
> 
> This is really equivalent to .bpc = 8. Didn't you say you had other
> use-cases where .bpc wasn't sufficient?

Yes, the HLCDC support RGB565 where you don't have the same number of
bits for each color (Red and Blue = 5 bits, Green = 6 bits), and thus
can't be encoded in the bpc field.

> 
> Thierry



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
