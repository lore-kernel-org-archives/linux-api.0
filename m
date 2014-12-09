From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v5] media: platform: add VPFE capture driver support for
 AM437X
Date: Tue, 09 Dec 2014 12:13:20 +0100
Message-ID: <5486D950.6050108@xs4all.nl>
References: <1418077306-2493-1-git-send-email-prabhakar.csengg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418077306-2493-1-git-send-email-prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lad, Prabhakar" <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/08/14 23:21, Lad, Prabhakar wrote:
> From: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
> 
> This patch adds Video Processing Front End (VPFE) driver for
> AM437X family of devices
> Driver supports the following:
> - V4L2 API using MMAP buffer access based on videobuf2 api
> - Asynchronous sensor/decoder sub device registration
> - DT support
> 
> Signed-off-by: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
> Signed-off-by: Darren Etheridge <detheridge-l0cyMroinI0@public.gmane.org>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Changes for v5:
>  1: Fixed review comments pointed out by Hans, fixing race condition.
> 
>  v4l2-compliance output:

Thanks!

<snip>

>  ----------------------
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> new file mode 100644
> index 0000000..c2b29a2
> --- /dev/null
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> +/*
> + * vpfe_release : This function is based on the vb2_fop_release
> + * helper function.
> + * It has been augmented to handle module power management,
> + * by disabling/enabling h/w module fcntl clock when necessary.
> + */
> +static int vpfe_release(struct file *file)
> +{
> +	struct vpfe_device *vpfe = video_drvdata(file);
> +	bool close = v4l2_fh_is_singular_file(file);
> +	int ret;
> +
> +	vpfe_dbg(2, vpfe, "vpfe_release\n");
> +
> +	mutex_lock(&vpfe->lock);

The v4l2_fh_is_singular_file() call should be inside the lock as well.
So:

	close = v4l2_fh_is_singular_file(file);

> +
> +	ret = _vb2_fop_release(file, NULL);
> +	if (close)
> +		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +
> +	mutex_unlock(&vpfe->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * vpfe_open : This function is based on the v4l2_fh_open helper function.
> + * It has been augmented to handle module power management,
> + * by disabling/enabling h/w module fcntl clock when necessary.
> + */
> +static int vpfe_open(struct file *file)
> +{
> +	struct vpfe_device *vpfe = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_fh_open(file);

Same here, v4l2_fh_open should be inside the lock.

> +	if (ret) {
> +		vpfe_err(vpfe, "v4l2_fh_open failed\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&vpfe->lock);

So:

	ret = v4l2_fh_open(file);
	if (ret) {
		vpfe_err(vpfe, "v4l2_fh_open failed\n");
		goto unlock;
	}

	
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	if (vpfe_initialize_device(vpfe)) {
> +		v4l2_fh_release(file);
> +		ret = -ENODEV;
> +	}
> +
> +unlock:
> +	mutex_unlock(&vpfe->lock);
> +	return ret;
> +}

Regards,

	Hans
