From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Fri, 8 May 2015 08:07:39 -0600
Message-ID: <CANLsYkwT9zinP6KLi6o95+fGwPbxbUgWTpMnL7yZfsfTU8p31A@mail.gmail.com>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
	<1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
	<CACRpkdak5-iuWEDAvhDq3uwYobK+tW_N-t-QaY+-5TUSCa7uOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACRpkdak5-iuWEDAvhDq3uwYobK+tW_N-t-QaY+-5TUSCa7uOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 28 April 2015 at 06:28, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Apr 23, 2015 at 12:40 AM, Mathieu Poirier
> <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> This driver manages the CoreSight ETMv4 (Embedded Trace Macrocell) IP block
>> to support HW assisted tracing on ARMv7 and ARMv8 architectures.
>>
>> Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Kaixu Xia <xiakaixu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> (...)
>> +/* The number of ETMv4 currently registered */
>> +static int etm4_count;
>> +static struct etmv4_drvdata *etmdrvdata[NR_CPUS];
>
> Don't you need a mutex or something around etm4_count so
> as to protect it? You could also make it an atomic.

Sorry for the late reply, your email got lost under the pile.

The etm4_count is only used at boot time to avoid registering the
notifiers twice and not used otherwise.  Since the discovery of
coresight devices is sequential there is no point in guarding it.

>
> Also why is it a signed int ... unsigned int?
>
> I know, lame comments, the runtime PM stuff looks perfect now,

I like it too - thanks for the review.

> someone had a refcount comment but it's doing the right thing.
>
> Yours,
> Linus Walleij
