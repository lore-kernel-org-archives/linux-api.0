From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Date: Sat, 8 Nov 2014 01:38:41 +0100
Message-ID: <20141108013841.1f3f1bc2@bbrezillon>
References: <545CDB8D.4080406@xs4all.nl>
	<1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
	<545D4BFD.6000206@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545D4BFD.6000206-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>
Cc: Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guennadi Liakhovetski <g.liakhovetski-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 08 Nov 2014 00:47:25 +0200
Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org> wrote:

> Hi Boris,
> 
> Boris Brezillon wrote:
> > @@ -102,6 +113,7 @@ enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
> >  };
> > +#endif /* __KERNEL__ */
> >  
> >  /**
> >   * struct v4l2_mbus_framefmt - frame format on the media bus
> 
> Was it intended to be this way, or did I miss something? I'd put this to
> beginning of the file, as Hans suggested.

Oops, I forgot to move the struct.

> 
> With this matter sorted out, for the set:
> 
> Acked-by: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
