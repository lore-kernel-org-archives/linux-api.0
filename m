From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early console
Date: Fri, 19 Feb 2016 16:27:16 +0000
Message-ID: <56C74264.9070906@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
 <1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>
 <CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
 <56C31F9F.10000@arm.com> <56C6E42E.5070601@arm.com>
 <CAHp75VcosaVcz_aYbpfL-nUH0kBf72SshXU5k95s48Z3wnA5nQ@mail.gmail.com>
 <56C738F1.2070307@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C738F1.2070307-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, ijc+devicetree <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, linux-arm Mailing List <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 19/02/16 15:46, Peter Hurley wrote:
> On 02/19/2016 01:57 AM, Andy Shevchenko wrote:
>> On Fri, Feb 19, 2016 at 11:45 AM, Vladimir Murzin
>> <vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
>>> On 16/02/16 13:09, Vladimir Murzin wrote:
>>>>>> +EARLYCON_DECLARE(mps2, mps2_early_console_setup);
>>>>>>>> +OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
>>>>>>
>>>>>> IIRC Peter Hurley mentioned you don't need to put both anymore, OF_
>>>>>> one is enough.
>>>>>>
>>>> I've just tried with OF_ only and seems it works fine. Thanks for
>>>> pointing at it!
>>>>
>>>
>>> ..and the reason for that was that I had stdout pointing at uart node.
>>> Now, while testing v4 I end-up with configuration:
>>>
>>> 1) no EARLYCON_DECLARE in mps2-uart.c
>>> 2) stdout not set
>>> 3) cmdline has "earlycon=mps2,0x40004000 console=/dev/ttyMPS"
>>>
>>> and I don't see bootconsole, but if I avoid 1) everything works fine.
>>> So, I'd leave EARLYCON_DECLARE in this patch.
>>
>> Peter, what is your comment on this?
> 
> That Vladimir is not testing with linux-next.
> 
> linux-next has common framework for both command line and OF-defined
> earlycons.
> 
> Vladimir, if you pull in Greg's tty-next branch, then just
> 
> OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
> 
> should enable both command-line and OF-defined earlycons.

Confirmed! No doubt now EARLYCON_DECLARE can be dropped from this patch
safely.

Thanks!
Vladimir

> 
> Regards,
> Peter Hurley
> 
> 
