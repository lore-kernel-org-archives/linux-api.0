From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sat, 14 Jun 2014 23:49:53 -0700
Message-ID: <CALCETrU47SPpiPbEWKOquy7dfBS01ctCirmZA=HH5Xa4jVy_4w@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <20140614213000.GO179@brightrain.aerifal.cx>
 <CALCETrX3Kv7VAfYau-79odKtRvME0-AzZB_xGUMPEHeas8AkaQ@mail.gmail.com>
 <539CDC6F.6010501@zytor.com> <539D1A28.7040107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539D1A28.7040107-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 14, 2014 at 8:59 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 06/14/2014 04:36 PM, H. Peter Anvin wrote:
>>
>> Now, if we can do this without adding another page then that becomes
>> much more compelling IMO.  I suspect we can if you are already down to
>> 488 bytes.
>>
>
> (If it isn't already the case, was inteded to be part of that...)

It's down to 375 bytes now.  I'm not sure how to do better than that
without starting to hardcode variously nasty assumptions.

With CONFIG_PARAVIRT_CLOCK=y I think the 64-bit vdso is two pages
anyway.  With CONFIG_PARAVIRT_CLOCK=n, it's one page even with my
code.

(At some point I plan on tackling the paravirt clock code.  It's much
more complicated and much slower than it needs to be.)

--Andy
