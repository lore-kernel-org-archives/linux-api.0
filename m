From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND PATCH V4 4/4] coresight-stm: adding driver for CoreSight
 STM component
Date: Mon, 28 Mar 2016 11:06:25 +0800
Message-ID: <CAG2=9p-o5XRxeFxYSezjj7OGjikhE--_aPc1rJz4bD1ks0X5VQ@mail.gmail.com>
References: <1457418835-31417-1-git-send-email-zhang.chunyan@linaro.org>
	<1457418835-31417-5-git-send-email-zhang.chunyan@linaro.org>
	<HE1PR08MB1130236EF28E34442F362F828A880@HE1PR08MB1130.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR08MB1130236EF28E34442F362F828A880-P22sD0dWJi1S5jlqwlCNZikoKrxaZxrJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Williams <Michael.Williams-5wv7dgnIgG8@public.gmane.org>
Cc: "mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Mike Leach <Mike.Leach-5wv7dgnIgG8@public.gmane.org>, Al Grant <Al.Grant-5wv7dgnIgG8@public.gmane.org>, "tor-l0cyMroinI0@public.gmane.org" <tor-l0cyMroinI0@public.gmane.org>, "nicolas.guion-qxv4g6HH51o@public.gmane.org" <nicolas.guion-qxv4g6HH51o@public.gmane.org>, "pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Mon, Mar 14, 2016 at 5:53 PM, Michael Williams
<Michael.Williams-5wv7dgnIgG8@public.gmane.org> wrote:
> Reviewed-by: Michael Williams <michael.williams-5wv7dgnIgG8@public.gmane.org>

I will add your Reviewed-by in the next version of patch.

>
> This resend addresses my earlier concerns.

Thanks for your review and feedback,
Chunyan

>
>> -----Original Message-----
>> From: Chunyan Zhang [mailto:zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org]
>> Sent: 08 March 2016 06:34
>> To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org; alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
>> Cc: Mike Leach; Michael Williams; Al Grant; tor-l0cyMroinI0@public.gmane.org; nicolas.guion-qxv4g6HH51o@public.gmane.org;
>> pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-arm-
>> kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [RESEND PATCH V4 4/4] coresight-stm: adding driver for CoreSight STM component
>>
>> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> [snip]
>
> Mike.
> --
> Michael Williams  Principal Engineer   ARM Limited
> www.arm.com The Architecture For The Digital World
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
>
