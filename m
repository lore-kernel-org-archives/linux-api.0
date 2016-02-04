From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 13/22] media: au0828 video change to use
 v4l_enable_media_source()
Date: Thu, 4 Feb 2016 08:00:13 -0200
Message-ID: <20160204080013.0a2648ad@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<fe282e5160ee480d9b4d792a94c94549c54545cd.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe282e5160ee480d9b4d792a94c94549c54545cd.1454557589.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:45 -0700
Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> escreveu:

> Change au0828 to check if tuner is free or not
> before changing tuner configuration.
> 
> vidioc_g_tuner(), and au0828_v4l2_close() now call
> v4l-core interface v4l_enable_media_source() before
> changing tuner configuration.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 81952c8..8087215 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1006,8 +1006,12 @@ static int au0828_v4l2_close(struct file *filp)
>  		goto end;
>  
>  	if (dev->users == 1) {
> -		/* Save some power by putting tuner to sleep */
> -		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> +		/* Save some power by putting tuner to sleep, if it is free */
> +		/* What happens when radio is using tuner?? */
> +		ret = v4l_enable_media_source(vdev);
> +		if (ret == 0)
> +			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
> +					     s_power, 0);

Actually, for most USB devices (and this is the case of au0828), the
tuner can safely be disabled here if ALSA is not streaming, as, except
for some very old USB tuner models (like em28xx-based WinTV USB2) have
a separate audio output jack.

Btw, those devices that have a separate audio output jack have
analog tuners, like Philips FM1236. Those devices are always on, so
the s_power callback are silently ignored.

So, the best logic here would be to disable the tuner if:
	- ALSA is not streaming;
	- the last V4L2 file handler is closed.

Additionally, media source can be disabled if the above conditions
are met and if the device doesn't have a separate audio out plug
(or doesn't use a silicon tuner like xc2028/3028/4000/5000).

Of course, as ALSA may stream anytime, a callback would be needed to
enable the media source and power on the tuner, for radio to work.

I understand that the above would require some other non-trivial
changes, with would be best addressed on a separate patch series.

So, for now, I would add a FIXME there explaining the above.

>  		dev->std_set_in_tuner_core = 0;
>  
>  		/* When close the device, set the usb intf0 into alt0 to free
> @@ -1408,10 +1412,16 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
>  static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
> +	struct video_device *vfd = video_devdata(file);
> +	int ret;
>  
>  	if (t->index != 0)
>  		return -EINVAL;
>  
> +	ret = v4l_enable_media_source(vfd);
> +	if (ret)
> +		return ret;
> +
>  	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
