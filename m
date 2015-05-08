From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 06/18] media controller: rename analog TV decoder
Date: Fri, 08 May 2015 14:12:33 +0200
Message-ID: <554CA831.8070406@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com> <404817c5796244fe30bb29c883e7e9e07cf8e06c.1431046915.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <404817c5796244fe30bb29c883e7e9e07cf8e06c.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Lars-Peter Clausen <lars@metafoo.de>, Prabhakar Lad <prabhakar.csengg@gmail.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Joe Perches <joe@perches.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Axel Lin <axel.lin@ingics.com>, Matthias Schwarzott <zzam@gentoo.org>, Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>, Peter Senna Tschudin <peter.senna@gmail.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> To keep coherency, let's also remove V4L2_SUBDEV from the analog
> TV decoder, calling it by its function, and not by the V4L2
> API mapping.

Same issue as with patch 04/18.

	Hans

> 
> So,
> 
> 	MEDIA_ENT_T_V4L2_SUBDEV_DECODER -> MEDIA_ENT_T_ATV_DECODER
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 27082b07f4c2..9b3861058f0d 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -231,7 +231,7 @@
>  	    <entry>Lens controller</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_ATV_DECODER</constant></entry>
>  	    <entry>Video decoder, the basic function of the video decoder is to
>  	    accept analogue video from a wide variety of sources such as
>  	    broadcast, DVD players, cameras and video cassette recorders, in
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index a493c0b0b5fe..e8f0b53cc253 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -1212,7 +1212,7 @@ static int adv7180_probe(struct i2c_client *client,
>  		goto err_unregister_vpp_client;
>  
>  	state->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	sd->entity.flags |= MEDIA_ENT_T_ATV_DECODER;
>  	ret = media_entity_init(&sd->entity, 1, &state->pad, 0);
>  	if (ret)
>  		goto err_free_ctrl;
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index e15a789ad596..cd8a3c273ab8 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -5208,7 +5208,7 @@ static int cx25840_probe(struct i2c_client *client,
>  	state->pads[CX25840_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[CX25840_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
>  	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	sd->entity.type = MEDIA_ENT_T_ATV_DECODER;
>  
>  	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
>  				state->pads, 0);
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 24e47279e30c..77744c390941 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -1106,7 +1106,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> -	decoder->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	decoder->sd.entity.flags |= MEDIA_ENT_T_ATV_DECODER;
>  
>  	ret = media_entity_init(&decoder->sd.entity, 1, &decoder->pad, 0);
>  	if (ret < 0) {
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 05077cffd235..3facef49aef1 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -1019,7 +1019,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	device->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> -	device->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	device->sd.entity.flags |= MEDIA_ENT_T_ATV_DECODER;
>  
>  	error = media_entity_init(&device->sd.entity, 1, &device->pad, 0);
>  	if (error < 0)
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index fe00da105e77..a756f74f0adc 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -1216,7 +1216,7 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
>  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>  			tuner = entity;
>  			break;
> -		case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
> +		case MEDIA_ENT_T_ATV_DECODER:
>  			decoder = entity;
>  			break;
>  		}
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index af44f2d1c0a1..bed4ee28916d 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -119,7 +119,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
>  	 * this should be enough for the actual needs.
>  	 */
>  	media_device_for_each_entity(entity, mdev) {
> -		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> +		if (entity->type == MEDIA_ENT_T_ATV_DECODER) {
>  			decoder = entity;
>  			break;
>  		}
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 0de9912411c5..9b3d80e765f0 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -54,8 +54,8 @@ struct media_device_info {
>  #define MEDIA_ENT_T_CAM_SENSOR	((2 << 16) + 1)
>  #define MEDIA_ENT_T_CAM_FLASH	(MEDIA_ENT_T_CAM_SENSOR + 1)
>  #define MEDIA_ENT_T_CAM_LENS	(MEDIA_ENT_T_CAM_SENSOR + 2)
> -/* A converter of analogue video to its digital representation. */
> -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
> +
> +#define MEDIA_ENT_T_ATV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
>  
>  #define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
>  
> @@ -86,6 +86,8 @@ struct media_device_info {
>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_T_CAM_SENSOR
>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_T_CAM_FLASH
>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_T_CAM_LENS
> +
> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER MEDIA_ENT_T_ATV_DECODER
>  #endif
>  
>  /* Used bitmasks for media_entity_desc::flags */
> 

