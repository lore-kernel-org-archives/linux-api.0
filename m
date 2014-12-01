From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] media: platform: add VPFE capture driver support for AM437X
Date: Mon, 1 Dec 2014 22:17:01 +0000
Message-ID: <CA+V-a8vDGvSeSU9-EYx+U6j++WJWY7_59b2t9drqCCkPqR93mg@mail.gmail.com>
References: <1416791411-9731-1-git-send-email-prabhakar.csengg@gmail.com> <547C3ED3.1060205@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547C3ED3.1060205-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hans,

Thanks for the review.

On Mon, Dec 1, 2014 at 10:11 AM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
> Hi all,
>
> Thanks for the patch, review comments are below.
>
> For the next version I would appreciate if someone can test this driver with
> the latest v4l2-compliance from the v4l-utils git repo. If possible test streaming
> as well (v4l2-compliance -s), ideally with both a sensor and a STD receiver input.
> But that depends on the available hardware of course.
>
> I'd like to see the v4l2-compliance output. It's always good to have that on
> record.
>
Following is the compliance output, missed it post it along with patch:

root@am437x-evm:~# ./v4l2-compliance -s -i 0 -v
Driver Info:
        Driver name   : vpfe
        Card type     :[   70.363908] vpfe 48326000.vpfe:
=================  START STATUS  =================
 TI AM437x VPFE
        Bus info      : platform:vpfe [   70.375576] vpfe
48326000.vpfe: ==================  END STATUS  ==================
48326000.vpfe
        Driver version: 3.18.0
        Capabil[   70.388485] vpfe 48326000.vpfe: invalid input index: 1
ities  : 0x85200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
                test VIDIOC_QUERYCTRL: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                info: found 7 framesizes for pixel format 56595559
                info: found 7 framesizes for pixel format 59565955
                info: found 7 framesizes for pixel format 52424752
                info: found 7 framesizes for pixel format 31384142
                info: found 4 formats for buftype 1
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                info: Global format check succeeded for type 1
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                info: test buftype Video Capture
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Streaming ioctls:
        test read/write: OK
            Video Capture:
                Buffer: 0 Sequence: 0 Field: None Timestamp: 74.956437s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 74.979310s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.002191s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.208114s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.230998s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.253877s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.276756s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.299637s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.322517s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.345398s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.368279s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.391159s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.414039s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.436919s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.459800s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.482680s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.505560s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.528442s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.551322s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.574202s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.597082s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.619962s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.642842s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.665723s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.688603s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.711485s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.734364s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.757244s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.780126s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.803005s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.825885s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.848766s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.871648s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.894527s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 75.917407s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 75.940288s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 75.963168s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 75.986048s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.008926s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.031809s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.054691s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.077568s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.100451s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.123330s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.146210s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.169091s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.191970s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.214851s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.237732s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.260613s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.283493s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.306373s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.329253s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.352133s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.375014s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.397894s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.420776s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.443655s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.466535s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.489415s
            Video Capture (polling):
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.512295s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.535177s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.558057s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.580938s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.603818s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.626698s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.649578s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.672459s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.695339s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.718219s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.741102s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.763980s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.786860s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.809741s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.832621s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.855502s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.878382s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.901263s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 76.924143s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 76.947023s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 76.969903s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 76.992784s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.015664s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.038544s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.061427s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.084305s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.107185s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.130067s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.152946s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.175827s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.198707s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.221589s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.244468s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.267348s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.290229s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.313109s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.335989s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.358870s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.381750s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.404630s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.427510s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.450391s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.473271s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.496151s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.519032s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.541912s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.564793s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.587673s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.610554s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.633434s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.656314s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.679194s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.702075s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.724955s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.747836s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.770717s
                Buffer: 0 Sequence: 0 Field: None Timestamp: 77.793596s
                Buffer: 1 Sequence: 0 Field: None Timestamp: 77.816477s
                Buffer: 2 Sequence: 0 Field: None Timestamp: 77.839357s
                Buffer: 3 Sequence: 0 Field: None Timestamp: 77.862237s
        test MMAP: OK
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

Total: 42, Succeeded: 42, Failed: 0, Warnings: 0
>
[Snip]
>> +/*  Print Four-character-code (FOURCC) */
>> +static char *print_fourcc(u32 fmt)
>> +{
>> +     static char code[5];
>> +
>> +     code[0] = (unsigned char)(fmt & 0xff);
>> +     code[1] = (unsigned char)((fmt>>8) & 0xff);
>> +     code[2] = (unsigned char)((fmt>>16) & 0xff);
>> +     code[3] = (unsigned char)((fmt>>24) & 0xff);
>
> I prefer an extra space around '>>'
>
OK

>> +     code[4] = '\0';
[Snip]
>> +
>> +     if (ccdcparam->alaw.gamma_wd > VPFE_CCDC_GAMMA_BITS_09_0 ||
>> +         ccdcparam->alaw.gamma_wd < VPFE_CCDC_GAMMA_BITS_15_6 ||
>> +         max_gamma > max_data) {
>> +             vpfe_dbg(1, dev, "\nInvalid data line select");
>
> Newline at the start instead of at the end?
>
Fixed it.

>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int
>> +vpfe_ccdc_update_raw_params(struct vpfe_ccdc *ccdc,
>> +                         struct vpfe_ccdc_config_params_raw *raw_params)
>> +{
>> +     struct vpfe_ccdc_config_params_raw *config_params =
>> +                             &ccdc->ccdc_cfg.bayer.config_params;
>> +
>> +     memcpy(config_params, raw_params, sizeof(*raw_params));
>
> config_params = *raw_params;
>
>> +
>> +     return 0;
>
> Any reason why this can't be a void function?
>
Fixed it.

>> +}
>> +
>> +/*
>> + * vpfe_ccdc_restore_defaults()
>
> ditto
>
>> +                     vpfe_reg_write(ccdc, VPFE_INTERLACED_NO_IMAGE_INVERT,
>> +                                VPFE_SDOFST);
>> +             }
>> +     } else if (params->frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
>> +             vpfe_reg_write(ccdc, VPFE_PROGRESSIVE_NO_IMAGE_INVERT,
>> +                        VPFE_SDOFST);
>> +     }
>> +
>> +     vpfe_reg_write(ccdc, syn_mode, VPFE_SYNMODE);
>> +
>> +     vpfe_reg_dump(ccdc);
>> +}
>> +
>> +static inline int
>> +vpfe_ccdc_set_buftype(struct vpfe_ccdc *ccdc,
>> +                   enum ccdc_buftype buf_type)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             ccdc->ccdc_cfg.bayer.buf_type = buf_type;
>> +     else
>> +             ccdc->ccdc_cfg.ycbcr.buf_type = buf_type;
>> +
>> +     return 0;
>> +}
>> +
>> +static inline enum ccdc_buftype vpfe_ccdc_get_buftype(struct vpfe_ccdc *ccdc)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             return ccdc->ccdc_cfg.bayer.buf_type;
>> +
>> +     return ccdc->ccdc_cfg.ycbcr.buf_type;
>> +}
>> +
>> +static int vpfe_ccdc_set_pixel_format(struct vpfe_ccdc *ccdc, u32 pixfmt)
>> +{
>> +     struct vpfe_device *dev = container_of(ccdc, struct vpfe_device, ccdc);
>> +
>> +     vpfe_dbg(1, dev, "vpfe_ccdc_set_pixel_format: if_type: %d, pixfmt:%s\n",
>> +              ccdc->ccdc_cfg.if_type, print_fourcc(pixfmt));
>> +
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>> +             ccdc->ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
>> +             /*
>> +              * Need to clear it in case it was left on
>> +              * after the last capture.
>> +              */
>> +             ccdc->ccdc_cfg.bayer.config_params.alaw.enable = 0;
>> +
>> +             switch (pixfmt) {
>> +             case V4L2_PIX_FMT_SBGGR8:
>> +                     ccdc->ccdc_cfg.bayer.config_params.alaw.enable = 1;
>> +                     break;
>> +             case V4L2_PIX_FMT_YUYV:
>> +             case V4L2_PIX_FMT_UYVY:
>> +             case V4L2_PIX_FMT_YUV420:
>> +             case V4L2_PIX_FMT_NV12:
>> +             case V4L2_PIX_FMT_RGB565X:
>> +                     break; /* nothing for now */
>> +             case V4L2_PIX_FMT_SBGGR16:
>> +             default:
>> +                     return -EINVAL;
>> +             }
>> +     } else {
>> +             switch (pixfmt) {
>> +             case V4L2_PIX_FMT_YUYV:
>> +                     ccdc->ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
>> +                     break;
>> +             case V4L2_PIX_FMT_UYVY:
>> +                     ccdc->ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
>> +                     break;
>> +             default:
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static u32 vpfe_ccdc_get_pixel_format(struct vpfe_ccdc *ccdc)
>> +{
>> +     u32 pixfmt;
>> +
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>> +             pixfmt = V4L2_PIX_FMT_YUYV;
>> +     } else {
>> +             if (ccdc->ccdc_cfg.ycbcr.pix_order == CCDC_PIXORDER_YCBYCR)
>> +                     pixfmt = V4L2_PIX_FMT_YUYV;
>> +             else
>> +                     pixfmt = V4L2_PIX_FMT_UYVY;
>> +     }
>> +
>> +     return pixfmt;
>> +}
>> +
>> +static int
>> +vpfe_ccdc_set_image_window(struct vpfe_ccdc *ccdc,
>> +                        struct v4l2_rect *win, unsigned int bpp)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>> +             ccdc->ccdc_cfg.bayer.win = *win;
>> +             ccdc->ccdc_cfg.bayer.bytesperpixel = bpp;
>> +             ccdc->ccdc_cfg.bayer.bytesperline = ALIGN(win->width * bpp, 32);
>> +     } else {
>> +             ccdc->ccdc_cfg.ycbcr.win = *win;
>> +             ccdc->ccdc_cfg.ycbcr.bytesperpixel = bpp;
>> +             ccdc->ccdc_cfg.ycbcr.bytesperline = ALIGN(win->width * bpp, 32);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static inline void
>> +vpfe_ccdc_get_image_window(struct vpfe_ccdc *ccdc,
>> +                        struct v4l2_rect *win)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             *win = ccdc->ccdc_cfg.bayer.win;
>> +     else
>> +             *win = ccdc->ccdc_cfg.ycbcr.win;
>> +}
>> +
>> +static inline unsigned int vpfe_ccdc_get_line_length(struct vpfe_ccdc *ccdc)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             return ccdc->ccdc_cfg.bayer.bytesperline;
>> +
>> +     return ccdc->ccdc_cfg.ycbcr.bytesperline;
>> +}
>> +
>> +static inline int
>> +vpfe_ccdc_set_frame_format(struct vpfe_ccdc *ccdc,
>> +                        enum ccdc_frmfmt frm_fmt)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             ccdc->ccdc_cfg.bayer.frm_fmt = frm_fmt;
>> +     else
>> +             ccdc->ccdc_cfg.ycbcr.frm_fmt = frm_fmt;
>> +
>> +     return 0;
>> +}
>> +
>> +static inline enum ccdc_frmfmt
>> +vpfe_ccdc_get_frame_format(struct vpfe_ccdc *ccdc)
>> +{
>> +     if (ccdc->ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             return ccdc->ccdc_cfg.bayer.frm_fmt;
>> +
>> +     return ccdc->ccdc_cfg.ycbcr.frm_fmt;
>> +}
>> +
>> +static inline int vpfe_ccdc_getfid(struct vpfe_ccdc *ccdc)
>> +{
>> +     return (vpfe_reg_read(ccdc, VPFE_SYNMODE) >> 15) & 1;
>> +}
>> +
>> +static inline void vpfe_set_sdr_addr(struct vpfe_ccdc *ccdc, unsigned long addr)
>> +{
>> +     vpfe_reg_write(ccdc, addr & 0xffffffe0, VPFE_SDR_ADDR);
>> +}
>> +
>> +static int vpfe_ccdc_set_hw_if_params(struct vpfe_ccdc *ccdc,
>> +                                   struct vpfe_hw_if_param *params)
>> +{
>> +     struct vpfe_device *vpfe = container_of(ccdc, struct vpfe_device, ccdc);
>> +
>> +     ccdc->ccdc_cfg.if_type = params->if_type;
>> +
>> +     switch (params->if_type) {
>> +     case VPFE_BT656:
>> +     case VPFE_YCBCR_SYNC_16:
>> +     case VPFE_YCBCR_SYNC_8:
>> +     case VPFE_BT656_10BIT:
>> +             ccdc->ccdc_cfg.ycbcr.vd_pol = params->vdpol;
>> +             ccdc->ccdc_cfg.ycbcr.hd_pol = params->hdpol;
>> +             break;
>> +     case VPFE_RAW_BAYER:
>> +             ccdc->ccdc_cfg.bayer.vd_pol = params->vdpol;
>> +             ccdc->ccdc_cfg.bayer.hd_pol = params->hdpol;
>> +             if (params->bus_width == 10)
>> +                     ccdc->ccdc_cfg.bayer.config_params.data_sz =
>> +                             VPFE_CCDC_DATA_10BITS;
>> +             else
>> +                     ccdc->ccdc_cfg.bayer.config_params.data_sz =
>> +                             VPFE_CCDC_DATA_8BITS;
>> +             vpfe_dbg(1, vpfe, "params.bus_width: %d\n",
>> +                     params->bus_width);
>> +             vpfe_dbg(1, vpfe, "config_params.data_sz: %d\n",
>> +                     ccdc->ccdc_cfg.bayer.config_params.data_sz);
>> +             break;
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void vpfe_clear_intr(struct vpfe_ccdc *ccdc, int vdint)
>> +{
>> +     unsigned int vpfe_int_status;
>> +
>> +     vpfe_int_status = vpfe_reg_read(ccdc, VPFE_IRQ_STS);
>> +
>> +     switch (vdint) {
>> +     /* VD0 interrupt */
>> +     case VPFE_VDINT0:
>> +             vpfe_int_status &= ~VPFE_VDINT0;
>> +             vpfe_int_status |= VPFE_VDINT0;
>> +             break;
>> +     /* VD1 interrupt */
>> +     case VPFE_VDINT1:
>> +             vpfe_int_status &= ~VPFE_VDINT1;
>> +             vpfe_int_status |= VPFE_VDINT1;
>> +             break;
>> +     /* VD2 interrupt */
>> +     case VPFE_VDINT2:
>> +             vpfe_int_status &= ~VPFE_VDINT2;
>> +             vpfe_int_status |= VPFE_VDINT2;
>> +             break;
>> +     /* Clear all interrupts */
>> +     default:
>> +             vpfe_int_status &= ~(VPFE_VDINT0 |
>> +                             VPFE_VDINT1 |
>> +                             VPFE_VDINT2);
>> +             vpfe_int_status |= (VPFE_VDINT0 |
>> +                             VPFE_VDINT1 |
>> +                             VPFE_VDINT2);
>> +             break;
>> +     }
>> +     /* Clear specific VDINT from the status register */
>> +     vpfe_reg_write(ccdc, vpfe_int_status, VPFE_IRQ_STS);
>> +
>> +     vpfe_int_status = vpfe_reg_read(ccdc, VPFE_IRQ_STS);
>> +
>> +     /* Acknowledge that we are done with all interrupts */
>> +     vpfe_reg_write(ccdc, 1, VPFE_IRQ_EOI);
>> +}
>> +
>> +static void vpfe_ccdc_config_defaults(struct vpfe_ccdc *ccdc)
>> +{
>> +     ccdc->ccdc_cfg.if_type = VPFE_RAW_BAYER;
>> +
>> +     ccdc->ccdc_cfg.ycbcr.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT;
>> +     ccdc->ccdc_cfg.ycbcr.frm_fmt = CCDC_FRMFMT_INTERLACED;
>> +     ccdc->ccdc_cfg.ycbcr.fid_pol = VPFE_PINPOL_POSITIVE;
>> +     ccdc->ccdc_cfg.ycbcr.vd_pol = VPFE_PINPOL_POSITIVE;
>> +     ccdc->ccdc_cfg.ycbcr.hd_pol = VPFE_PINPOL_POSITIVE;
>> +     ccdc->ccdc_cfg.ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
>> +     ccdc->ccdc_cfg.ycbcr.buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED;
>> +
>> +     ccdc->ccdc_cfg.ycbcr.win.left = 0;
>> +     ccdc->ccdc_cfg.ycbcr.win.top = 0;
>> +     ccdc->ccdc_cfg.ycbcr.win.width = 720;
>> +     ccdc->ccdc_cfg.ycbcr.win.height = 576;
>> +     ccdc->ccdc_cfg.ycbcr.bt656_enable = 1;
>> +
>> +     ccdc->ccdc_cfg.bayer.pix_fmt = CCDC_PIXFMT_RAW;
>> +     ccdc->ccdc_cfg.bayer.frm_fmt = CCDC_FRMFMT_PROGRESSIVE;
>> +     ccdc->ccdc_cfg.bayer.fid_pol = VPFE_PINPOL_POSITIVE;
>> +     ccdc->ccdc_cfg.bayer.vd_pol = VPFE_PINPOL_POSITIVE;
>> +     ccdc->ccdc_cfg.bayer.hd_pol = VPFE_PINPOL_POSITIVE;
>> +
>> +     ccdc->ccdc_cfg.bayer.win.left = 0;
>> +     ccdc->ccdc_cfg.bayer.win.top = 0;
>> +     ccdc->ccdc_cfg.bayer.win.width = 800;
>> +     ccdc->ccdc_cfg.bayer.win.height = 600;
>> +     ccdc->ccdc_cfg.bayer.config_params.data_sz = VPFE_CCDC_DATA_8BITS;
>> +     ccdc->ccdc_cfg.bayer.config_params.alaw.gamma_wd =
>> +                                             VPFE_CCDC_GAMMA_BITS_09_0;
>> +}
>> +
>> +/*
>> + * vpfe_get_ccdc_image_format - Get image parameters based on CCDC settings
>> + */
>> +static int vpfe_get_ccdc_image_format(struct vpfe_device *dev,
>> +                                   struct v4l2_format *f)
>> +{
>> +     struct v4l2_rect image_win;
>> +     enum ccdc_buftype buf_type;
>> +     enum ccdc_frmfmt frm_fmt;
>> +
>> +     memset(f, 0, sizeof(*f));
>> +     f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     vpfe_ccdc_get_image_window(&dev->ccdc, &image_win);
>> +     f->fmt.pix.width = image_win.width;
>> +     f->fmt.pix.height = image_win.height;
>> +     f->fmt.pix.bytesperline = vpfe_ccdc_get_line_length(&dev->ccdc);
>> +     f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
>> +                             f->fmt.pix.height;
>> +     buf_type = vpfe_ccdc_get_buftype(&dev->ccdc);
>> +     f->fmt.pix.pixelformat = vpfe_ccdc_get_pixel_format(&dev->ccdc);
>> +     frm_fmt = vpfe_ccdc_get_frame_format(&dev->ccdc);
>> +     if (frm_fmt == CCDC_FRMFMT_PROGRESSIVE) {
>> +             f->fmt.pix.field = V4L2_FIELD_NONE;
>> +     } else if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
>> +             if (buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED) {
>> +                     f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +              } else if (buf_type == CCDC_BUFTYPE_FLD_SEPARATED) {
>> +                     f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +             } else {
>> +                     vpfe_err(dev, "Invalid buf_type\n");
>> +                     return -EINVAL;
>> +             }
>> +     } else {
>> +             vpfe_err(dev, "Invalid frm_fmt\n");
>> +             return -EINVAL;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int vpfe_config_ccdc_image_format(struct vpfe_device *dev)
>> +{
>> +     enum ccdc_frmfmt frm_fmt = CCDC_FRMFMT_INTERLACED;
>> +     int ret = 0;
>> +
>> +     vpfe_dbg(2, dev, "vpfe_config_ccdc_image_format\n");
>> +
>> +     vpfe_dbg(1, dev, "pixelformat: %s\n",
>> +             print_fourcc(dev->fmt.fmt.pix.pixelformat));
>> +
>> +     if (vpfe_ccdc_set_pixel_format(
>> +                     &dev->ccdc,
>> +                     dev->fmt.fmt.pix.pixelformat) < 0) {
>> +             vpfe_err(dev,
>> +                     "couldn't set pix format in ccdc\n");
>> +             return -EINVAL;
>> +     }
>> +     /* configure the image window */
>> +     vpfe_ccdc_set_image_window(&dev->ccdc, &dev->crop, dev->bpp);
>> +
>> +     switch (dev->fmt.fmt.pix.field) {
>> +     case V4L2_FIELD_INTERLACED:
>> +             /* do nothing, since it is default */
>> +             ret = vpfe_ccdc_set_buftype(
>> +                             &dev->ccdc,
>> +                             CCDC_BUFTYPE_FLD_INTERLEAVED);
>> +             break;
>> +     case V4L2_FIELD_NONE:
>> +             frm_fmt = CCDC_FRMFMT_PROGRESSIVE;
>> +             /* buffer type only applicable for interlaced scan */
>> +             break;
>> +     case V4L2_FIELD_SEQ_TB:
>> +             ret = vpfe_ccdc_set_buftype(
>> +                             &dev->ccdc,
>> +                             CCDC_BUFTYPE_FLD_SEPARATED);
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* set the frame format */
>> +     if (!ret)
>> +             ret = vpfe_ccdc_set_frame_format(&dev->ccdc, frm_fmt);
>> +     return ret;
>> +}
>> +
>> +/*
>> + * vpfe_config_image_format()
>> + * For a given standard, this functions sets up the default
>> + * pix format & crop values in the vpfe device and ccdc.  It first
>> + * starts with defaults based values from the standard table.
>> + * It then checks if sub device support g_mbus_fmt and then override the
>> + * values based on that.Sets crop values to match with scan resolution
>> + * starting at 0,0. It calls vpfe_config_ccdc_image_format() set the
>> + * values in ccdc
>> + */
>> +static int vpfe_config_image_format(struct vpfe_device *dev,
>> +                                 v4l2_std_id std_id)
>> +{
>> +     struct v4l2_pix_format *pix = &dev->fmt.fmt.pix;
>> +     int i, ret;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
>> +             if (vpfe_standards[i].std_id & std_id) {
>> +                     dev->std_info.active_pixels =
>> +                                     vpfe_standards[i].width;
>> +                     dev->std_info.active_lines =
>> +                                     vpfe_standards[i].height;
>> +                     dev->std_info.frame_format =
>> +                                     vpfe_standards[i].frame_format;
>> +                     dev->std_index = i;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (i ==  ARRAY_SIZE(vpfe_standards)) {
>> +             vpfe_err(dev, "standard not supported\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     dev->crop.top = 0;
>> +     dev->crop.left = 0;
>> +     dev->crop.width = dev->std_info.active_pixels;
>> +     dev->crop.height = dev->std_info.active_lines;
>> +     pix->width = dev->crop.width;
>> +     pix->height = dev->crop.height;
>> +     pix->pixelformat = V4L2_PIX_FMT_YUYV;
>> +
>> +     /* first field and frame format based on standard frame format */
>> +     if (dev->std_info.frame_format)
>> +             pix->field = V4L2_FIELD_INTERLACED;
>> +     else
>> +             pix->field = V4L2_FIELD_NONE;
>> +
>> +     ret = __vpfe_get_format(dev, &dev->fmt, &dev->bpp);
>> +     if (ret)
>> +             return ret;
>> +
>> +     /* Update the crop window based on found values */
>> +     dev->crop.width = pix->width;
>> +     dev->crop.height = pix->height;
>> +
>> +     return vpfe_config_ccdc_image_format(dev);
>> +}
>> +
>> +static int vpfe_initialize_device(struct vpfe_device *vpfe)
>> +{
>> +     struct vpfe_subdev_info *sdinfo;
>> +     int ret;
>> +
>> +     sdinfo = &vpfe->cfg->sub_devs[0];
>> +     sdinfo->sd = vpfe->sd[0];
>> +     vpfe->current_input = 0;
>> +     vpfe->std_index = 0;
>> +     /* Configure the default format information */
>> +     ret = vpfe_config_image_format(vpfe,
>> +                                    vpfe_standards[vpfe->std_index].std_id);
>> +     if (ret)
>> +             return ret;
>> +
>> +     pm_runtime_get_sync(vpfe->pdev);
>> +
>> +     vpfe_config_enable(&vpfe->ccdc, 1);
>> +
>> +     vpfe_ccdc_restore_defaults(&vpfe->ccdc);
>> +
>> +     /* Clear all VPFE interrupts */
>> +     vpfe_clear_intr(&vpfe->ccdc, -1);
>> +
>> +     return ret;
>> +}
>> +
>> +/*
>> + * vpfe_release : This function is based on the vb2_fop_release
>> + * helper function.
>> + * It has been augmented to handle module power management,
>> + * by disabling/enabling h/w module fcntl clock when necessary.
>> + */
>> +static int vpfe_release(struct file *file)
>> +{
>> +     struct vpfe_device *dev = video_drvdata(file);
>> +     int ret;
>> +
>> +     vpfe_dbg(2, dev, "vpfe_release\n");
>> +
>> +     ret = _vb2_fop_release(file, NULL);
>> +
>> +     if (v4l2_fh_is_singular_file(file)) {
>> +             mutex_lock(&dev->lock);
>> +             vpfe_ccdc_close(&dev->ccdc, dev->pdev);
>> +             mutex_unlock(&dev->lock);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +/*
>> + * vpfe_open : This function is based on the v4l2_fh_open helper function.
>> + * It has been augmented to handle module power management,
>> + * by disabling/enabling h/w module fcntl clock when necessary.
>> + */
>> +
>> +static int vpfe_open(struct file *file)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +
>> +     v4l2_fh_open(file);
>
> Check error code!
>
>> +
>> +     if (!v4l2_fh_is_singular_file(file))
>> +             return 0;
>> +
>> +     mutex_lock(&vpfe->lock);
>> +     if (vpfe_initialize_device(vpfe)) {
>> +             mutex_unlock(&vpfe->lock);
>
> Call v4l2_fh_release(), otherwise you have a memory leak.
>
>> +             return -ENODEV;
>> +     }
>> +     mutex_unlock(&vpfe->lock);
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * vpfe_schedule_next_buffer: set next buffer address for capture
>> + * @vpfe : ptr to vpfe device
>> + *
>> + * This function will get next buffer from the dma queue and
>> + * set the buffer address in the vpfe register for capture.
>> + * the buffer is marked active
>> + *
>> + * Assumes caller is holding vpfe->dma_queue_lock already
>> + */
>> +static inline void vpfe_schedule_next_buffer(struct vpfe_device *vpfe)
>> +{
>> +     vpfe->next_frm = list_entry(vpfe->dma_queue.next,
>> +                                 struct vpfe_cap_buffer, list);
>> +     list_del(&vpfe->next_frm->list);
>> +
>> +     vpfe_set_sdr_addr(&vpfe->ccdc,
>> +                    vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0));
>> +}
>> +
>> +static inline void vpfe_schedule_bottom_field(struct vpfe_device *vpfe)
>> +{
>> +     unsigned long addr;
>> +
>> +     addr = vb2_dma_contig_plane_dma_addr(&vpfe->next_frm->vb, 0) +
>> +                     vpfe->field_off;
>> +
>> +     vpfe_set_sdr_addr(&vpfe->ccdc, addr);
>> +}
>> +
>> +/*
>> + * vpfe_process_buffer_complete: process a completed buffer
>> + * @vpfe : ptr to vpfe device
>> + *
>> + * This function time stamp the buffer and mark it as DONE. It also
>> + * wake up any process waiting on the QUEUE and set the next buffer
>> + * as current
>> + */
>> +static inline void vpfe_process_buffer_complete(struct vpfe_device *vpfe)
>> +{
>> +     v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
>> +     vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_DONE);
>> +     vpfe->cur_frm = vpfe->next_frm;
>> +}
>> +
>> +/*
>> + * vpfe_isr : ISR handler for vpfe capture (VINT0)
>> + * @irq: irq number
>> + * @dev_id: dev_id ptr
>> + *
>> + * It changes status of the captured buffer, takes next buffer from the queue
>> + * and sets its address in VPFE registers
>> + */
>> +static irqreturn_t vpfe_isr(int irq, void *dev)
>> +{
>> +     struct vpfe_device *vpfe = (struct vpfe_device *)dev;
>> +     enum v4l2_field field;
>> +     int intr_status;
>> +     int fid;
>> +
>> +     intr_status = vpfe_reg_read(&vpfe->ccdc, VPFE_IRQ_STS);
>> +
>> +     if (intr_status & VPFE_VDINT0) {
>> +             field = vpfe->fmt.fmt.pix.field;
>> +
>> +             if (field == V4L2_FIELD_NONE) {
>> +                     /* handle progressive frame capture */
>> +                     if (vpfe->cur_frm != vpfe->next_frm)
>> +                             vpfe_process_buffer_complete(vpfe);
>> +                     goto next_intr;
>> +             }
>> +
>> +             /* interlaced or TB capture check which field
>> +                we are in hardware */
>> +             fid = vpfe_ccdc_getfid(&vpfe->ccdc);
>> +
>> +             /* switch the software maintained field id */
>> +             vpfe->field_id ^= 1;
>> +             if (fid == vpfe->field_id) {
>> +                     /* we are in-sync here,continue */
>> +                     if (fid == 0) {
>> +                             /*
>> +                              * One frame is just being captured. If the
>> +                              * next frame is available, release the
>> +                              * current frame and move on
>> +                              */
>> +                             if (vpfe->cur_frm != vpfe->next_frm)
>> +                                     vpfe_process_buffer_complete(vpfe);
>> +                             /*
>> +                              * based on whether the two fields are stored
>> +                              * interleavely or separately in memory,
>> +                              * reconfigure the CCDC memory address
>> +                              */
>> +                             if (field == V4L2_FIELD_SEQ_TB)
>> +                                     vpfe_schedule_bottom_field(vpfe);
>> +
>> +                             goto next_intr;
>> +                     }
>> +                     /*
>> +                      * if one field is just being captured configure
>> +                      * the next frame get the next frame from the empty
>> +                      * queue if no frame is available hold on to the
>> +                      * current buffer
>> +                      */
>> +                     spin_lock(&vpfe->dma_queue_lock);
>> +                     if (!list_empty(&vpfe->dma_queue) &&
>> +                         vpfe->cur_frm == vpfe->next_frm)
>> +                             vpfe_schedule_next_buffer(vpfe);
>> +                     spin_unlock(&vpfe->dma_queue_lock);
>> +             } else if (fid == 0) {
>> +                     /*
>> +                      * out of sync. Recover from any hardware out-of-sync.
>> +                      * May loose one frame
>> +                      */
>> +                     vpfe->field_id = fid;
>> +             }
>> +     }
>> +
>> +next_intr:
>> +     if (intr_status & VPFE_VDINT1) {
>> +             spin_lock(&vpfe->dma_queue_lock);
>> +             if (vpfe->fmt.fmt.pix.field == V4L2_FIELD_NONE &&
>> +                 !list_empty(&vpfe->dma_queue) &&
>> +                 vpfe->cur_frm == vpfe->next_frm)
>> +                     vpfe_schedule_next_buffer(vpfe);
>> +             spin_unlock(&vpfe->dma_queue_lock);
>> +     }
>> +
>> +     vpfe_clear_intr(&vpfe->ccdc, intr_status);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static inline void vpfe_detach_irq(struct vpfe_device *vpfe)
>> +{
>> +     unsigned int intr = VPFE_VDINT0;
>> +     enum ccdc_frmfmt frame_format;
>> +
>> +     frame_format = vpfe_ccdc_get_frame_format(&vpfe->ccdc);
>> +     if (frame_format == CCDC_FRMFMT_PROGRESSIVE)
>> +             intr |= VPFE_VDINT1;
>> +
>> +     vpfe_reg_write(&vpfe->ccdc, intr, VPFE_IRQ_EN_CLR);
>> +}
>> +
>> +static inline void vpfe_attach_irq(struct vpfe_device *dev)
>> +{
>> +     unsigned int intr = VPFE_VDINT0;
>> +     enum ccdc_frmfmt frame_format;
>> +
>> +     frame_format = vpfe_ccdc_get_frame_format(&dev->ccdc);
>> +     if (frame_format == CCDC_FRMFMT_PROGRESSIVE)
>> +             intr |= VPFE_VDINT1;
>> +
>> +     vpfe_reg_write(&dev->ccdc, intr, VPFE_IRQ_EN_SET);
>> +}
>> +
>> +static int vpfe_querycap(struct file *file, void  *priv,
>> +                      struct v4l2_capability *cap)
>> +{
>> +     struct vpfe_device *dev = video_drvdata(file);
>> +
>> +     vpfe_dbg(2, dev, "vpfe_querycap\n");
>> +
>> +     strlcpy(cap->driver, VPFE_MODULE_NAME, sizeof(cap->driver));
>> +     strlcpy(cap->card, "TI AM437x VPFE", sizeof(cap->card));
>> +     snprintf(cap->bus_info, sizeof(cap->bus_info),
>> +                     "platform:%s", dev->v4l2_dev.name);
>> +     cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +                         V4L2_CAP_READWRITE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +     return 0;
>> +}
>> +
>> +/* get the format set at output pad of the adjacent subdev */
>> +static int __vpfe_get_format(struct vpfe_device *vpfe,
>> +                          struct v4l2_format *format, unsigned int *bpp)
>> +{
>> +     struct v4l2_mbus_framefmt mbus_fmt;
>> +     struct vpfe_subdev_info *sdinfo;
>> +     struct v4l2_subdev_format fmt;
>> +     int ret;
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (!sdinfo->sd)
>> +             return -EINVAL;
>> +
>> +     fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>> +     fmt.pad = 0;
>> +
>> +     ret = v4l2_subdev_call(sdinfo->sd, pad, get_fmt, NULL, &fmt);
>> +     if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> +             return ret;
>> +
>> +     if (!ret) {
>> +             v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
>> +             mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
>> +     } else {
>> +             ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
>> +                                              sdinfo->grp_id,
>> +                                              video, g_mbus_fmt,
>> +                                              &mbus_fmt);
>> +             if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> +                     return ret;
>> +             v4l2_fill_pix_format(&format->fmt.pix, &mbus_fmt);
>> +             mbus_to_pix(vpfe, &mbus_fmt, &format->fmt.pix, bpp);
>> +     }
>> +
>> +     format->type = vpfe->fmt.type;
>> +
>> +     vpfe_dbg(1, vpfe, "__vpfe_get_format size %dx%d (%s) bytesperline = %d, sizeimage = %d, bpp = %d\n",
>> +             format->fmt.pix.width, format->fmt.pix.height,
>> +             print_fourcc(format->fmt.pix.pixelformat),
>> +             format->fmt.pix.bytesperline, format->fmt.pix.sizeimage, *bpp);
>> +
>> +     return 0;
>> +}
>> +
>> +/* set the format at output pad of the adjacent subdev */
>> +static int __vpfe_set_format(struct vpfe_device *vpfe,
>> +                          struct v4l2_format *format, unsigned int *bpp)
>> +{
>> +     struct vpfe_subdev_info *sdinfo;
>> +     struct v4l2_subdev_format fmt;
>> +     int ret;
>> +
>> +     vpfe_dbg(2, vpfe, "__vpfe_set_format\n");
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (!sdinfo->sd)
>> +             return -EINVAL;
>> +
>> +     fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>> +     fmt.pad = 0;
>> +
>> +     ret = pix_to_mbus(vpfe, &format->fmt.pix, &fmt.format);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = v4l2_subdev_call(sdinfo->sd, pad, set_fmt, NULL, &fmt);
>> +     if (ret == -ENOIOCTLCMD)
>> +             return -EINVAL;
>> +
>> +     format->type = vpfe->fmt.type;
>> +
>> +     /* convert mbus_format to v4l2_format */
>> +     v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
>> +     mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
>> +     vpfe_dbg(1, vpfe, "__vpfe_set_format size %dx%d (%s) bytesperline = %d, sizeimage = %d, bpp = %d\n",
>> +             format->fmt.pix.width, format->fmt.pix.height,
>> +             print_fourcc(format->fmt.pix.pixelformat),
>> +             format->fmt.pix.bytesperline, format->fmt.pix.sizeimage, *bpp);
>> +
>> +     return 0;
>> +}
>> +
>> +static int vpfe_g_fmt(struct file *file, void *priv,
>> +                   struct v4l2_format *fmt)
>> +{
>> +     struct vpfe_device *dev = video_drvdata(file);
>> +     struct v4l2_format format;
>> +     unsigned int bpp;
>> +     int ret = 0;
>> +
>> +     vpfe_dbg(2, dev, "vpfe_g_fmt\n");
>> +
>> +     ret = __vpfe_get_format(dev, &format, &bpp);
>> +     if (ret)
>> +             return ret;
>
> Why do this?
>
>> +
>> +     /* Fill in the information about format */
>> +     *fmt = dev->fmt;
>
> If you are always going to fill in the info from dev->fmt?
>
>> +
>> +     return ret;
>> +}
>> +
>> +static int vpfe_enum_fmt(struct file *file, void  *priv,
>> +                      struct v4l2_fmtdesc *f)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     struct v4l2_subdev_mbus_code_enum mbus_code;
>> +     struct vpfe_subdev_info *sdinfo;
>> +     struct vpfe_fmt *fmt;
>> +     int ret;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_enum_format index:%d\n",
>> +             f->index);
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (!sdinfo->sd)
>> +             return -EINVAL;
>> +
>> +     mbus_code.index = f->index;
>> +     ret = v4l2_subdev_call(sdinfo->sd, pad, enum_mbus_code,
>> +                            NULL, &mbus_code);
>> +     if (ret)
>> +             return -EINVAL;
>> +
>> +     /* convert mbus_format to v4l2_format */
>> +     fmt = find_format_by_code(mbus_code.code);
>> +     if (!fmt) {
>> +             vpfe_err(vpfe, "mbus code 0x%08x not found\n",
>> +                     mbus_code.code);
>> +             return -EINVAL;
>> +     }
>
> Hmm. If a subdev supports more media bus codes then are supported by this
> driver, then the enumeration will stop as soon as such an unsupported code
> is found.
>
> What you want to do here is enumerate over the pixelformats that are supported
> by both this driver and the subdev. It is probably something you want to
> determine at the time the subdev is loaded and just mark unsupported formats
> at that time so that they can be skipped here.
>
So probably populate the supported pixelformats in s_input call ,
by calling enm_mbus_code ?

>> +
>> +     strncpy(f->description, fmt->name, sizeof(f->description) - 1);
>> +     f->pixelformat = fmt->fourcc;
>> +     f->type = vpfe->fmt.type;
>> +
>> +     vpfe_dbg(1, vpfe, "vpfe_enum_format: mbus index: %d code: %x pixelformat: %s [%s]\n",
>> +             f->index, fmt->code, print_fourcc(fmt->fourcc), fmt->name);
>> +
>> +     return 0;
>> +}
>> +
>> +static int vpfe_s_fmt(struct file *file, void *priv,
>> +                   struct v4l2_format *fmt)
>> +{
>> +     struct vpfe_device *dev = video_drvdata(file);
>> +     struct vb2_queue *q = &dev->buffer_queue;
>> +     struct v4l2_format format;
>> +     unsigned int bpp;
>> +     int ret = 0;
>> +
>> +     vpfe_dbg(2, dev, "vpfe_s_fmt\n");
>> +
>> +     /* Check for valid frame format */
>> +     ret = __vpfe_get_format(dev, &format, &bpp);
>> +     if (ret)
>> +             return ret;
>
> Usually s_fmt calls try_fmt first. I recommend doing that here as well.
>
OK

>> +
>> +     /* If streaming is started, return error */
>> +     if (vb2_is_busy(q)) {
>> +             vpfe_err(dev, "%s device busy\n", __func__);
>> +             return -EBUSY;
>> +     }
>> +
>> +     if (!cmp_v4l2_format(fmt, &format)) {
>> +             /* Sensor format is different from the requested format
>> +              * so we need to change it
>> +              */
>> +             ret = __vpfe_set_format(dev, fmt, &bpp);
>> +             if (ret)
>> +                     return ret;
>> +     } else /* Just make sure all of the fields are consistent */
>> +             *fmt = format;
>> +
>> +     fmt->fmt.pix.priv = 0;
>
> No longer needed, remove it.
>
OK

>> +
>> +     /* First detach any IRQ if currently attached */
>> +     vpfe_detach_irq(dev);
>> +     dev->fmt = *fmt;
>> +     dev->bpp = bpp;
>> +
>> +     /* Update the crop window based on found values */
>> +     dev->crop.width = fmt->fmt.pix.width;
>> +     dev->crop.height = fmt->fmt.pix.height;
>> +
>> +     /* set image capture parameters in the ccdc */
>> +     return vpfe_config_ccdc_image_format(dev);
>> +}
>> +
>> +static int vpfe_try_fmt(struct file *file, void *priv,
>> +                     struct v4l2_format *fmt)
>> +{
>> +     struct vpfe_device *dev = video_drvdata(file);
>> +     struct v4l2_format format;
>> +     unsigned int bpp;
>> +     int ret = 0;
>> +
>> +     vpfe_dbg(2, dev, "vpfe_try_fmt\n");
>> +
>> +     memset(&format, 0x00, sizeof(format));
>> +     ret = __vpfe_get_format(dev, &format, &bpp);
>
> Why not use fmt as __vpfe_get_format argument? That way there is no
> need for the local format variable.
>
> Also, this works fine for a sensor which has a fixed format, but what
> about a video receiver? You might want to switch the format from e.g.
> PAL to NTSC resolution, but this code will always return the current
> format.
>
Currently the driver is intended to support sensor only.

>> +     if (ret)
>> +             return ret;
>> +
>> +     *fmt = format;
>> +     fmt->fmt.pix.priv = 0;
>
> Remove this.
>
Ok

>> +
>> +     return 0;
>> +}
>> +
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
>> +     memset(fsize->reserved, 0x00, sizeof(fsize->reserved));
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (!sdinfo->sd)
>> +             return -EINVAL;
>> +
>> +     /* Construct pix from parameter and use default for the rest */
>> +     pix.pixelformat = fsize->pixel_format;
>> +     pix.width = 640;
>> +     pix.height = 480;
>> +     pix.colorspace = V4L2_COLORSPACE_JPEG;
>
> I would probably choose COLORSPACE_SRGB here, as that's most common for sensors.
>
OK

>> +
[snip]
>> +     if (sdinfo->inputs[0].capabilities != V4L2_IN_CAP_STD)
>
> Use '&'. Please check the code if this is used elsewhere as well.
>
>> +             return -ENODATA;
>
> Do this check before the vb2_is_busy check.
>
OK

>> +
>> +     ret = v4l2_device_call_until_err(&vpfe->v4l2_dev, sdinfo->grp_id,
>> +                                      video, s_std, std_id);
>> +     if (ret < 0) {
>> +             vpfe_err(vpfe, "Failed to set standard\n");
>> +             return ret;
>> +     }
>> +     ret = vpfe_config_image_format(vpfe, std_id);
>> +
>> +     return ret;
>> +}
>> +
>> +static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     struct vpfe_subdev_info *sdinfo;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_g_std\n");
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     if (sdinfo->inputs[0].capabilities != V4L2_IN_CAP_STD)
>> +             return -ENODATA;
>> +
>> +     *std_id = vpfe_standards[vpfe->std_index].std_id;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * vpfe_calculate_offsets : This function calculates buffers offset
>> + * for top and bottom field
>> + */
>> +static void vpfe_calculate_offsets(struct vpfe_device *vpfe)
>> +{
>> +     struct v4l2_rect image_win;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_calculate_offsets\n");
>> +
>> +     vpfe_ccdc_get_image_window(&vpfe->ccdc, &image_win);
>> +     vpfe->field_off = image_win.height * image_win.width;
>> +}
>> +
>> +/*
>> + * vpfe_queue_setup - Callback function for buffer setup.
>> + * @vq: vb2_queue ptr
>> + * @fmt: v4l2 format
>> + * @nbuffers: ptr to number of buffers requested by application
>> + * @nplanes:: contains number of distinct video planes needed to hold a frame
>> + * @sizes[]: contains the size (in bytes) of each plane.
>> + * @alloc_ctxs: ptr to allocation context
>> + *
>> + * This callback function is called when reqbuf() is called to adjust
>> + * the buffer count and buffer size
>> + */
>> +static int vpfe_queue_setup(struct vb2_queue *vq,
>> +                         const struct v4l2_format *fmt,
>> +                         unsigned int *nbuffers, unsigned int *nplanes,
>> +                         unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +     struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
>> +
>> +     if (fmt && fmt->fmt.pix.sizeimage < vpfe->fmt.fmt.pix.sizeimage)
>> +             return -EINVAL;
>> +
>> +     if (vq->num_buffers + *nbuffers < 3)
>> +             *nbuffers = 3 - vq->num_buffers;
>> +
>> +     *nplanes = 1;
>> +     sizes[0] = fmt ? fmt->fmt.pix.sizeimage : vpfe->fmt.fmt.pix.sizeimage;
>> +     alloc_ctxs[0] = vpfe->alloc_ctx;
>> +
>> +     vpfe_dbg(1, vpfe,
>> +             "nbuffers=%d, size=%u\n", *nbuffers, sizes[0]);
>> +
>> +     /* Calculate field offset */
>> +     vpfe_calculate_offsets(vpfe);
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * vpfe_buffer_prepare :  callback function for buffer prepare
>> + * @vb: ptr to vb2_buffer
>> + *
>> + * This is the callback function for buffer prepare when vb2_qbuf()
>> + * function is called. The buffer is prepared and user space virtual address
>> + * or user address is converted into  physical address
>> + */
>> +static int vpfe_buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
>> +
>> +     vb2_set_plane_payload(vb, 0, vpfe->fmt.fmt.pix.sizeimage);
>> +
>> +     if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
>> +             return -EINVAL;
>> +
>> +     vb->v4l2_buf.field = vpfe->fmt.fmt.pix.field;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * vpfe_buffer_queue : Callback function to add buffer to DMA queue
>> + * @vb: ptr to vb2_buffer
>> + */
>> +static void vpfe_buffer_queue(struct vb2_buffer *vb)
>> +{
>> +     struct vpfe_device *vpfe = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct vpfe_cap_buffer *buf = to_vpfe_buffer(vb);
>> +     unsigned long flags = 0;
>> +
>> +     /* add the buffer to the DMA queue */
>> +     spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
>> +     list_add_tail(&buf->list, &vpfe->dma_queue);
>> +     spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
>> +}
>> +
>> +/*
>> + * vpfe_start_streaming : Starts the DMA engine for streaming
>> + * @vb: ptr to vb2_buffer
>> + * @count: number of buffers
>> + */
>> +static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
>> +     struct vpfe_cap_buffer *buf, *tmp;
>> +     struct vpfe_subdev_info *sdinfo;
>> +     unsigned long addr = 0;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
>> +
>> +     vpfe->field_id = 0;
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     ret = v4l2_subdev_call(sdinfo->sd, video, s_stream, 1);
>> +     if (ret < 0) {
>> +             vpfe_err(vpfe, "Error in attaching interrupt handle\n");
>> +             goto err;
>> +     }
>> +
>> +     vpfe_attach_irq(vpfe);
>> +
>> +     if (vpfe->ccdc.ccdc_cfg.if_type == VPFE_RAW_BAYER)
>> +             vpfe_ccdc_config_raw(&vpfe->ccdc);
>> +     else
>> +             vpfe_ccdc_config_ycbcr(&vpfe->ccdc);
>> +
>> +     /* Get the next frame from the buffer queue */
>> +     vpfe->next_frm = list_entry(vpfe->dma_queue.next,
>> +                                 struct vpfe_cap_buffer, list);
>> +     vpfe->cur_frm = vpfe->next_frm;
>> +     /* Remove buffer from the buffer queue */
>> +     list_del(&vpfe->cur_frm->list);
>> +     spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
>> +
>> +     addr = vb2_dma_contig_plane_dma_addr(&vpfe->cur_frm->vb, 0);
>> +
>> +     v4l2_get_timestamp(&vpfe->cur_frm->vb.v4l2_buf.timestamp);
>
> That can't be right. You haven't captured the frame yet, so why set
> the timestamp now?
>
Dropped it not needed.

>> +
>> +     vpfe_set_sdr_addr(&vpfe->ccdc, (unsigned long)(addr));
>> +
>> +     vpfe_pcr_enable(&vpfe->ccdc, 1);
>> +
>> +     return 0;
>> +
>> +err:
>> +     list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
>> +     }
>> +     spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
>> +
>> +     return ret;
>> +}
>> +
>> +/*
>> + * vpfe_stop_streaming : Stop the DMA engine
>> + * @vq: ptr to vb2_queue
>> + *
>> + * This callback stops the DMA engine and any remaining buffers
>> + * in the DMA queue are released.
>> + */
>> +static void vpfe_stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct vpfe_device *vpfe = vb2_get_drv_priv(vq);
>> +     struct vpfe_subdev_info *sdinfo;
>> +     unsigned long flags;
>> +     int ret;
>> +
>> +     vpfe_pcr_enable(&vpfe->ccdc, 0);
>> +
>> +     vpfe_detach_irq(vpfe);
>> +
>> +     sdinfo = vpfe->current_subdev;
>> +     ret = v4l2_subdev_call(sdinfo->sd, video, s_stream, 0);
>> +     if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> +             vpfe_dbg(1, vpfe, "stream off failed in subdev\n");
>> +
>> +     /* release all active buffers */
>> +     spin_lock_irqsave(&vpfe->dma_queue_lock, flags);
>> +     if (vpfe->cur_frm == vpfe->next_frm) {
>> +             vb2_buffer_done(&vpfe->cur_frm->vb, VB2_BUF_STATE_ERROR);
>> +     } else {
>> +             if (vpfe->cur_frm != NULL)
>> +                     vb2_buffer_done(&vpfe->cur_frm->vb,
>> +                                     VB2_BUF_STATE_ERROR);
>> +             if (vpfe->next_frm != NULL)
>> +                     vb2_buffer_done(&vpfe->next_frm->vb,
>> +                                     VB2_BUF_STATE_ERROR);
>> +     }
>> +
>> +     while (!list_empty(&vpfe->dma_queue)) {
>> +             vpfe->next_frm = list_entry(vpfe->dma_queue.next,
>> +                                             struct vpfe_cap_buffer, list);
>> +             list_del(&vpfe->next_frm->list);
>> +             vb2_buffer_done(&vpfe->next_frm->vb, VB2_BUF_STATE_ERROR);
>> +     }
>> +     spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
>> +}
>> +
>> +static int vpfe_cropcap(struct file *file, void *priv,
>> +                     struct v4l2_cropcap *crop)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_cropcap\n");
>> +
>> +     if (vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
>> +             return -EINVAL;
>> +
>> +     memset(crop, 0, sizeof(struct v4l2_cropcap));
>> +
>> +     crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     crop->defrect.width = vpfe_standards[vpfe->std_index].width;
>> +     crop->bounds.width = crop->defrect.width;
>> +     crop->defrect.height = vpfe_standards[vpfe->std_index].height;
>> +     crop->bounds.height = crop->defrect.height;
>> +     crop->pixelaspect = vpfe_standards[vpfe->std_index].pixelaspect;
>> +
>> +     return 0;
>> +}
>> +
>> +static int
>> +vpfe_g_selection(struct file *file, void *fh, struct v4l2_selection *s)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             s->r.left = s->r.top = 0;
>> +             s->r.width = vpfe->crop.width;
>> +             s->r.height = vpfe->crop.height;
>> +             break;
>> +
>> +     case V4L2_SEL_TGT_COMPOSE:
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
>> +
>> +static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
>> +{
>> +     if (a->left < b->left || a->top < b->top)
>> +             return 0;
>> +
>> +     if (a->left + a->width > b->left + b->width)
>> +             return 0;
>> +
>> +     if (a->top + a->height > b->top + b->height)
>> +             return 0;
>> +
>> +     return 1;
>> +}
>> +
>> +static int
>> +vpfe_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     struct v4l2_rect cr = vpfe->crop;
>> +     struct v4l2_rect r = s->r;
>> +
>
> I would expect to see a vb2_is_busy check here.
>
> s->target isn't checked either.
>
Fixed it.

>> +     v4l_bound_align_image(&r.width, 0, cr.width, 0,
>> +                           &r.height, 0, cr.height, 0, 0);
>> +
>> +     r.left = clamp_t(unsigned int, r.left, 0, cr.width - r.width);
>> +     r.top  = clamp_t(unsigned int, r.top, 0, cr.height - r.height);
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_LE && !enclosed_rectangle(&r, &s->r))
>> +             return -ERANGE;
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_GE && !enclosed_rectangle(&s->r, &r))
>> +             return -ERANGE;
>> +
>> +     s->r = vpfe->crop = r;
>> +
>> +     vpfe_ccdc_set_image_window(&vpfe->ccdc, &r, vpfe->bpp);
>> +     vpfe->fmt.fmt.pix.width = r.width;
>> +     vpfe->fmt.fmt.pix.height = r.height;
>> +     vpfe->fmt.fmt.pix.bytesperline = vpfe_ccdc_get_line_length(&vpfe->ccdc);
>> +     vpfe->fmt.fmt.pix.sizeimage = vpfe->fmt.fmt.pix.bytesperline *
>> +                                             vpfe->fmt.fmt.pix.height;
>> +
>> +     vpfe_dbg(1, vpfe, "cropped (%d,%d)/%dx%d of %dx%d\n",
>> +              r.left, r.top, r.width, r.height, cr.width, cr.height);
>> +
>> +     return 0;
>> +}
>> +
>> +static long vpfe_ioctl_default(struct file *file, void *priv,
>> +                            bool valid_prio, unsigned int cmd, void *param)
>> +{
>> +     struct vpfe_device *vpfe = video_drvdata(file);
>> +     int ret;
>> +
>> +     vpfe_dbg(2, vpfe, "vpfe_ioctl_default\n");
>> +
>> +     if (!valid_prio) {
>> +             vpfe_err(vpfe, "%s device busy\n", __func__);
>> +             return -EBUSY;
>> +     }
>> +
>> +     /* If streaming is started, return error */
>> +     if (vb2_is_busy(&vpfe->buffer_queue)) {
>> +             vpfe_err(vpfe, "%s device busy\n", __func__);
>> +             return -EBUSY;
>> +     }
>> +
>> +     switch (cmd) {
>> +     case VIDIOC_AM437X_CCDC_CFG:
>> +             ret = vpfe_ccdc_set_params(&vpfe->ccdc, param);
>> +             if (ret) {
>> +                     vpfe_dbg(2, vpfe,
>> +                             "Error setting parameters in CCDC\n");
>> +                     return ret;
>> +             }
>> +             ret = vpfe_get_ccdc_image_format(vpfe,
>> +                                              &vpfe->fmt);
>> +             if (ret < 0) {
>> +                     vpfe_dbg(2, vpfe,
>> +                             "Invalid image format at CCDC\n");
>> +                     return ret;
>> +             }
>> +             break;
>> +     default:
>> +             ret = -ENOTTY;
>
> Add a 'break' here.
>
> Or just do 'return -ENOTTY;'
>
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static const struct vb2_ops vpfe_video_qops = {
>> +     .wait_prepare           = vb2_ops_wait_prepare,
>> +     .wait_finish            = vb2_ops_wait_finish,
>> +     .queue_setup            = vpfe_queue_setup,
>> +     .buf_prepare            = vpfe_buffer_prepare,
>> +     .buf_queue              = vpfe_buffer_queue,
>> +     .start_streaming        = vpfe_start_streaming,
>> +     .stop_streaming         = vpfe_stop_streaming,
>> +};
>> +
>> +/* vpfe capture driver file operations */
>> +static const struct v4l2_file_operations vpfe_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = vpfe_open,
>> +     .release        = vpfe_release,
>> +     .read           = vb2_fop_read,
>> +     .poll           = vb2_fop_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap           = vb2_fop_mmap,
>> +
>> +};
>> +
>> +/* vpfe capture ioctl operations */
>> +static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
>> +     .vidioc_querycap                = vpfe_querycap,
>> +     .vidioc_enum_fmt_vid_cap        = vpfe_enum_fmt,
>> +     .vidioc_g_fmt_vid_cap           = vpfe_g_fmt,
>> +     .vidioc_s_fmt_vid_cap           = vpfe_s_fmt,
>> +     .vidioc_try_fmt_vid_cap         = vpfe_try_fmt,
>> +
>> +     .vidioc_enum_framesizes         = vpfe_enum_size,
>> +
>> +     .vidioc_enum_input              = vpfe_enum_input,
>> +     .vidioc_g_input                 = vpfe_g_input,
>> +     .vidioc_s_input                 = vpfe_s_input,
>> +
>> +     .vidioc_querystd                = vpfe_querystd,
>> +     .vidioc_s_std                   = vpfe_s_std,
>> +     .vidioc_g_std                   = vpfe_g_std,
>> +
>> +     .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>> +     .vidioc_create_bufs             = vb2_ioctl_create_bufs,
>> +     .vidioc_prepare_buf             = vb2_ioctl_prepare_buf,
>> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
>> +     .vidioc_expbuf                  = vb2_ioctl_expbuf,
>> +     .vidioc_streamon                = vb2_ioctl_streamon,
>> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
>> +
>> +     .vidioc_log_status              = v4l2_ctrl_log_status,
>> +     .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>> +     .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>> +
>> +     .vidioc_cropcap                 = vpfe_cropcap,
>> +     .vidioc_g_selection             = vpfe_g_selection,
>> +     .vidioc_s_selection             = vpfe_s_selection,
>> +
>> +     .vidioc_default                 = vpfe_ioctl_default,
>> +};
>> +
>> +static const struct video_device vpfe_videodev = {
>> +     .name           = VPFE_MODULE_NAME,
>> +     .fops           = &vpfe_fops,
>> +     .ioctl_ops      = &vpfe_ioctl_ops,
>> +     .minor          = -1,
>> +     .release        = video_device_release,
>> +     .tvnorms        = 0,
>> +};
>> +
>> +static int
>> +vpfe_async_bound(struct v4l2_async_notifier *notifier,
>> +              struct v4l2_subdev *subdev,
>> +              struct v4l2_async_subdev *asd)
>> +{
>> +     struct vpfe_device *vpfe = container_of(notifier->v4l2_dev,
>> +                                            struct vpfe_device, v4l2_dev);
>> +     struct vpfe_subdev_info *sdinfo;
>> +     int i, j;
>> +
>> +     vpfe_dbg(1, vpfe, "vpfe_async_bound\n");
>> +
>> +     for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
>> +             sdinfo = &vpfe->cfg->sub_devs[i];
>> +
>> +             if (!strcmp(sdinfo->name, subdev->name)) {
>> +                     vpfe->sd[i] = subdev;
>> +                     vpfe_info(vpfe,
>> +                              "v4l2 sub device %s registered\n",
>> +                              subdev->name);
>> +                     vpfe->sd[i]->grp_id =
>> +                                     sdinfo->grp_id;
>> +                     /* update tvnorms from the sub devices */
>> +                     for (j = 0; j < 1; j++)
>> +                             vpfe->video_dev->tvnorms |=
>> +                                     sdinfo->inputs[j].std;
>> +                     return 0;
>> +             }
>> +     }
>> +
>> +     vpfe_info(vpfe, "vpfe_async_bound sub device (%s) not matched\n",
>> +              subdev->name);
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static int vpfe_probe_complete(struct vpfe_device *vpfe)
>> +{
>> +     struct video_device *vfd;
>> +     struct vb2_queue *q;
>> +     int err;
>> +
>> +     spin_lock_init(&vpfe->dma_queue_lock);
>> +     mutex_init(&vpfe->lock);
>> +
>> +     vpfe->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +
>> +     /* set first sub device as current one */
>> +     vpfe->current_subdev = &vpfe->cfg->sub_devs[0];
>> +     vpfe->v4l2_dev.ctrl_handler = vpfe->sd[0]->ctrl_handler;
>> +
>> +     /* Initialize videobuf2 queue as per the buffer type */
>> +     vpfe->alloc_ctx = vb2_dma_contig_init_ctx(vpfe->pdev);
>> +     if (IS_ERR(vpfe->alloc_ctx)) {
>> +             vpfe_err(vpfe, "Failed to get the context\n");
>> +             err = PTR_ERR(vpfe->alloc_ctx);
>> +             goto probe_out;
>> +     }
>> +
>> +     q = &vpfe->buffer_queue;
>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +     q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
>> +     q->drv_priv = vpfe;
>> +     q->ops = &vpfe_video_qops;
>> +     q->mem_ops = &vb2_dma_contig_memops;
>> +     q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
>> +     q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +     q->lock = &vpfe->lock;
>> +     q->min_buffers_needed = 1;
>> +
>> +     err = vb2_queue_init(q);
>> +     if (err) {
>> +             vpfe_err(vpfe, "vb2_queue_init() failed\n");
>> +             vb2_dma_contig_cleanup_ctx(vpfe->alloc_ctx);
>> +             goto probe_out;
>> +     }
>> +
>> +     INIT_LIST_HEAD(&vpfe->dma_queue);
>> +
>> +     vfd = vpfe->video_dev;
>> +     /* Pass on debug flag if it is high enough */
>> +     vfd->debug = (debug >= 4)?1:0;
>
> Don't set this. It can be enabled dynamically by 'echo 1 >/sys/class/video4linux/video0/debug'.
> Drivers shouldn't touch vfd->debug.
>
Dropped.

>> +     vfd->queue = q;
>> +
>> +     /*
>> +      * Provide a mutex to v4l2 core. It will be used to protect
>> +      * all fops and v4l2 ioctls.
>> +      */
>> +     vfd->lock = &vpfe->lock;
>> +     /* set video driver private data */
>> +     video_set_drvdata(vfd, vpfe);
>> +
>> +     /* select input 0 */
>> +     err = vpfe_set_input(vpfe, 0);
>> +     if (err)
>> +             goto probe_out;
>> +
>> +     err = video_register_device(vpfe->video_dev, VFL_TYPE_GRABBER, -1);
>> +     if (err) {
>> +             vpfe_err(vpfe,
>> +                     "Unable to register video device.\n");
>> +             goto probe_out;
>> +     }
>> +
>> +     return 0;
>> +
>> +probe_out:
>> +     v4l2_device_unregister(&vpfe->v4l2_dev);
>> +     return err;
>> +}
>> +
>> +static int vpfe_async_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +     struct vpfe_device *vpfe = container_of(notifier->v4l2_dev,
>> +                                     struct vpfe_device, v4l2_dev);
>> +
>> +     return vpfe_probe_complete(vpfe);
>> +}
>> +
>> +static struct vpfe_config *
>> +vpfe_get_pdata(struct platform_device *pdev)
>> +{
>> +     struct device_node *endpoint = NULL, *rem = NULL;
>> +     struct v4l2_of_endpoint bus_cfg;
>> +     struct vpfe_subdev_info *sdinfo;
>> +     struct vpfe_config *pdata;
>> +     unsigned int flags;
>> +     unsigned int i;
>> +     int err;
>> +
>> +     dev_dbg(&pdev->dev, "vpfe_get_pdata\n");
>> +
>> +     if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
>> +             return pdev->dev.platform_data;
>> +
>> +     pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata)
>> +             return NULL;
>> +
>> +     for (i = 0; ; i++) {
>> +             endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
>> +                                                   endpoint);
>> +             if (!endpoint)
>> +                     break;
>> +
>> +             sdinfo = &pdata->sub_devs[i];
>> +             sdinfo->grp_id = 0;
>> +
>> +             /* we only support camera */
>> +             sdinfo->inputs[0].index = i;
>> +             strcpy(sdinfo->inputs[0].name, "camera");
>
> Use 'Camera' (capital C)
>
OK fixed it.

>> +             sdinfo->inputs[0].type = V4L2_INPUT_TYPE_CAMERA;
>> +             sdinfo->inputs[0].std = V4L2_STD_ALL;
>> +             sdinfo->inputs[0].capabilities = V4L2_IN_CAP_STD;
>> +
>> +             sdinfo->can_route = 0;
>> +             sdinfo->routes = NULL;
>> +
>> +             of_property_read_u32(endpoint, "ti,am437x-vpfe-interface",
>> +                                  &sdinfo->vpfe_param.if_type);
>> +             if (sdinfo->vpfe_param.if_type < 0 ||
>> +                     sdinfo->vpfe_param.if_type > 4) {
>> +                     sdinfo->vpfe_param.if_type = VPFE_RAW_BAYER;
>> +             }
>> +
>> +             err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
>> +             if (err) {
>> +                     dev_err(&pdev->dev, "Could not parse the endpoint\n");
>> +                     goto done;
>> +             }
>> +
>> +             sdinfo->vpfe_param.bus_width = bus_cfg.bus.parallel.bus_width;
>> +
>> +             if (sdinfo->vpfe_param.bus_width < 8 ||
>> +                     sdinfo->vpfe_param.bus_width > 16) {
>> +                     dev_err(&pdev->dev, "Invalid bus width.\n");
>> +                     goto done;
>> +             }
>> +
>> +             flags = bus_cfg.bus.parallel.flags;
>> +
>> +             if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
>> +                     sdinfo->vpfe_param.hdpol = 1;
>> +
>> +             if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>> +                     sdinfo->vpfe_param.vdpol = 1;
>> +
>> +             rem = of_graph_get_remote_port_parent(endpoint);
>> +             if (!rem) {
>> +                     dev_err(&pdev->dev, "Remote device at %s not found\n",
>> +                             endpoint->full_name);
>> +                     goto done;
>> +             }
>> +
>> +             strncpy(sdinfo->name, rem->name, sizeof(sdinfo->name));
>> +
>> +             pdata->asd[i] = devm_kzalloc(&pdev->dev,
>> +                                          sizeof(struct v4l2_async_subdev),
>> +                                          GFP_KERNEL);
>> +             pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
>> +             pdata->asd[i]->match.of.node = rem;
>> +             of_node_put(endpoint);
>> +             of_node_put(rem);
>> +     }
>> +
>> +     of_node_put(endpoint);
>> +     return pdata;
>> +
>> +done:
>> +     of_node_put(endpoint);
>> +     of_node_put(rem);
>> +     return NULL;
>> +}
>> +
>> +/*
>> + * vpfe_probe : This function creates device entries by register
>> + * itself to the V4L2 driver and initializes fields of each
>> + * device objects
>> + */
>> +static int vpfe_probe(struct platform_device *pdev)
>> +{
>> +     struct vpfe_config *vpfe_cfg = vpfe_get_pdata(pdev);
>> +     struct video_device *vfd;
>> +     struct vpfe_device *vpfe;
>> +     struct vpfe_ccdc *ccdc;
>> +     struct resource *res;
>> +     int ret;
>> +
>> +     if (!vpfe_cfg) {
>> +             dev_err(&pdev->dev, "No platform data\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     vpfe = devm_kzalloc(&pdev->dev, sizeof(*vpfe), GFP_KERNEL);
>> +     if (!vpfe)
>> +             return -ENOMEM;
>> +
>> +     vpfe->pdev = &pdev->dev;
>> +     vpfe->cfg = vpfe_cfg;
>> +     ccdc = &vpfe->ccdc;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     ccdc->ccdc_cfg.base_addr = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(ccdc->ccdc_cfg.base_addr))
>> +             return PTR_ERR(ccdc->ccdc_cfg.base_addr);
>> +
>> +     vpfe->irq = platform_get_irq(pdev, 0);
>> +     if (vpfe->irq <= 0) {
>> +             dev_err(&pdev->dev, "No IRQ resource\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     ret = devm_request_irq(vpfe->pdev, vpfe->irq, vpfe_isr, 0,
>> +                            "vpfe_capture0", vpfe);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Unable to request interrupt\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     vfd = video_device_alloc();
>
> I recommend that struct video_device is embedded in struct vpfe_device.
> If nothing else, it avoids the !vfd check below.
>
OK

>> +     if (!vfd) {
>> +             dev_err(&pdev->dev, "Unable to alloc video device\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     /* Initialize field of video device */
>> +     *vfd = vpfe_videodev;
>> +
>> +     /* Set video_dev to the video device */
>> +     vpfe->video_dev = vfd;
>> +
>> +     ret = v4l2_device_register(&pdev->dev, &vpfe->v4l2_dev);
>> +     if (ret) {
>> +             vpfe_err(vpfe,
>> +                     "Unable to register v4l2 device.\n");
>> +             goto probe_out_video_release;
>> +     }
>> +
>> +     /* set the driver data in platform device */
>> +     platform_set_drvdata(pdev, vpfe);
>> +
>> +     vfd->v4l2_dev = &vpfe->v4l2_dev;
>> +
>> +     /* Enabling module functional clock */
>> +     pm_runtime_enable(&pdev->dev);
>> +
>> +     /* for now just enable it here instead of waiting for the open */
>> +     pm_runtime_get_sync(&pdev->dev);
>> +
>> +     vpfe_ccdc_config_defaults(ccdc);
>> +
>> +     pm_runtime_put_sync(&pdev->dev);
>> +
>> +     vpfe->sd = kmalloc(sizeof(struct v4l2_subdev *) *
>
> Wouldn't kzalloc be better?
>
OK.

Thanks,
--Prabhakar Lad
