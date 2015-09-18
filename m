From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v2 7/9] [media] v4l2: introduce v4l2_timeval
Date: Fri, 18 Sep 2015 10:05:06 +0200
Message-ID: <55FBC5B2.10808@xs4all.nl>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <1442524780-781677-8-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442524780-781677-8-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/17/15 23:19, Arnd Bergmann wrote:
> The v4l2 API uses a 'struct timeval' to communicate time stamps to user
> space. This is broken on 32-bit architectures as soon as we have a C library
> that defines time_t as 64 bit, which then changes the structure layout of
> struct v4l2_buffer.
> 
> Since existing user space source code relies on the type to be 'struct
> timeva' and we want to preserve compile-time compatibility when moving

s/timeva/timeval/

> to a new libc, we cannot make user-visible changes to the header file.
> 
> In this patch, we change the type of the timestamp to 'struct v4l2_timeval'

Don't we need a kernel-wide timeval64? Rather than adding a v4l2-specific
struct?

> as a preparation for a follow-up that adds API compatiblity for both
> 32-bit and 64-bit time_t. This patch should have no impact on generated
> code in either user space or kernel.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c      |  2 +-
>  drivers/media/pci/meye/meye.h              |  2 +-
>  drivers/media/pci/zoran/zoran.h            |  2 +-
>  drivers/media/platform/coda/coda.h         |  2 +-
>  drivers/media/platform/omap/omap_vout.c    |  4 ++--
>  drivers/media/platform/omap3isp/ispstat.c  |  3 ++-
>  drivers/media/platform/omap3isp/ispstat.h  |  2 +-
>  drivers/media/platform/vim2m.c             |  2 +-
>  drivers/media/platform/vivid/vivid-ctrls.c |  2 +-
>  drivers/media/usb/cpia2/cpia2.h            |  2 +-
>  drivers/media/usb/cpia2/cpia2_v4l.c        |  2 +-
>  drivers/media/usb/gspca/gspca.c            |  2 +-
>  drivers/media/usb/usbvision/usbvision.h    |  2 +-
>  drivers/media/v4l2-core/v4l2-common.c      |  6 +++---
>  include/media/v4l2-common.h                |  2 +-
>  include/media/videobuf-core.h              |  2 +-
>  include/trace/events/v4l2.h                | 12 ++++++++++--
>  include/uapi/linux/videodev2.h             | 17 +++++++++++++++++
>  18 files changed, 47 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 15a4ebc2844d..b0ed8d799c14 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3585,7 +3585,7 @@ static void
>  bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
>  		      struct bttv_buffer_set *curr, unsigned int state)
>  {
> -	struct timeval ts;
> +	struct v4l2_timeval ts;
>  
>  	v4l2_get_timestamp(&ts);
>  
> diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
> index 751be5e533c7..a06aa5ba9abc 100644
> --- a/drivers/media/pci/meye/meye.h
> +++ b/drivers/media/pci/meye/meye.h
> @@ -281,7 +281,7 @@
>  struct meye_grab_buffer {
>  	int state;			/* state of buffer */
>  	unsigned long size;		/* size of jpg frame */
> -	struct timeval timestamp;	/* timestamp */
> +	struct v4l2_timeval timestamp;	/* timestamp */
>  	unsigned long sequence;		/* sequence number */
>  };
>  
> diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
> index 4e7db8939c2b..9a9f782cede9 100644
> --- a/drivers/media/pci/zoran/zoran.h
> +++ b/drivers/media/pci/zoran/zoran.h
> @@ -39,7 +39,7 @@ struct zoran_sync {
>  	unsigned long frame;	/* number of buffer that has been free'd */
>  	unsigned long length;	/* number of code bytes in buffer (capture only) */
>  	unsigned long seq;	/* frame sequence number */
> -	struct timeval timestamp;	/* timestamp */
> +	struct v4l2_timeval timestamp;	/* timestamp */
>  };
>  
>  
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 59b2af9c7749..fa1e15a757cd 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -138,7 +138,7 @@ struct coda_buffer_meta {
>  	struct list_head	list;
>  	u32			sequence;
>  	struct v4l2_timecode	timecode;
> -	struct timeval		timestamp;
> +	struct v4l2_timeval	timestamp;
>  	u32			start;
>  	u32			end;
>  };
> diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
> index 70c28d19ea04..974a238a86fe 100644
> --- a/drivers/media/platform/omap/omap_vout.c
> +++ b/drivers/media/platform/omap/omap_vout.c
> @@ -513,7 +513,7 @@ static int omapvid_apply_changes(struct omap_vout_device *vout)
>  }
>  
>  static int omapvid_handle_interlace_display(struct omap_vout_device *vout,
> -		unsigned int irqstatus, struct timeval timevalue)
> +		unsigned int irqstatus, struct v4l2_timeval timevalue)
>  {
>  	u32 fid;
>  
> @@ -557,7 +557,7 @@ static void omap_vout_isr(void *arg, unsigned int irqstatus)
>  	int ret, fid, mgr_id;
>  	u32 addr, irq;
>  	struct omap_overlay *ovl;
> -	struct timeval timevalue;
> +	struct v4l2_timeval timevalue;
>  	struct omapvideo_info *ovid;
>  	struct omap_dss_device *cur_display;
>  	struct omap_vout_device *vout = (struct omap_vout_device *)arg;
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index 94d4c295d3d0..fa96e330c563 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -496,7 +496,8 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
>  		return PTR_ERR(buf);
>  	}
>  
> -	data->ts = buf->ts;
> +	data->ts.tv_sec = buf->ts.tv_sec;
> +	data->ts.tv_usec = buf->ts.tv_usec;
>  	data->config_counter = buf->config_counter;
>  	data->frame_number = buf->frame_number;
>  	data->buf_size = buf->buf_size;
> diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
> index 6d9b0244f320..7b4f136567a3 100644
> --- a/drivers/media/platform/omap3isp/ispstat.h
> +++ b/drivers/media/platform/omap3isp/ispstat.h
> @@ -39,7 +39,7 @@ struct ispstat_buffer {
>  	struct sg_table sgt;
>  	void *virt_addr;
>  	dma_addr_t dma_addr;
> -	struct timeval ts;
> +	struct v4l2_timeval ts;
>  	u32 buf_size;
>  	u32 frame_number;
>  	u16 config_counter;
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 295fde5fdb75..df5daac6d099 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -235,7 +235,7 @@ static int device_process(struct vim2m_ctx *ctx,
>  	in_vb->v4l2_buf.sequence = q_data->sequence++;
>  	memcpy(&out_vb->v4l2_buf.timestamp,
>  			&in_vb->v4l2_buf.timestamp,
> -			sizeof(struct timeval));
> +			sizeof(struct v4l2_timeval));
>  	if (in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
>  		memcpy(&out_vb->v4l2_buf.timecode, &in_vb->v4l2_buf.timecode,
>  			sizeof(struct v4l2_timecode));

See https://patchwork.linuxtv.org/patch/31405/

I'll merge that one for 4.4 very soon.

> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
> index 339c8b7e53c8..065f3d6c2409 100644
> --- a/drivers/media/platform/vivid/vivid-ctrls.c
> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
> @@ -935,7 +935,7 @@ static const struct v4l2_ctrl_config vivid_ctrl_has_scaler_out = {
>  static int vivid_streaming_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_streaming);
> -	struct timeval tv;
> +	struct v4l2_timeval tv;
>  
>  	switch (ctrl->id) {
>  	case VIVID_CID_DQBUF_ERROR:
> diff --git a/drivers/media/usb/cpia2/cpia2.h b/drivers/media/usb/cpia2/cpia2.h
> index cdef677d57ec..3e7c523784e7 100644
> --- a/drivers/media/usb/cpia2/cpia2.h
> +++ b/drivers/media/usb/cpia2/cpia2.h
> @@ -354,7 +354,7 @@ struct cpia2_sbuf {
>  };
>  
>  struct framebuf {
> -	struct timeval timestamp;
> +	struct v4l2_timeval timestamp;
>  	unsigned long seq;
>  	int num;
>  	int length;
> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
> index 9caea8344547..ce50d7ef4da7 100644
> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
> @@ -892,7 +892,7 @@ static int find_earliest_filled_buffer(struct camera_data *cam)
>  				found = i;
>  			} else {
>  				/* find which buffer is earlier */
> -				struct timeval *tv1, *tv2;
> +				struct v4l2_timeval *tv1, *tv2;
>  				tv1 = &cam->buffers[i].timestamp;
>  				tv2 = &cam->buffers[found].timestamp;
>  				if(tv1->tv_sec < tv2->tv_sec ||
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index af5cd8213e8b..c977937da9c4 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -1898,7 +1898,7 @@ static ssize_t dev_read(struct file *file, char __user *data,
>  	struct gspca_dev *gspca_dev = video_drvdata(file);
>  	struct gspca_frame *frame;
>  	struct v4l2_buffer v4l2_buf;
> -	struct timeval timestamp;
> +	struct v4l2_timeval timestamp;
>  	int n, ret, ret2;
>  
>  	PDEBUG(D_FRAM, "read (%zd)", count);
> diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
> index 4f2e4fde38f2..512de31613df 100644
> --- a/drivers/media/usb/usbvision/usbvision.h
> +++ b/drivers/media/usb/usbvision/usbvision.h
> @@ -320,7 +320,7 @@ struct usbvision_frame {
>  	long bytes_read;				/* amount of scanlength that has been read from data */
>  	struct usbvision_v4l2_format_st v4l2_format;	/* format the user needs*/
>  	int v4l2_linesize;				/* bytes for one videoline*/
> -	struct timeval timestamp;
> +	struct v4l2_timeval timestamp;
>  	int sequence;					/* How many video frames we send to user */
>  };
>  
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 5b808500e7e7..589fab615f21 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -396,11 +396,11 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
>  
> -void v4l2_get_timestamp(struct timeval *tv)
> +void v4l2_get_timestamp(struct v4l2_timeval *tv)
>  {
> -	struct timespec ts;
> +	struct timespec64 ts;
>  
> -	ktime_get_ts(&ts);
> +	ktime_get_ts64(&ts);
>  	tv->tv_sec = ts.tv_sec;
>  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>  }
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 1cc0c5ba16b3..6e77d889c3f8 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -187,6 +187,6 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>  		const struct v4l2_discrete_probe *probe,
>  		s32 width, s32 height);
>  
> -void v4l2_get_timestamp(struct timeval *tv);
> +void v4l2_get_timestamp(struct v4l2_timeval *tv);
>  
>  #endif /* V4L2_COMMON_H_ */
> diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
> index d760aa73ebbb..6381338a9588 100644
> --- a/include/media/videobuf-core.h
> +++ b/include/media/videobuf-core.h
> @@ -80,7 +80,7 @@ struct videobuf_buffer {
>  	struct list_head        queue;
>  	wait_queue_head_t       done;
>  	unsigned int            field_count;
> -	struct timeval          ts;
> +	struct v4l2_timeval     ts;
>  
>  	/* Memory type */
>  	enum v4l2_memory        memory;
> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index dbf017bfddd9..a88be48dc473 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -6,6 +6,14 @@
>  
>  #include <linux/tracepoint.h>
>  
> +#ifndef v4l2_timeval_to_ns
> +#define v4l2_timeval_to_ns v4l2_timeval_to_ns
> +static inline u64 v4l2_timeval_to_ns(struct v4l2_timeval *tv)
> +{
> +	return (u64)tv->tv_sec * NSEC_PER_SEC + tv->tv_usec * NSEC_PER_USEC;
> +}
> +#endif
> +
>  /* Enums require being exported to userspace, for user tool parsing */
>  #undef EM
>  #undef EMe
> @@ -126,7 +134,7 @@ DECLARE_EVENT_CLASS(v4l2_event_class,
>  		__entry->bytesused = buf->bytesused;
>  		__entry->flags = buf->flags;
>  		__entry->field = buf->field;
> -		__entry->timestamp = timeval_to_ns(&buf->timestamp);
> +		__entry->timestamp = v4l2_timeval_to_ns(&buf->timestamp);
>  		__entry->timecode_type = buf->timecode.type;
>  		__entry->timecode_flags = buf->timecode.flags;
>  		__entry->timecode_frames = buf->timecode.frames;
> @@ -211,7 +219,7 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>  		__entry->bytesused = vb->v4l2_planes[0].bytesused;
>  		__entry->flags = vb->v4l2_buf.flags;
>  		__entry->field = vb->v4l2_buf.field;
> -		__entry->timestamp = timeval_to_ns(&vb->v4l2_buf.timestamp);
> +		__entry->timestamp = v4l2_timeval_to_ns(&vb->v4l2_buf.timestamp);
>  		__entry->timecode_type = vb->v4l2_buf.timecode.type;
>  		__entry->timecode_flags = vb->v4l2_buf.timecode.flags;
>  		__entry->timecode_frames = vb->v4l2_buf.timecode.frames;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3e2c497c31fd..450b3249ba30 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -803,6 +803,19 @@ struct v4l2_plane {
>  	__u32			reserved[11];
>  };
>  
> +#ifdef __KERNEL__
> +/*
> + * This is used for the in-kernel version of v4l2_buffer, as we are
> + * migrating away from using time_t based structures in the kernel.
> + * User space might see this defined either using 32-bit or 64-bit
> + * time_t, so we have to convert it when accessing user data.
> + */
> +struct v4l2_timeval {
> +	long tv_sec;
> +	long tv_usec;
> +};
> +#endif
> +
>  /**
>   * struct v4l2_buffer - video buffer info
>   * @index:	id number of the buffer
> @@ -839,7 +852,11 @@ struct v4l2_buffer {
>  	__u32			bytesused;
>  	__u32			flags;
>  	__u32			field;
> +#ifdef __KERNEL__
> +	struct v4l2_timeval	timestamp;
> +#else
>  	struct timeval		timestamp;
> +#endif
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
>  
> 

Regards,

	Hans
