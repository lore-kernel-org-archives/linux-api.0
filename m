From: Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] media: platform: add VPFE capture driver support for AM437X
Date: Tue, 2 Dec 2014 07:49:45 +0000
Message-ID: <CA+V-a8vsXSG=bqYcsh+Ud3J9Ha7o5AL15N+seMpUPYggqXZRKQ@mail.gmail.com>
References: <1416791411-9731-1-git-send-email-prabhakar.csengg@gmail.com>
 <547C3ED3.1060205@xs4all.nl> <547C4A69.8020002@xs4all.nl> <CA+V-a8uL4J0Y2ZfDxe7jhxzGcCNe9QbCDUjDZrC+mZ5E6sX2jg@mail.gmail.com>
 <547D6B07.6050803@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547D6B07.6050803-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: LMML <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hans,

On Tue, Dec 2, 2014 at 7:32 AM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
> On 12/01/2014 11:27 PM, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Mon, Dec 1, 2014 at 11:00 AM, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> wrote:
>>> On 12/01/2014 11:11 AM, Hans Verkuil wrote:
>>>> Hi all,
>>>>
>>>> Thanks for the patch, review comments are below.
>>>>
>>>> For the next version I would appreciate if someone can test this driver with
>>>> the latest v4l2-compliance from the v4l-utils git repo. If possible test streaming
>>>> as well (v4l2-compliance -s), ideally with both a sensor and a STD receiver input.
>>>> But that depends on the available hardware of course.
>>>>
>>>> I'd like to see the v4l2-compliance output. It's always good to have that on
>>>> record.
>>>>
>>>>
>>>> On 11/24/2014 02:10 AM, Lad, Prabhakar wrote:
>>>>> From: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
>>>>>
>>>>> This patch adds Video Processing Front End (VPFE) driver for
>>>>> AM437X family of devices
>>>>> Driver supports the following:
>>>>> - V4L2 API using MMAP buffer access based on videobuf2 api
>>>>> - Asynchronous sensor/decoder sub device registration
>>>>> - DT support
>>>>>
>>>>> Signed-off-by: Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>
>>>>> Signed-off-by: Darren Etheridge <detheridge-l0cyMroinI0@public.gmane.org>
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> ---
>>>>>  .../devicetree/bindings/media/ti-am437xx-vpfe.txt  |   61 +
>>>>>  MAINTAINERS                                        |    9 +
>>>>>  drivers/media/platform/Kconfig                     |    1 +
>>>>>  drivers/media/platform/Makefile                    |    2 +
>>>>>  drivers/media/platform/am437x/Kconfig              |   10 +
>>>>>  drivers/media/platform/am437x/Makefile             |    2 +
>>>>>  drivers/media/platform/am437x/vpfe.c               | 2764 ++++++++++++++++++++
>>>>>  drivers/media/platform/am437x/vpfe.h               |  286 ++
>>>>>  drivers/media/platform/am437x/vpfe_regs.h          |  140 +
>>>>>  include/uapi/linux/Kbuild                          |    1 +
>>>>>  include/uapi/linux/am437x_vpfe.h                   |  122 +
>>>>>  11 files changed, 3398 insertions(+)
>>>
>>> Can the source names be improved? There are too many 'vpfe' sources.
>>> Perhaps prefix all with 'am437x-'?
>>>
>> I did think of it but, dropped it as anyway the source's are present
>> in am437x folder, again naming the files am437x-xxx.x didn't make
>> me feel good. If you still insists I'll do it.
>
> Yes, please do. If you look at most other drivers they all have a prefix.
>
> Another reason is that the media_build system expects unique names.
>
OK makes sense I'll prefix it with 'am437x-'. probably fixing all the review
comments i'll post a v2 end of the day.

Thanks,
--Prabhakar Lad
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
