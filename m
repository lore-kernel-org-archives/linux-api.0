From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
	<wuchengli@chromium.org>
Subject: Re: [PATCH v2 1/2] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
Date: Mon, 18 Jan 2016 23:08:37 -0800
Message-ID: <CAOMLVLhZGstnwCTj1XXs19_HHcDuaX7mUVEznxfgxHAW36_viQ@mail.gmail.com>
References: <1452760439-35564-1-git-send-email-wuchengli@chromium.org>
 <1452760439-35564-2-git-send-email-wuchengli@chromium.org>
 <56976263.4050902@xs4all.nl> <5697B85F.7080303@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5697B85F.7080303@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com, mchehab@osg.samsung.com, k.debski@samsung.com, Antti Palosaari <crope@iki.fi>, Masanari Iida <standby24x7@gmail.com>, Nicolas Dufresne <nicolas.dufresne@collabora.com>, Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>, ao2@ao2.it, bparrot@ti.com, kyungmin.park@samsung.com, jtp.park@samsung.com, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Tiffany Lin <tiffany.lin@mediatek.com>, Daniel Kurtz <djkurtz@chromium.org>
List-Id: linux-api@vger.kernel.org

Sorry. I missed the email because of wrong email client configuration.
I've uploaded v4 to address the comments.

On Thu, Jan 14, 2016 at 7:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Wu-Cheng,
>
> Your v3 didn't address these comments. Any reason for that or did you just miss this
> email?
>
> Just wondering,
>
>         Hans
>
> On 01/14/16 09:54, Hans Verkuil wrote:
> > On 01/14/16 09:33, Wu-Cheng Li wrote:
> >> Some drivers also need a control like
> >> V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder
> >> I frame. Add a general V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME
> >> so the new drivers and applications can use it.
> >>
> >> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
> >> ---
> >>  Documentation/DocBook/media/v4l/controls.xml | 8 ++++++++
> >>  drivers/media/v4l2-core/v4l2-ctrls.c         | 2 ++
> >>  include/uapi/linux/v4l2-controls.h           | 1 +
> >>  3 files changed, 11 insertions(+)
> >>
> >> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> >> index f13a429..6760cf5 100644
> >> --- a/Documentation/DocBook/media/v4l/controls.xml
> >> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >> @@ -2330,6 +2330,14 @@ vertical search range for motion estimation module in video encoder.</entry>
> >>            </row>
> >>
> >>            <row><entry></entry></row>
> >> +          <row id="v4l2-mpeg-video-force-i-frame">
> >> +            <entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME</constant>&nbsp;</entry>
> >> +            <entry>button</entry>
> >> +          </row><row><entry spanname="descr">Force an I frame for the next queued buffer. Applicable to encoders.
> >> +This is a general, codec-agnostic keyframe control.</entry>
> >> +          </row>
> >> +
> >> +          <row><entry></entry></row>
> >>            <row>
> >>              <entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
> >>              <entry>integer</entry>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> index c9d5537..33ecb7b 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> @@ -747,6 +747,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>      case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:             return "Horizontal MV Search Range";
> >>      case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:             return "Vertical MV Search Range";
> >>      case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:             return "Repeat Sequence Header";
> >> +    case V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME:                 return "Force an I frame";
> >
> > I would suggest renaming this to Key Frame. This is consistent with the V4L2_BUF_FLAG_KEYFRAME
> > flag and, I think, also more generic than 'I Frame'.
> >
> > So the define would become V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME and the control
> > description "Force Key Frame". The docbook text needs to be updated as well.
> >
> > With those changes this looks good to me.
> >
> > Regards,
> >
> >       Hans
> >
> >>
> >>      /* VPX controls */
> >>      case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:            return "VPX Number of Partitions";
> >> @@ -985,6 +986,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> >>      case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
> >>              *type = V4L2_CTRL_TYPE_INTEGER;
> >>              break;
> >> +    case V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME:
> >>      case V4L2_CID_PAN_RESET:
> >>      case V4L2_CID_TILT_RESET:
> >>      case V4L2_CID_FLASH_STROBE:
> >> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> >> index 2d225bc..1c911b8 100644
> >> --- a/include/uapi/linux/v4l2-controls.h
> >> +++ b/include/uapi/linux/v4l2-controls.h
> >> @@ -390,6 +390,7 @@ enum v4l2_mpeg_video_multi_slice_mode {
> >>  #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER               (V4L2_CID_MPEG_BASE+226)
> >>  #define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE               (V4L2_CID_MPEG_BASE+227)
> >>  #define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE               (V4L2_CID_MPEG_BASE+228)
> >> +#define V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME           (V4L2_CID_MPEG_BASE+229)
> >>
> >>  #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP         (V4L2_CID_MPEG_BASE+300)
> >>  #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP         (V4L2_CID_MPEG_BASE+301)
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
