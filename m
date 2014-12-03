From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] media: platform: add VPFE capture driver support for AM437X
Date: Wed, 3 Dec 2014 00:39:14 +0000
Message-ID: <CA+V-a8vM+6A1EX6o8+_=SM=VSc2Zya3n-G5YJ8ZFc8Uir_dH5Q@mail.gmail.com>
References: <1417566590-30529-1-git-send-email-prabhakar.csengg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417566590-30529-1-git-send-email-prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Lad, Prabhakar" <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 3, 2014 at 12:29 AM, Lad, Prabhakar
<prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
>
> This patch adds Video Processing Front End (VPFE) driver for
> AM437X family of devices
> Driver supports the following:
> - V4L2 API using MMAP buffer access based on videobuf2 api
> - Asynchronous sensor/decoder sub device registration
> - DT support
>

v4l2-complicance op:


root@am437x-evm:~# ./v4l2-compliance -s -i 0 -v
Driver Info:
        Driver name   : vpfe
[   69.212320] vpfe 48326000.vpfe: =================  START STATUS
=================

        Bus info      : platform:vpfe 48326000.vpfe
        [   69.224520] vpfe 48326000.vpfe: ==================  END
STATUS  ==================
Driver version: 3.18.0
        Capabilities  : 0x85200[   69.237663] vpfe 48326000.vpfe:
invalid input index: 1
001
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
                info: Could not perform global format test
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
                Buffer: 0 Sequence: 0 Field: None Timestamp: 73.805968s
                Buffer: 1 Sequence: 1 Field: None Timestamp: 73.828843s
                Buffer: 2 Sequence: 2 Field: None Timestamp: 73.851723s
                Buffer: 3 Sequence: 3 Field: None Timestamp: 74.057647s
                Buffer: 0 Sequence: 4 Field: None Timestamp: 74.080531s
                Buffer: 1 Sequence: 5 Field: None Timestamp: 74.103409s
                Buffer: 2 Sequence: 6 Field: None Timestamp: 74.126289s
                Buffer: 3 Sequence: 7 Field: None Timestamp: 74.149169s
                Buffer: 0 Sequence: 8 Field: None Timestamp: 74.172051s
                Buffer: 1 Sequence: 9 Field: None Timestamp: 74.194930s
                Buffer: 2 Sequence: 10 Field: None Timestamp: 74.217811s
                Buffer: 3 Sequence: 11 Field: None Timestamp: 74.240692s
                Buffer: 0 Sequence: 12 Field: None Timestamp: 74.263571s
                Buffer: 1 Sequence: 13 Field: None Timestamp: 74.286452s
                Buffer: 2 Sequence: 14 Field: None Timestamp: 74.309332s
                Buffer: 3 Sequence: 15 Field: None Timestamp: 74.332213s
                Buffer: 0 Sequence: 16 Field: None Timestamp: 74.355093s
                Buffer: 1 Sequence: 17 Field: None Timestamp: 74.377973s
                Buffer: 2 Sequence: 18 Field: None Timestamp: 74.400855s
                Buffer: 3 Sequence: 19 Field: None Timestamp: 74.423734s
                Buffer: 0 Sequence: 20 Field: None Timestamp: 74.446614s
                Buffer: 1 Sequence: 21 Field: None Timestamp: 74.469495s
                Buffer: 2 Sequence: 22 Field: None Timestamp: 74.492375s
                Buffer: 3 Sequence: 23 Field: None Timestamp: 74.515255s
                Buffer: 0 Sequence: 24 Field: None Timestamp: 74.538136s
                Buffer: 1 Sequence: 25 Field: None Timestamp: 74.561019s
                Buffer: 2 Sequence: 26 Field: None Timestamp: 74.583897s
                Buffer: 3 Sequence: 27 Field: None Timestamp: 74.606777s
                Buffer: 0 Sequence: 28 Field: None Timestamp: 74.629657s
                Buffer: 1 Sequence: 29 Field: None Timestamp: 74.652538s
                Buffer: 2 Sequence: 30 Field: None Timestamp: 74.675418s
                Buffer: 3 Sequence: 31 Field: None Timestamp: 74.698298s
                Buffer: 0 Sequence: 32 Field: None Timestamp: 74.721180s
                Buffer: 1 Sequence: 33 Field: None Timestamp: 74.744059s
                Buffer: 2 Sequence: 34 Field: None Timestamp: 74.766939s
                Buffer: 3 Sequence: 35 Field: None Timestamp: 74.789821s
                Buffer: 0 Sequence: 36 Field: None Timestamp: 74.812700s
                Buffer: 1 Sequence: 37 Field: None Timestamp: 74.835581s
                Buffer: 2 Sequence: 38 Field: None Timestamp: 74.858461s
                Buffer: 3 Sequence: 39 Field: None Timestamp: 74.881342s
                Buffer: 0 Sequence: 40 Field: None Timestamp: 74.904222s
                Buffer: 1 Sequence: 41 Field: None Timestamp: 74.927102s
                Buffer: 2 Sequence: 42 Field: None Timestamp: 74.949982s
                Buffer: 3 Sequence: 43 Field: None Timestamp: 74.972863s
                Buffer: 0 Sequence: 44 Field: None Timestamp: 74.995743s
                Buffer: 1 Sequence: 45 Field: None Timestamp: 75.018624s
                Buffer: 2 Sequence: 46 Field: None Timestamp: 75.041504s
                Buffer: 3 Sequence: 47 Field: None Timestamp: 75.064387s
                Buffer: 0 Sequence: 48 Field: None Timestamp: 75.087266s
                Buffer: 1 Sequence: 49 Field: None Timestamp: 75.110146s
                Buffer: 2 Sequence: 50 Field: None Timestamp: 75.133025s
                Buffer: 3 Sequence: 51 Field: None Timestamp: 75.155906s
                Buffer: 0 Sequence: 52 Field: None Timestamp: 75.178788s
                Buffer: 1 Sequence: 53 Field: None Timestamp: 75.201668s
                Buffer: 2 Sequence: 54 Field: None Timestamp: 75.224547s
                Buffer: 3 Sequence: 55 Field: None Timestamp: 75.247427s
                Buffer: 0 Sequence: 56 Field: None Timestamp: 75.270308s
                Buffer: 1 Sequence: 57 Field: None Timestamp: 75.293188s
                Buffer: 2 Sequence: 58 Field: None Timestamp: 75.316068s
                Buffer: 3 Sequence: 59 Field: None Timestamp: 75.338949s
            Video Capture (polling):
                Buffer: 0 Sequence: 60 Field: None Timestamp: 75.361829s
                Buffer: 1 Sequence: 61 Field: None Timestamp: 75.384710s
                Buffer: 2 Sequence: 62 Field: None Timestamp: 75.407590s
                Buffer: 3 Sequence: 63 Field: None Timestamp: 75.430471s
                Buffer: 0 Sequence: 64 Field: None Timestamp: 75.453350s
                Buffer: 1 Sequence: 65 Field: None Timestamp: 75.476231s
                Buffer: 2 Sequence: 66 Field: None Timestamp: 75.499111s
                Buffer: 3 Sequence: 67 Field: None Timestamp: 75.521991s
                Buffer: 0 Sequence: 68 Field: None Timestamp: 75.544872s
                Buffer: 1 Sequence: 69 Field: None Timestamp: 75.567754s
                Buffer: 2 Sequence: 70 Field: None Timestamp: 75.590634s
                Buffer: 3 Sequence: 71 Field: None Timestamp: 75.613513s
                Buffer: 0 Sequence: 72 Field: None Timestamp: 75.636393s
                Buffer: 1 Sequence: 73 Field: None Timestamp: 75.659274s
                Buffer: 2 Sequence: 74 Field: None Timestamp: 75.682154s
                Buffer: 3 Sequence: 75 Field: None Timestamp: 75.705035s
                Buffer: 0 Sequence: 76 Field: None Timestamp: 75.727915s
                Buffer: 1 Sequence: 77 Field: None Timestamp: 75.750796s
                Buffer: 2 Sequence: 78 Field: None Timestamp: 75.773675s
                Buffer: 3 Sequence: 79 Field: None Timestamp: 75.796556s
                Buffer: 0 Sequence: 80 Field: None Timestamp: 75.819436s
                Buffer: 1 Sequence: 81 Field: None Timestamp: 75.842317s
                Buffer: 2 Sequence: 82 Field: None Timestamp: 75.865197s
                Buffer: 3 Sequence: 83 Field: None Timestamp: 75.888077s
                Buffer: 0 Sequence: 84 Field: None Timestamp: 75.910959s
                Buffer: 1 Sequence: 85 Field: None Timestamp: 75.933838s
                Buffer: 2 Sequence: 86 Field: None Timestamp: 75.956718s
                Buffer: 3 Sequence: 87 Field: None Timestamp: 75.979599s
                Buffer: 0 Sequence: 88 Field: None Timestamp: 76.002479s
                Buffer: 1 Sequence: 89 Field: None Timestamp: 76.025360s
                Buffer: 2 Sequence: 90 Field: None Timestamp: 76.048243s
                Buffer: 3 Sequence: 91 Field: None Timestamp: 76.071122s
                Buffer: 0 Sequence: 92 Field: None Timestamp: 76.094000s
                Buffer: 1 Sequence: 93 Field: None Timestamp: 76.116881s
                Buffer: 2 Sequence: 94 Field: None Timestamp: 76.139761s
                Buffer: 3 Sequence: 95 Field: None Timestamp: 76.162642s
                Buffer: 0 Sequence: 96 Field: None Timestamp: 76.185522s
                Buffer: 1 Sequence: 97 Field: None Timestamp: 76.208402s
                Buffer: 2 Sequence: 98 Field: None Timestamp: 76.231284s
                Buffer: 3 Sequence: 99 Field: None Timestamp: 76.254163s
                Buffer: 0 Sequence: 100 Field: None Timestamp: 76.277044s
                Buffer: 1 Sequence: 101 Field: None Timestamp: 76.299924s
                Buffer: 2 Sequence: 102 Field: None Timestamp: 76.322805s
                Buffer: 3 Sequence: 103 Field: None Timestamp: 76.345685s
                Buffer: 0 Sequence: 104 Field: None Timestamp: 76.368565s
                Buffer: 1 Sequence: 105 Field: None Timestamp: 76.391447s
                Buffer: 2 Sequence: 106 Field: None Timestamp: 76.414326s
                Buffer: 3 Sequence: 107 Field: None Timestamp: 76.437206s
                Buffer: 0 Sequence: 108 Field: None Timestamp: 76.460087s
                Buffer: 1 Sequence: 109 Field: None Timestamp: 76.482967s
                Buffer: 2 Sequence: 110 Field: None Timestamp: 76.505847s
                Buffer: 3 Sequence: 111 Field: None Timestamp: 76.528727s
                Buffer: 0 Sequence: 112 Field: None Timestamp: 76.551607s
                Buffer: 1 Sequence: 113 Field: None Timestamp: 76.574488s
                Buffer: 2 Sequence: 114 Field: None Timestamp: 76.597369s
                Buffer: 3 Sequence: 115 Field: None Timestamp: 76.620250s
                Buffer: 0 Sequence: 116 Field: None Timestamp: 76.643129s
                Buffer: 1 Sequence: 117 Field: None Timestamp: 76.666010s
                Buffer: 2 Sequence: 118 Field: None Timestamp: 76.688890s
                Buffer: 3 Sequence: 119 Field: None Timestamp: 76.711771s
        test MMAP: OK
        test USERPTR: OK (Not Supported)
        test DMABUF: Cannot test, specify --expbuf-device

Total: 42, Succeeded: 42, Failed: 0, Warnings: 0

Thanks,
--Prabhakar Lad
