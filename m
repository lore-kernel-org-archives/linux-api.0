From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] media: platform: add VPFE capture driver support for AM437X
Date: Fri, 5 Dec 2014 12:54:35 +0000
Message-ID: <CA+V-a8ui4Ur3Z7CwWXHf-xg101U=OJcMhOUxbqp4dWkcdF6U8Q@mail.gmail.com>
References: <1417648378-18271-1-git-send-email-prabhakar.csengg@gmail.com> <5481A3EC.8020803@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5481A3EC.8020803-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hans,

On Fri, Dec 5, 2014 at 12:24 PM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
> Hi Prabhakar,
>
> Sorry, there are still a few items that need to be fixed.
> If you can make a v4 with these issues addressed, then I can still make a
> pull request, although it depends on Mauro whether it is still accepted for
> 3.19.
>
OK will post a v4 tonight fixing all the below issues.

FYI: Looking at the response of Mauro on 'soc-camera: 1st set for 3.19'
he wont accept it!

Thanks,
--Prabhakar Lad

> On 12/04/2014 12:12 AM, Lad, Prabhakar wrote:
>> From: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
>>
>> This patch adds Video Processing Front End (VPFE) driver for
>> AM437X family of devices
>> Driver supports the following:
>> - V4L2 API using MMAP buffer access based on videobuf2 api
>> - Asynchronous sensor/decoder sub device registration
>> - DT support
>
> Just to confirm: this driver only supports SDTV formats? No HDTV?
> I didn't see any VIDIOC_*_DV_TIMINGS support, so I assume it really
> isn't supported.
>
>>
>> Signed-off-by: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
>> Signed-off-by: Darren Etheridge <detheridge-l0cyMroinI0@public.gmane.org>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>
> <snip>
>
>> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
>> new file mode 100644
>> index 0000000..25863e8
>> --- /dev/null
>> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
>
> <snip>
>
>> +
>> +static int
>> +cmp_v4l2_format(const struct v4l2_format *lhs, const struct v4l2_format *rhs)
>> +{
>> +     return lhs->type == rhs->type &&
>> +             lhs->fmt.pix.width == rhs->fmt.pix.width &&
>> +             lhs->fmt.pix.height == rhs->fmt.pix.height &&
>> +             lhs->fmt.pix.pixelformat == rhs->fmt.pix.pixelformat &&
>> +             lhs->fmt.pix.field == rhs->fmt.pix.field &&
>> +             lhs->fmt.pix.colorspace == rhs->fmt.pix.colorspace;
>
> Add a check for pix.ycbcr_enc and pix.quantization.
>
OK

> <snip>
>
>> +/*
>> + * vpfe_release : This function is based on the vb2_fop_release
>> + * helper function.
>> + * It has been augmented to handle module power management,
>> + * by disabling/enabling h/w module fcntl clock when necessary.
>> + */
>> +static int vpfe_release(struct file *file)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     int ret;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_release\n");
>> +
>> +     ret = _vb2_fop_release(file, NULL);
>
> This isn't going to work. _vb2_fop_release calls v4l2_fh_release(), so
> the v4l2_fh_is_singular_file(file) will be wrong and you release the fh
> once too many.
>
> I would do this:
>
>         if (!v4l2_fh_is_singular_file(file))
>                 return vb2_fop_release(file);
>         mutex_lock(&vpfe->lock);
>         ret = _vb2_fop_release(file, NULL);
>         vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
>         mutex_unlock(&vpfe->lock);
>         return ret;
>
>> +
>> +     if (v4l2_fh_is_singular_file(file)) {
>> +             mutex_lock(&vpfe->lock);
>> +             vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
>> +             v4l2_fh_release(file);
>> +             mutex_unlock(&vpfe->lock);
>> +     }
>> +
>> +     return ret;
>> +}
>
> <snip>
>
>> +static int vpfe_enum_size(struct file *file, void  *priv,
>> +                       struct v4l2_frmsizeenum *fsize)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     struct v4l2_subdev_frame_size_enum fse;
>> +     struct vpfe_subdev_info *sdinfo;
>> +     struct v4l2_mbus_framefmt mbus;
>> +     struct v4l2_pix_format pix;
>> +     struct vpfe_fmt *fmt;
>> +     int ret;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_enum_size\n");
>> +
>> +     /* check for valid format */
>> +     fmt = find_format_by_pix(fsize->pixel_format);
>> +     if (!fmt) {
>> +             vpfe_dbg(3, vpfe, "Invalid pixel code: %x, default used instead\n",
>> +                     fsize->pixel_format);
>> +             return -EINVAL;
>> +     }
>> +
>> +     memset(fsize->reserved, 0x0, sizeof(fsize->reserved));
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (!sdinfo->sd)
>> +             return -EINVAL;
>> +
>> +     memset(&pix, 0x0, sizeof(pix));
>> +     /* Construct pix from parameter and use default for the rest */
>> +     pix.pixelformat = fsize->pixel_format;
>> +     pix.width = 640;
>> +     pix.height = 480;
>> +     pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +     pix.field = V4L2_FIELD_NONE;
>> +     pix_to_mbus(vpfe, &pix, &mbus);
>> +
>> +     memset(&fse, 0x0, sizeof(fse));
>> +     fse.index = fsize->index;
>> +     fse.pad = 0;
>> +     fse.code = mbus.code;
>> +     ret = v4l2_subdev_call(sdinfo->sd, pad, enum_frame_size, NULL, &fse);
>
> FYI: strictly speaking this is wrong since this op theoretically expects a
> v4l2_subdev_fh pointer instead of a NULL argument. However, you do not have
> an alternative right now. As you know, I've been working on fixing this, so
> if that gets accepted, then you need to update this code as well in a later
> patch.
>
>> +     if (ret)
>> +             return -EINVAL;
>> +
>> +     vpfe_dbg(1, vpfe, "vpfe_enum_size: index: %d code: %x W:[%d,%d] H:[%d,%d]\n",
>> +             fse.index, fse.code, fse.min_width, fse.max_width,
>> +             fse.min_height, fse.max_height);
>> +
>> +     fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>> +     fsize->discrete.width = fse.max_width;
>> +     fsize->discrete.height = fse.max_height;
>> +
>> +     vpfe_dbg(1, vpfe, "vpfe_enum_size: index: %d pixformat: %s size: %dx%d\n",
>> +             fsize->index, print_fourcc(fsize->pixel_format),
>> +             fsize->discrete.width, fsize->discrete.height);
>> +
>> +     return 0;
>> +}
>> +
>
> <snip>
>
>> +static int
>> +vpfe_g_selection(struct file *file, void *fh, struct v4l2_selection *s)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>
> These two COMPOSE cases should be dropped, since there is no compose support!
>
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             s->r.left = s->r.top = 0;
>> +             s->r.width = vpfe->crop.width;
>> +             s->r.height = vpfe->crop.height;
>> +             break;
>> +
>> +     case V4L2_SEL_TGT_CROP:
>> +             s->r = vpfe->crop;
>> +             break;
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>
> <snip>
>
> Regards,
>
>         Hans
