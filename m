From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [musl] Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Tue, 25 Apr 2017 08:37:34 +0200
Message-ID: <9373f78c-ff15-fbb5-724a-27152d6f994b@hauke-m.de>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488977188.4347.134.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 03/08/2017 01:46 PM, David Woodhouse wrote:
> On Fri, 2016-11-11 at 07:08 -0500, Felix Janda wrote:
>> Currently, libc-compat.h detects inclusion of specific glibc headers,
>> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
>> uapi headers to prevent definition of conflicting structures/constants.
>> There is no such detection for other c libraries, for them the
>> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
>> conflicting definitions are suppressed.
>>
>> This patch enables non-glibc c libraries to request the suppression of
>> any specific interface by defining the corresponding _UAPI_DEF_* macro
>> as 0.
> 
> Ick. It's fairly horrid for kernel headers to be reacting to __GLIBC__
> in any way. That's just wrong.
> 
> It makes more sense for C libraries to define the __UAPI_DEF_xxx for
> themselves as and when they add their own support for certain things,
> and for the kernel not to have incestuous knowledge of them.
> 
> The part you add here in the #else /* !__GLIBC__ */ part is what we
> should do at *all* times.
> 
> I understand that we'll want to grandfather in the glibc horridness,
> but let's make it clear that that's what it is, by letting it set the
> appropriate __UAPI_DEF_xxx macros to zero, and then continue through to
> your new part. Something like this (incremental to yours):

Felix's and this change and are looking better than my patches here:
https://lkml.org/lkml/2017/3/12/235

Is someone working on brining this into the mainline kernel?

Is it correct that only the comments should be improved?
musl only supports including the musl header files before the kernel
anyway, I assume that it is not needed to make the kernel uapi code
support also the other order.

Hauke
