From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Fri, 20 Mar 2015 09:19:31 -0600
Message-ID: <CANLsYkxioQnnvDObyXrrzFY1-9HDiTmC5pHLq2JEkBu_2t0H+w@mail.gmail.com>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com>
	<CANLsYkzmnHSbfoWSEWkDx-UTuypALZv42FsZ0XVWz2bfqdGWZQ@mail.gmail.com>
	<87mw3bewq8.fsf@ashishki-desk.ger.corp.intel.com>
	<CANLsYkwithjLgtztf8aBDRv-QL2VGOwc4XZ=1sGBSHg4LiymBg@mail.gmail.com>
	<87k2ybd8jl.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87k2ybd8jl.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 20 March 2015 at 08:53, Alexander Shishkin
<alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> As promised I worked on a prototype that connects the coresight-stm
>> driver with the generic STM interface you have suggested.  Things work
>> quite well and aside from the enhancement related to the ioctl() and
>> private member as discussed above, we should move ahead with this.
>>
>> I will send out a new version of the coresight-stm driver as soon as I
>> see your patches with those changes.
>
> Actually, instread of a private member I'd simply pass struct stm_data
> pointer to the callback (like we do with other callbacks) and the
> private data would be in the structure that embeds this struct stm_data,
> so that you can get to it using container_of():
>
> struct my_stm {
>        struct stm_data  data;
>        void             *my_stuff;
>        ...
> };
>
> ...
>
> long my_ioctl(struct stm_data *data, unsigned int cmd, unsigned long
>               arg)
> {
>         struct my_stm *mine = container_of(data, struct my_stm, data);
>
> ...
>
> Would this work for you?

That should be just fine yes.

> I'm otherwise ready to send the second version
> of my patchset.

Cool

>
> Regards,
> --
> Alex
