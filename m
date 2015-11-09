From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [PATCH v2 9/9] [media] omap3isp: support 64-bit version of omap3isp_stat_data
Date: Mon, 09 Nov 2015 22:09:26 +0200
Message-ID: <5733951.qvCn4pc5g5@avalon>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <1442524780-781677-10-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442524780-781677-10-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

Thank you for the patch.

On Thursday 17 September 2015 23:19:40 Arnd Bergmann wrote:
> C libraries with 64-bit time_t use an incompatible format for
> struct omap3isp_stat_data. This changes the kernel code to
> support either version, by moving over the normal handling
> to the 64-bit variant, and adding compatiblity code to handle
> the old binary format with the existing ioctl command code.
> 
> Fortunately, the command code includes the size of the structure,
> so the difference gets handled automatically.

We plan to design a new interface to handle statistics in V4L2. That API 
should support proper 64-bit timestamps out of the box, and will be 
implemented by the OMAP3 ISP driver. Userspace should then move to it. I 
wonder if it's worth it to fix the existing VIDIOC_OMAP3ISP_STAT_REQ ioctl 
given that I expect it to have a handful of users at most.

> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/media/platform/omap3isp/isph3a_aewb.c |  2 ++
>  drivers/media/platform/omap3isp/isph3a_af.c   |  2 ++
>  drivers/media/platform/omap3isp/isphist.c     |  2 ++
>  drivers/media/platform/omap3isp/ispstat.c     | 18 ++++++++++++++++--
>  drivers/media/platform/omap3isp/ispstat.h     |  2 ++
>  include/uapi/linux/omap3isp.h                 | 19 +++++++++++++++++++
>  6 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c
> b/drivers/media/platform/omap3isp/isph3a_aewb.c index
> ccaf92f39236..2d567725608f 100644
> --- a/drivers/media/platform/omap3isp/isph3a_aewb.c
> +++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
> @@ -250,6 +250,8 @@ static long h3a_aewb_ioctl(struct v4l2_subdev *sd,
> unsigned int cmd, void *arg) return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		unsigned long *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/isph3a_af.c
> b/drivers/media/platform/omap3isp/isph3a_af.c index
> 92937f7eecef..2ac02371318b 100644
> --- a/drivers/media/platform/omap3isp/isph3a_af.c
> +++ b/drivers/media/platform/omap3isp/isph3a_af.c
> @@ -314,6 +314,8 @@ static long h3a_af_ioctl(struct v4l2_subdev *sd,
> unsigned int cmd, void *arg) return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		int *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/isphist.c
> b/drivers/media/platform/omap3isp/isphist.c index
> 7138b043a4aa..669b97b079ee 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -436,6 +436,8 @@ static long hist_ioctl(struct v4l2_subdev *sd, unsigned
> int cmd, void *arg) return omap3isp_stat_config(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_REQ:
>  		return omap3isp_stat_request_statistics(stat, arg);
> +	case VIDIOC_OMAP3ISP_STAT_REQ_TIME32:
> +		return omap3isp_stat_request_statistics_time32(stat, arg);
>  	case VIDIOC_OMAP3ISP_STAT_EN: {
>  		int *en = arg;
>  		return omap3isp_stat_enable(stat, !!*en);
> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> b/drivers/media/platform/omap3isp/ispstat.c index
> fa96e330c563..3d70332422b5 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -496,8 +496,7 @@ int omap3isp_stat_request_statistics(struct ispstat
> *stat, return PTR_ERR(buf);
>  	}
> 
> -	data->ts.tv_sec = buf->ts.tv_sec;
> -	data->ts.tv_usec = buf->ts.tv_usec;
> +	data->ts = buf->ts;
>  	data->config_counter = buf->config_counter;
>  	data->frame_number = buf->frame_number;
>  	data->buf_size = buf->buf_size;
> @@ -509,6 +508,21 @@ int omap3isp_stat_request_statistics(struct ispstat
> *stat, return 0;
>  }
> 
> +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> +					struct omap3isp_stat_data_time32 *data)
> +{
> +	struct omap3isp_stat_data data64;
> +	int ret;
> +
> +	ret = omap3isp_stat_request_statistics(stat, &data64);
> +
> +	data->ts.tv_sec = data64.ts.tv_sec;
> +	data->ts.tv_usec = data64.ts.tv_usec;
> +	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
> +
> +	return ret;
> +}
> +
>  /*
>   * omap3isp_stat_config - Receives new statistic engine configuration.
>   * @new_conf: Pointer to config structure.
> diff --git a/drivers/media/platform/omap3isp/ispstat.h
> b/drivers/media/platform/omap3isp/ispstat.h index
> 7b4f136567a3..b19ea6c8f733 100644
> --- a/drivers/media/platform/omap3isp/ispstat.h
> +++ b/drivers/media/platform/omap3isp/ispstat.h
> @@ -130,6 +130,8 @@ struct ispstat_generic_config {
>  int omap3isp_stat_config(struct ispstat *stat, void *new_conf);
>  int omap3isp_stat_request_statistics(struct ispstat *stat,
>  				     struct omap3isp_stat_data *data);
> +int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> +				     struct omap3isp_stat_data_time32 *data);
>  int omap3isp_stat_init(struct ispstat *stat, const char *name,
>  		       const struct v4l2_subdev_ops *sd_ops);
>  void omap3isp_stat_cleanup(struct ispstat *stat);
> diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
> index c090cf9249bb..4bff66aefca5 100644
> --- a/include/uapi/linux/omap3isp.h
> +++ b/include/uapi/linux/omap3isp.h
> @@ -54,6 +54,8 @@
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct omap3isp_h3a_af_config)
>  #define VIDIOC_OMAP3ISP_STAT_REQ \
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data)
> +#define VIDIOC_OMAP3ISP_STAT_REQ_TIME32 \
> +	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct omap3isp_stat_data_time32)
>  #define VIDIOC_OMAP3ISP_STAT_EN \
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 7, unsigned long)
> 
> @@ -164,7 +166,11 @@ struct omap3isp_h3a_aewb_config {
>   * @config_counter: Number of the configuration associated with the data.
>   */
>  struct omap3isp_stat_data {
> +#ifdef __KERNEL__
> +	struct v4l2_timeval ts;
> +#else
>  	struct timeval ts;
> +#endif
>  	void __user *buf;
>  	__u32 buf_size;
>  	__u16 frame_number;
> @@ -172,6 +178,19 @@ struct omap3isp_stat_data {
>  	__u16 config_counter;
>  };
> 
> +#ifdef __KERNEL__
> +struct omap3isp_stat_data_time32 {
> +	struct {
> +		__s32	tv_sec;
> +		__s32	tv_usec;
> +	} ts;
> +	__u32 buf;
> +	__u32 buf_size;
> +	__u16 frame_number;
> +	__u16 cur_frame;
> +	__u16 config_counter;
> +};
> +#endif
> 
>  /* Histogram related structs */

-- 
Regards,

Laurent Pinchart
