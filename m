From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 04/18] media controller: Rename camera entities
Date: Fri, 08 May 2015 14:03:01 +0200
Message-ID: <554CA5F5.1040101@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com> <a1a45e1b62e9dc69fd0a2d11dff57a414304c541.1431046915.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <a1a45e1b62e9dc69fd0a2d11dff57a414304c541.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Sakari Ailus <sakari.ailus@iki.fi>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Kyungmin Park <kyungmin.park@samsung.com>, Heungjun Kim <riverful.kim@samsung.com>, Prabhakar Lad <prabhakar.csengg@gmail.com>, Andrzej Hajda <a.hajda@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> As explained before, the hole idea of subtypes at entities was

hole -> whole

> not nice. All V4L2 subdevs may have a device node associated.
> 
> Also, the hole idea is to expose hardware IP blocks, so calling
> them as V4L2 is a very bad practice, as they were not designed
> for the V4L2 API. It is just the reverse.
> 
> So, instead of using V4L2_SUBDEV, let's call the camera sub-
> devices with CAM, instead:
> 
> 	MEDIA_ENT_T_V4L2_SUBDEV_SENSOR -> MEDIA_ENT_T_CAM_SENSOR
> 	MEDIA_ENT_T_V4L2_SUBDEV_FLASH  -> MEDIA_ENT_T_CAM_FLASH
> 	MEDIA_ENT_T_V4L2_SUBDEV_LENS   -> MEDIA_ENT_T_CAM_LENS

I would actually postpone this until Laurent has a properties API ready.
These entity types are fatally flawed since an entity can combine functions
in one. E.g. an i2c device (generally represented as a single entity) might
provide for both sensor and flash. Or combine tuner and video decoder, etc.

Basically an entity like this is a sub-device (as in the literal meaning
of being a part of a larger device) that has one or more functions and may
have device node(s) associated with it. That is best expressed as properties.

And you really do have to tell userspace that these entities expose a
v4l-subdev device node. Renaming them doesn't make that go away.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 5b8147629159..759604e3529f 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -219,15 +219,15 @@
>  	    <entry>Unknown V4L sub-device</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_CAM_SENSOR</constant></entry>
>  	    <entry>Video sensor</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_CAM_FLASH</constant></entry>
>  	    <entry>Flash controller</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_CAM_LENS</constant></entry>
>  	    <entry>Lens controller</entry>
>  	  </row>
>  	  <row>
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index c70ababce954..c12f873a8e26 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -516,7 +516,7 @@ static int adp1653_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto free_and_quit;
>  
> -	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev.entity.type = MEDIA_ENT_T_CAM_FLASH;
>  
>  	return 0;
>  
> diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
> index 301084b07887..9a2872be11b0 100644
> --- a/drivers/media/i2c/as3645a.c
> +++ b/drivers/media/i2c/as3645a.c
> @@ -831,7 +831,7 @@ static int as3645a_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto done;
>  
> -	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev.entity.type = MEDIA_ENT_T_CAM_FLASH;
>  
>  	mutex_init(&flash->power_lock);
>  
> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
> index d9ece4b2d047..4d28cda77f4d 100644
> --- a/drivers/media/i2c/lm3560.c
> +++ b/drivers/media/i2c/lm3560.c
> @@ -368,7 +368,7 @@ static int lm3560_subdev_init(struct lm3560_flash *flash,
>  	rval = media_entity_init(&flash->subdev_led[led_no].entity, 0, NULL, 0);
>  	if (rval < 0)
>  		goto err_out;
> -	flash->subdev_led[led_no].entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev_led[led_no].entity.type = MEDIA_ENT_T_CAM_FLASH;
>  
>  	return rval;
>  
> diff --git a/drivers/media/i2c/lm3646.c b/drivers/media/i2c/lm3646.c
> index 626fb4679c02..19ee2ac00be7 100644
> --- a/drivers/media/i2c/lm3646.c
> +++ b/drivers/media/i2c/lm3646.c
> @@ -285,7 +285,7 @@ static int lm3646_subdev_init(struct lm3646_flash *flash)
>  	rval = media_entity_init(&flash->subdev_led.entity, 0, NULL, 0);
>  	if (rval < 0)
>  		goto err_out;
> -	flash->subdev_led.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev_led.entity.type = MEDIA_ENT_T_CAM_FLASH;
>  	return rval;
>  
>  err_out:
> diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
> index 6404c0d93e7a..beb519cf8be4 100644
> --- a/drivers/media/i2c/m5mols/m5mols_core.c
> +++ b/drivers/media/i2c/m5mols/m5mols_core.c
> @@ -978,7 +978,7 @@ static int m5mols_probe(struct i2c_client *client,
>  	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
>  	if (ret < 0)
>  		return ret;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  
>  	init_waitqueue_head(&info->irq_waitq);
>  	mutex_init(&info->lock);
> diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
> index f197b6cbd407..a03556197405 100644
> --- a/drivers/media/i2c/noon010pc30.c
> +++ b/drivers/media/i2c/noon010pc30.c
> @@ -779,7 +779,7 @@ static int noon010_probe(struct i2c_client *client,
>  		goto np_err;
>  
>  	info->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &info->pad, 0);
>  	if (ret < 0)
>  		goto np_err;
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> index d700a1d0a6f2..63b9464e813f 100644
> --- a/drivers/media/i2c/ov2659.c
> +++ b/drivers/media/i2c/ov2659.c
> @@ -1425,7 +1425,7 @@ static int ov2659_probe(struct i2c_client *client,
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &ov2659->pad, 0);
>  	if (ret < 0) {
>  		v4l2_ctrl_handler_free(&ov2659->ctrls);
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 2bc473385c91..ed3c0573a0f8 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1500,7 +1500,7 @@ static int ov965x_probe(struct i2c_client *client,
>  		return ret;
>  
>  	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &ov965x->pad, 0);
>  	if (ret < 0)
>  		return ret;
> diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
> index 97084237275d..23af7f90678a 100644
> --- a/drivers/media/i2c/s5k4ecgx.c
> +++ b/drivers/media/i2c/s5k4ecgx.c
> @@ -961,7 +961,7 @@ static int s5k4ecgx_probe(struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &priv->pad, 0);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index bee73de347dc..fadd48d35a55 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -408,7 +408,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
>  
>  static inline bool s5k5baf_is_cis_subdev(struct v4l2_subdev *sd)
>  {
> -	return sd->entity.type == MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	return sd->entity.type == MEDIA_ENT_T_CAM_SENSOR;
>  }
>  
>  static inline struct s5k5baf *to_s5k5baf(struct v4l2_subdev *sd)
> @@ -1904,7 +1904,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	state->cis_pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, NUM_CIS_PADS, &state->cis_pad, 0);
>  	if (ret < 0)
>  		goto err;
> diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
> index d0ad6a25bdab..d2390c6e5dbe 100644
> --- a/drivers/media/i2c/s5k6aa.c
> +++ b/drivers/media/i2c/s5k6aa.c
> @@ -1577,7 +1577,7 @@ static int s5k6aa_probe(struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	s5k6aa->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &s5k6aa->pad, 0);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 636ebd6fe5dc..78f2cdd3561b 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2763,7 +2763,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
>  
>  	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
>  
> -	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  
>  	/* final steps */
>  	smiapp_read_frame_fmt(sensor);
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index a7aa2aac9c23..2e465ba087ba 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -51,13 +51,13 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_AV_DMA + 6)
>  #define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_AV_DMA + 7)
>  
> -#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	((2 << 16) + 1)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 1)
> -#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 2)
> +#define MEDIA_ENT_T_CAM_SENSOR	((2 << 16) + 1)
> +#define MEDIA_ENT_T_CAM_FLASH	(MEDIA_ENT_T_CAM_SENSOR + 1)
> +#define MEDIA_ENT_T_CAM_LENS	(MEDIA_ENT_T_CAM_SENSOR + 2)
>  /* A converter of analogue video to its digital representation. */
> -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 3)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
>  
> -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 4)
> +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
>  
>  #if 1
>  /*
> @@ -76,8 +76,10 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
>  #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
>  
> -
>  #define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
> +#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_T_CAM_SENSOR
> +#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_T_CAM_FLASH
> +#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_T_CAM_LENS
>  #endif
>  
>  /* Used bitmasks for media_entity_desc::flags */
> 
