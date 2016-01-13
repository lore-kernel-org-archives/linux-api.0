From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
	<wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE
Date: Thu, 14 Jan 2016 00:07:27 +0800
Message-ID: <CAOMLVLiDxkAdqsaAidxhZ=k4E=dHxe7+nOt1v7+fQrsDZG4Dow@mail.gmail.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org> <1452697362.3605.8.camel@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452697362.3605.8.camel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Wu-Cheng Li <wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, k.debski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ao2-qKGr9MkilAE@public.gmane.org, bparrot-l0cyMroinI0@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 13, 2016 at 11:02 PM, Nicolas Dufresne
<nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org> wrote:
> Le mercredi 13 janvier 2016 =C3=A0 20:03 +0800, Wu-Cheng Li a =C3=A9c=
rit :
>> Some drivers also need a control like
>> V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE to force an encoder frame
>> type. This patch adds a general V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE=
=2E
>>
>> This control only affects the next queued buffer. There's no need to
>> clear the value after requesting an I frame. But all controls are se=
t
>> in v4l2_ctrl_handler_setup. So a default DISABLED value is required.
>> Basically this control is like V4L2_CTRL_TYPE_BUTTON with parameters=
=2E
>> How to prevent a control from being set in v4l2_ctrl_handler_setup s=
o
>> DISABLED value is not needed? Does it make sense not to set a contro=
l
>> if it is EXECUTE_ON_WRITE?
>
> I don't like the way it's implemented. I don't know any decoder that
> have a frame type forcing feature other they I-Frame. It would be muc=
h
> more natural to use a toggle button control (and add more controls fo=
r
> other types when needed) then trying to merge hypothetical toggles in=
to
> something that manually need to be set and disabled.
Using a button control sounds like a good idea. I'll discuss with other=
 people
and reply tomorrow.
>
>>
>> Wu-Cheng Li (1):
>>   v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>>
>>  Documentation/DocBook/media/v4l/controls.xml | 23
>> +++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         | 13 +++++++++++++
>>  include/uapi/linux/v4l2-controls.h           |  5 +++++
>>  3 files changed, 41 insertions(+)
>>
