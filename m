From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Date: Fri, 7 Nov 2014 16:31:41 +0100
Message-ID: <20141107163141.3866f3c4@bbrezillon>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415369269-5064-11-git-send-email-boris.brezillon@free-electrons.com>
	<545CDB8D.4080406@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545CDB8D.4080406-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guennadi Liakhovetski <g.liakhovetski-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 07 Nov 2014 15:47:41 +0100
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:

> Nitpicks:
> 
> On 11/07/14 15:07, Boris Brezillon wrote:
> > Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> > users don't have access to these definitions.
> > 
> > We have to keep this definition for user-space users even though they're
> > encouraged to move to the new media_bus_format enum.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >  include/uapi/linux/v4l2-mediabus.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index 3d87db7..4f31d0e 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -15,6 +15,14 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/media-bus-format.h>
> >  
> > +#ifndef __KERNEL__
> > +
> > +/*
> > + * enum v4l2_mbus_pixelcode and its defintions are now deprecated, and
> 
> defintions -> definitions
> 
> > + * MEDIA_BUS_FMT_ defintions (defined in media-bus-format.h) should be
> 
> and again...
> 
> > + * used instead.
> 
> I would also add something like this:
> 
> "New defines should only be added to media-bus-format.h. The v4l2_mbus_pixelcode
> enum is frozen."

I'll fix those typos and add this sentence.

> 
> > + */
> > +
> >  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
> >  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
> >  
> > @@ -102,6 +110,7 @@ enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
> >  };
> > +#endif /* __KERNEL__ */
> >  
> >  /**
> >   * struct v4l2_mbus_framefmt - frame format on the media bus
> > 
> 
> Can you move this struct forward to before the v4l2_mbus_pixelcode enum? That way
> the obsolete code is at the end of the header. People might miss this struct
> otherwise.

Sure.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
