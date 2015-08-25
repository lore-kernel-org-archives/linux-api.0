From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v7 24/44] [media] uapi/media.h: Fix entity namespace
Date: Tue, 25 Aug 2015 08:25:07 -0300
Message-ID: <20150825082507.578ffa97@recife.lan>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<5cf25be2d0508e02f6ffe469509fa12c45ddcb8d.1440359643.git.mchehab@osg.samsung.com>
	<55DC2E2D.4090000@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55DC2E2D.4090000-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Tue, 25 Aug 2015 10:58:21 +0200
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:

> On 08/23/15 22:17, Mauro Carvalho Chehab wrote:
> > Now that interfaces got created, we need to fix the entity
> > namespace.
> > 
> > So, let's create a consistent new namespace and add backward
> > compatibility macros to keep the old namespace preserved.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> > index 5a2bd03f5dc0..acada5ba9442 100644
> > --- a/drivers/media/dvb-core/dvbdev.c
> > +++ b/drivers/media/dvb-core/dvbdev.c
> > @@ -229,17 +229,17 @@ static void dvb_create_media_entity(struct dvb_device *dvbdev,
> >  
> >  	switch (type) {
> >  	case DVB_DEVICE_FRONTEND:
> > -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_FE;
> > +		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMOD;
> >  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
> >  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
> >  		break;
> >  	case DVB_DEVICE_DEMUX:
> > -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_DEMUX;
> > +		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMUX;
> >  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
> >  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
> >  		break;
> >  	case DVB_DEVICE_CA:
> > -		dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB_CA;
> > +		dvbdev->entity->type = MEDIA_ENT_T_DVB_CA;
> >  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
> >  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
> >  		break;
> > @@ -438,7 +438,7 @@ EXPORT_SYMBOL(dvb_unregister_device);
> >  void dvb_create_media_graph(struct dvb_adapter *adap)
> >  {
> >  	struct media_device *mdev = adap->mdev;
> > -	struct media_entity *entity, *tuner = NULL, *fe = NULL;
> > +	struct media_entity *entity, *tuner = NULL, *demod = NULL;
> >  	struct media_entity *demux = NULL, *dvr = NULL, *ca = NULL;
> >  	struct media_interface *intf;
> >  
> > @@ -450,26 +450,26 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
> >  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> >  			tuner = entity;
> >  			break;
> > -		case MEDIA_ENT_T_DEVNODE_DVB_FE:
> > -			fe = entity;
> > +		case MEDIA_ENT_T_DVB_DEMOD:
> > +			demod = entity;
> >  			break;
> > -		case MEDIA_ENT_T_DEVNODE_DVB_DEMUX:
> > +		case MEDIA_ENT_T_DVB_DEMUX:
> >  			demux = entity;
> >  			break;
> > -		case MEDIA_ENT_T_DEVNODE_DVB_DVR:
> > +		case MEDIA_ENT_T_DVB_TSOUT:
> >  			dvr = entity;
> >  			break;
> > -		case MEDIA_ENT_T_DEVNODE_DVB_CA:
> > +		case MEDIA_ENT_T_DVB_CA:
> >  			ca = entity;
> >  			break;
> >  		}
> >  	}
> >  
> > -	if (tuner && fe)
> > -		media_create_pad_link(tuner, 0, fe, 0, 0);
> > +	if (tuner && demod)
> > +		media_create_pad_link(tuner, 0, demod, 0, 0);
> >  
> > -	if (fe && demux)
> > -		media_create_pad_link(fe, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
> > +	if (demod && demux)
> > +		media_create_pad_link(demod, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
> >  
> >  	if (demux && dvr)
> >  		media_create_pad_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 21c96cd7a6ae..7306aeaff807 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -42,31 +42,67 @@ struct media_device_info {
> >  
> >  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
> >  
> > +/*
> > + * Base numbers for entity types
> > + *
> > + * Please notice that the huge gap of 16 bits for each base is overkill!
> > + * 8 bits is more than enough to avoid starving entity types for each
> > + * subsystem.
> > + *
> > + * However, It is kept this way just to avoid binary breakages with the
> > + * namespace provided on legacy versions of this header.
> > + */
> > +#define MEDIA_ENT_T_DVB_BASE		0x00000000
> > +#define MEDIA_ENT_T_V4L2_BASE		0x00010000
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
> > +
> > +/* V4L2 entities */
> > +#define MEDIA_ENT_T_V4L2_VIDEO		(MEDIA_ENT_T_V4L2_BASE + 1)
> > +	/*
> > +	 * Please notice that numbers between MEDIA_ENT_T_V4L2_BASE + 2 and
> > +	 * MEDIA_ENT_T_V4L2_BASE + 4 can't be used, as those values used
> > +	 * to be declared for FB, ALSA and DVB entities.
> > +	 * As those values were never atually used in practice, we're just
> 
> s/atually/actually/
> 
> > +	 * adding them as backward compatibily macros and keeping the
> 
> s/compatibily/compatibility/
> 
> > +	 * numberspace cleaned here. This way, we avoid breaking compilation,
> 
> s/cleaned/clean/
> 
> > +	 * in the case of having some userspace application using the old
> > +	 * symbols.
> > +	 */
> > +#define MEDIA_ENT_T_V4L2_VBI		(MEDIA_ENT_T_V4L2_BASE + 5)
> > +#define MEDIA_ENT_T_V4L2_RADIO		(MEDIA_ENT_T_V4L2_BASE + 6)
> > +#define MEDIA_ENT_T_V4L2_SWRADIO	(MEDIA_ENT_T_V4L2_BASE + 7)
> 
> Why are these entities? Aren't these interface types?

We need both:

The entity represents the data sinks (or sources), and the interface the
control interfaces.

I'm actually in doubt about MEDIA_ENT_T_V4L2_RADIO. Maybe we'll need a
MEDIA_ENT_T_V4L2_RADIO_RDS too.

Of course, MEDIA_ENT_T_V4L2_RADIO is not needed for receivers, but I
guess it is needed for TX.

> 
> > +
> > +/* V4L2 Sub-device entities */
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 1)
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 2)
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 3)
> > +	/* A converter of analogue video to its digital representation. */
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 4)
> > +	/* Tuner entity is actually both V4L2 and DVB subdev */
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 5)
> > +
> > +/* DVB entities */
> > +#define MEDIA_ENT_T_DVB_DEMOD		(MEDIA_ENT_T_DVB_BASE + 4)
> > +#define MEDIA_ENT_T_DVB_DEMUX		(MEDIA_ENT_T_DVB_BASE + 5)
> > +#define MEDIA_ENT_T_DVB_TSOUT		(MEDIA_ENT_T_DVB_BASE + 6)
> > +#define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 7)
> > +#define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 8)
> > +
> > +/* Legacy symbols used to avoid userspace compilation breakages */
> >  #define MEDIA_ENT_TYPE_SHIFT		16
> >  #define MEDIA_ENT_TYPE_MASK		0x00ff0000
> >  #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
> >  
> > -#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
> > -#define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
> > +#define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_T_V4L2_BASE
> > +#define MEDIA_ENT_T_V4L2_SUBDEV		MEDIA_ENT_T_V4L2_SUBDEV_BASE
> > +
> > +#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_T_V4L2_VIDEO
> > +
> >  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> >  #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> > -#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
> > -#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
> > -#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
> > -#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
> > -#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
> > +#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> >  
> > -/* Legacy symbol. Use it to avoid userspace compilation breakages */
> > -#define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
> > -
> > -#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> > -/* A converter of analogue video to its digital representation. */
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
> > -
> > -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
> > +/* Entity types */
> >  
> >  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
> >  
> > 
> 
> Hmm, I'm postponing further review. It might become clearer after reviewing
> more of this patch series.
> 
> One reason why this is a bit difficult to review is that it is not immediately
> obvious which defines are here for backwards compat (and shouldn't be used in
> the kernel anymore) and which defines are new.

The ones under /* Legacy symbols used to avoid userspace compilation breakages */
comment should not be used anymore.

> May I suggest that either in this or in a later patch the defines that shouldn't
> be used in the kernel should be placed under #ifndef __KERNEL__?

They'll be under a #ifndef __KERNEL__, but this will happen latter at
the patch series. We need first to remove their usage internally before
adding the ifndef.

Regards,
Mauro
