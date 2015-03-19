From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Thu, 19 Mar 2015 08:39:02 -0600
Message-ID: <CANLsYkz_UJuwsFg6TCDQNLTstY0zH6QNAUR1OGNeYM=9LfoJ+A@mail.gmail.com>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com>
	<CANLsYkzmnHSbfoWSEWkDx-UTuypALZv42FsZ0XVWz2bfqdGWZQ@mail.gmail.com>
	<87mw3bewq8.fsf@ashishki-desk.ger.corp.intel.com>
	<CANLsYkx6+mtTf0gPhu37mfbL84oOj0CkW_yOMwFHh_XyqQ7pAQ@mail.gmail.com>
	<877fuddq2c.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <877fuddq2c.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 19 March 2015 at 08:23, Alexander Shishkin
<alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> I forgot to mention in my previous email...  I think the hierarchy of
>> our respective tracing module along with the generic-stm probably
>> needs a review.
>>
>> Currently we have drivers/coresight, drivers/intel_th and drivers/stm.
>>
>> To me it doesn't scale - what happens when other architectures come
>> out with their own hw tracing technologies?
>>
>> I suggest we move everything under drivers/hwtracing and as such have:
>>
>> drivers/hwtracing
>> drivers/hwtracing/intel_ht
>> drivers/hwtracing/coresight
>> drivers/hwtracing/stm
>>
>> That way other architectures can add drivers for their own hw tracing
>> technology without further polluting the drivers/ directory and
>> concentrating everything in the same area.  What's your view on that?
>
> I wanted to suggest something similar, actually, if you don't mind
> moving drivers/coresight, then let's do it.

That's a deal - my next patchset will reflect that new organisation.

>
> Regards,
> --
> Alex
