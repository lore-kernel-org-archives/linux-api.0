From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] media: platform: add VPFE capture driver support for AM437X
Date: Tue, 2 Dec 2014 07:47:34 +0000
Message-ID: <CA+V-a8s1nX3TktixTvqzgzGfAFxmmV=ZTOTV_8LfEMsKy6mDnA@mail.gmail.com>
References: <1416791411-9731-1-git-send-email-prabhakar.csengg@gmail.com>
 <547C3ED3.1060205@xs4all.nl> <CA+V-a8vDGvSeSU9-EYx+U6j++WJWY7_59b2t9drqCCkPqR93mg@mail.gmail.com>
 <547D69C2.20503@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547D69C2.20503-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hans,

On Tue, Dec 2, 2014 at 7:26 AM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
> On 12/01/2014 11:17 PM, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> Thanks for the review.
>>
>> On Mon, Dec 1, 2014 at 10:11 AM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
>>> Hi all,
>>>
>>> Thanks for the patch, review comments are below.
>>>
>>> For the next version I would appreciate if someone can test this driver with
>>> the latest v4l2-compliance from the v4l-utils git repo. If possible test streaming
>>> as well (v4l2-compliance -s), ideally with both a sensor and a STD receiver input.
>>> But that depends on the available hardware of course.
>>>
>>> I'd like to see the v4l2-compliance output. It's always good to have that on
>>> record.
>>>
>> Following is the compliance output, missed it post it along with patch:
>>
>> root@am437x-evm:~# ./v4l2-compliance -s -i 0 -v
>> Driver Info:
>>         Driver name   : vpfe
>>         Card type     :[   70.363908] vpfe 48326000.vpfe:
>> =================  START STATUS  =================
>>  TI AM437x VPFE
>>         Bus info      : platform:vpfe [   70.375576] vpfe
>> 48326000.vpfe: ==================  END STATUS  ==================
>> 48326000.vpfe
>>         Driver version: 3.18.0
>>         Capabil[   70.388485] vpfe 48326000.vpfe: invalid input index: 1
>> ities  : 0x85200001
>>                 Video Capture
>>                 Read/Write
>>                 Streaming
>>                 Extended Pix Format
>>                 Device Capabilities
>>         Device Caps   : 0x05200001
>>                 Video Capture
>>                 Read/Write
>>                 Streaming
>>                 Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>         test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>         test second video open: OK
>>         test VIDIOC_QUERYCAP: OK
>>         test VIDIOC_G/S_PRIORITY: OK
>>
>> Debug ioctls:
>>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>         test VIDIOC_LOG_STATUS: OK
>>
>> Input ioctls:
>>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMINPUT: OK
>>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>         Inputs: 1 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Test input 0:
>>
>>         Control ioctls:
>>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>>                 test VIDIOC_QUERYCTRL: OK (Not Supported)
>>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>                 Standard Controls: 0 Private Controls: 0
>>
>>         Format ioctls:
>>                 info: found 7 framesizes for pixel format 56595559
>>                 info: found 7 framesizes for pixel format 59565955
>>                 info: found 7 framesizes for pixel format 52424752
>>                 info: found 7 framesizes for pixel format 31384142
>>                 info: found 4 formats for buftype 1
>>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>                 test VIDIOC_G/S_PARM: OK
>>                 test VIDIOC_G_FBUF: OK (Not Supported)
>>                 test VIDIOC_G_FMT: OK
>>                 test VIDIOC_TRY_FMT: OK
>>                 info: Global format check succeeded for type 1
>>                 test VIDIOC_S_FMT: OK
>>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>
>>         Codec ioctls:
>>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>>         Buffer ioctls:
>>                 info: test buftype Video Capture
>>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>                 test VIDIOC_EXPBUF: OK
>>
>> Streaming ioctls:
>>         test read/write: OK
>>             Video Capture:
>>                 Buffer: 0 Sequence: 0 Field: None Timestamp: 74.956437s
>>                 Buffer: 1 Sequence: 0 Field: None Timestamp: 74.979310s
>>                 Buffer: 2 Sequence: 0 Field: None Timestamp: 75.002191s
>>                 Buffer: 3 Sequence: 0 Field: None Timestamp: 75.208114s
>>                 Buffer: 0 Sequence: 0 Field: None Timestamp: 75.230998s
>
> Hmm, sequence is always 0. Is the sequence field set? And why doesn't
> v4l2-compliance fail on this?
>
>>                 Buffer: 1 Sequence: 0 Field: None Timestamp: 75.253877s
>
> <snip>
>
>>         test MMAP: OK
>>         test USERPTR: OK (Not Supported)
>>         test DMABUF: Cannot test, specify --expbuf-device
>>
>> Total: 42, Succeeded: 42, Failed: 0, Warnings: 0
>>>
>> [Snip]
>
>>>> +static int vpfe_enum_fmt(struct file *file, void  *priv,
>>>> +                      struct v4l2_fmtdesc *f)
>>>> +{
>>>> +     struct vpfe_device *vpfe = video_drvdata(file);
>>>> +     struct v4l2_subdev_mbus_code_enum mbus_code;
>>>> +     struct vpfe_subdev_info *sdinfo;
>>>> +     struct vpfe_fmt *fmt;
>>>> +     int ret;
>>>> +
>>>> +     vpfe_dbg(2, vpfe, "vpfe_enum_format index:%d\n",
>>>> +             f->index);
>>>> +
>>>> +     sdinfo = vpfe->current_subdev;
>>>> +     if (!sdinfo->sd)
>>>> +             return -EINVAL;
>>>> +
>>>> +     mbus_code.index = f->index;
>>>> +     ret = v4l2_subdev_call(sdinfo->sd, pad, enum_mbus_code,
>>>> +                            NULL, &mbus_code);
>>>> +     if (ret)
>>>> +             return -EINVAL;
>>>> +
>>>> +     /* convert mbus_format to v4l2_format */
>>>> +     fmt = find_format_by_code(mbus_code.code);
>>>> +     if (!fmt) {
>>>> +             vpfe_err(vpfe, "mbus code 0x%08x not found\n",
>>>> +                     mbus_code.code);
>>>> +             return -EINVAL;
>>>> +     }
>>>
>>> Hmm. If a subdev supports more media bus codes then are supported by this
>>> driver, then the enumeration will stop as soon as such an unsupported code
>>> is found.
>>>
>>> What you want to do here is enumerate over the pixelformats that are supported
>>> by both this driver and the subdev. It is probably something you want to
>>> determine at the time the subdev is loaded and just mark unsupported formats
>>> at that time so that they can be skipped here.
>>>
>> So probably populate the supported pixelformats in s_input call ,
>> by calling enm_mbus_code ?
>
> I would do this during driver initialization, it's a one time thing that can
> be done there.
>
OK will do it when subdev is registered.

Thanks,
--Prabhakar Lad
