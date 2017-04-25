From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: Re: [musl] Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Tue, 25 Apr 2017 08:45:43 +0200
Message-ID: <21e624b9-7ab1-dcf9-fb1e-c31dd564a283@hauke-m.de>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
 <459a8faf-4585-5063-3d94-3a1fecfa8289@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <459a8faf-4585-5063-3d94-3a1fecfa8289-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/08/2017 05:39 PM, Carlos O'Donell wrote:
> Any header needing compat with a libc includes libc-compat.h (per the 
> documented way the model works). With this patch any included linux kernel
> header that also includes libc-compat.h would immediately define all 
> the __UAPI_DEF_* constants to 1 as-if it had defined those structures, 
> but it has not.
> 
> For example, with these two patches applied, the inclusion of linux/if.h
> would define __UAPI_DEF_XATTR to 1, but linux/if.h has not defined
> XATTR_CREATE or other constants, so a subsequent inclusion sys/xattrs.h
> from userspace would _not_ define XATTR_CREATE because __UAPI_DEF_XATTR set
> to 1 indicates the kernel has.
> 
> I don't want to read into the model you are proposing and would rather you
> document the semantics clearly so we can all see what you mean.

What about moving the code from libc-comapt.h into the specific header
files? This way including linux/if.h would not have an impact on
__UAPI_DEF_XATTR, because this is defined in linux/xattr.h. We would
still have a problem when the specific Linux header file gets included
before the libc header file, but at least musl does not support this anyway.

Hauke
