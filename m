From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [musl] Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Fri, 2 Jun 2017 09:07:26 +0200
Message-ID: <74e5c515-d924-c4d8-69ad-aeb57d1c4ef0@redhat.com>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
 <459a8faf-4585-5063-3d94-3a1fecfa8289@redhat.com>
 <21e624b9-7ab1-dcf9-fb1e-c31dd564a283@hauke-m.de>
 <9f591383-6e4c-c231-1e5b-68e4b8c16d94@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9f591383-6e4c-c231-1e5b-68e4b8c16d94-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Felix Janda <felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/25/2017 02:29 PM, Carlos O'Donell wrote:
> In glibc right now we support including linux or glibc header files first,
> and this has always been a requirement from the start. This requirement dictates
> that the kernel know which libc it's being used with so it can tailor coordination.

“right now we support” is not a support commitment, but more of an
aspiration, right?

A lot of combinations are broken, especially when kernel headers are
included first.  Maybe it's time for us to admit defeat and come up with
a simpler scheme which actually works.

Thanks,
Florian
