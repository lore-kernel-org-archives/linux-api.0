From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/7] tuner-core: properly initialize media controller
 subdev
Date: Sun, 11 Jan 2015 12:25:53 -0200
Message-ID: <20150111122553.76394653@recife.lan>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
	<4ff2de5fce002a6f6f87993440f45e0f198c57cb.1420315245.git.mchehab@osg.samsung.com>
	<3223125.oELRrvBOf4@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3223125.oELRrvBOf4@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Sun, 11 Jan 2015 16:02:41 +0200
Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Saturday 03 January 2015 18:09:33 Mauro Carvalho Chehab wrote:
> > Properly initialize tuner core subdev at the media controller.
> > 
> > That requires a new subtype at the media controller API.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > 
> > diff --git a/drivers/media/v4l2-core/tuner-core.c
> > b/drivers/media/v4l2-core/tuner-core.c index 559f8372e2eb..114715ed0110
> > 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -134,6 +134,9 @@ struct tuner {
> >  	unsigned int        type; /* chip type id */
> >  	void                *config;
> >  	const char          *name;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	struct media_pad	pad;
> > +#endif
> 
> I'm not too familiar with tuners, do they all have a single output only and no 
> input ?

They have an input: the antenna connector. However, I don't see any need
to map it for most tuners, as there's generally just one input, hardwired
into the tuner chip.

There are some hardware with 2 antenna connectors, but for different
functions (FM and TV). They're selected automatically when the V4L2
driver switches between FM and TV.

In any case, the tuner-core doesn't provide any way to select the
antenna input.

So, if a driver would need to select the input, it would either need
to not use tuner-core or some patch will be required to add such
functionality inside tuner-core.

> >  };
> > 
> >  /*
> > @@ -434,6 +437,8 @@ static void set_type(struct i2c_client *c, unsigned int
> > type, t->name = analog_ops->info.name;
> >  	}
> > 
> > +	t->sd.entity.name = t->name;
> > +
> 
> Entity information is not supposed to change at runtime, I'm not sure to be 
> comfortable with this change.
> 
> set_type() is called at probe time and in tuner_s_type_addr(). The former just 
> duplicates the name initialization in tuner_probe(), so isn't really needed. 
> The later bothers me.

The tuner-core driver is a "core subdev" implementation. It handles
the ioctl logic, but the actual driver is a different one. It also
have internally a probe logic that will load the correct tuner subdev.

The tuner_s_type_addr() callback, used only at bridge probing time,
is a way for the bridge driver to provide the name of the tuner driver
that should be loaded, plus its I2C address.

So, once the board is probed, the name shouldn't change.

> 
> >  	tuner_dbg("type set to %s\n", t->name);
> > 
> >  	t->mode_mask = new_mode_mask;
> > @@ -592,6 +597,7 @@ static int tuner_probe(struct i2c_client *client,
> >  	struct tuner *t;
> >  	struct tuner *radio;
> >  	struct tuner *tv;
> > +	int ret;
> > 
> >  	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
> >  	if (NULL == t)
> > @@ -696,6 +702,15 @@ register_client:
> >  		   t->type,
> >  		   t->mode_mask & T_RADIO ? " Radio" : "",
> >  		   t->mode_mask & T_ANALOG_TV ? " TV" : "");
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	t->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
> > +	t->sd.entity.name = t->name;
> 
> v4l2_subdev_init(), called by v4l2_i2c_subdev_init(), sets sd->entity.name to 
> point to sd->name. Is there a reason why the subdev name can't be used as the 
> entity name ?

If we don't set entity.name to t->name, the sd->name will be "tuner-core",
instead of the name of the real subdev.

> > +
> > +	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
> > +	if (ret < 0)
> > +		tuner_err("failed to initialize media entity!\n");
> > +#endif
> >  	return 0;
> >  }
> > 
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index 707db275f92b..5ffde035789b 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -66,6 +66,8 @@ struct media_device_info {
> >  /* A converter of analogue video to its digital representation. */
> >  #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
> > 
> > +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
> > +
> >  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
> > 
> >  struct media_entity_desc {
> 
