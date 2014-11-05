From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 02/15] [media] v4l: Update subdev-formats doc with new
 MEDIA_BUS_FMT values
Date: Wed, 5 Nov 2014 16:01:28 +0100
Message-ID: <20141105160128.0e3599be@bbrezillon>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415094910-15899-3-git-send-email-boris.brezillon@free-electrons.com>
	<20141105145726.GR3136@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20141105145726.GR3136@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
List-Id: linux-api@vger.kernel.org

Hi Sakari,

On Wed, 5 Nov 2014 16:57:27 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi Boris,
> 
> On Tue, Nov 04, 2014 at 10:54:57AM +0100, Boris Brezillon wrote:
> > In order to have subsytem agnostic media bus format definitions we've
> > moved media bus definition to include/uapi/linux/media-bus-format.h and
> > prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
> > 
> > Update the v4l documentation accordingly.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  Documentation/DocBook/media/Makefile               |   2 +-
> >  Documentation/DocBook/media/v4l/subdev-formats.xml | 308 ++++++++++-----------
> >  include/uapi/linux/v4l2-mediabus.h                 |   2 +
> >  3 files changed, 157 insertions(+), 155 deletions(-)
> > 
> 
> ...
> 
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index f471064..9fbe891 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -32,6 +32,8 @@ enum v4l2_mbus_pixelcode {
> >  	MEDIA_BUS_TO_V4L2_MBUS(RGB888_2X12_BE),
> >  	MEDIA_BUS_TO_V4L2_MBUS(RGB888_2X12_LE),
> >  	MEDIA_BUS_TO_V4L2_MBUS(ARGB8888_1X32),
> > +	MEDIA_BUS_TO_V4L2_MBUS(RGB444_1X12),
> > +	MEDIA_BUS_TO_V4L2_MBUS(RGB565_1X16),
> 
> Shouldn't this to go to a separate patch?

Absolutely, some changes from a different patch have slipped into this
one.

I'll fix that.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
