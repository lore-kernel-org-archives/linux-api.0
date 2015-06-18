From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Thu, 18 Jun 2015 08:59:24 +0200
Message-ID: <CAMuHMdX9BaBj4gFW4aP_t_GFsPQi_wU8-sQsUFr_A0cksr4MJQ@mail.gmail.com>
References: <20150614074607.242676098@telegraphics.com.au>
	<20150614074613.054681242@telegraphics.com.au>
	<CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog@mail.gmail.com>
	<alpine.LNX.2.00.1506152213340.12762@nippy.intranet>
	<alpine.LNX.2.00.1506181417260.30499@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1506181417260.30499-i19888lE8tflDoPlx7XIcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux/m68k <linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Finn,

On Thu, Jun 18, 2015 at 6:49 AM, Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org> wrote:
> On Tue, 16 Jun 2015, in which I wrote:
>> On Mon, 15 Jun 2015, Geert Uytterhoeven wrote:
>> > More magic values...
>>
>> [...] The only useful RTC documentation I've ever come across is this:
>> http://mac.linux-m68k.org/devel/plushw.php
>
> This document appears to be Inside Macintosh vol. III ch. 2. It describes
> the early RTC chip that lacks two-byte operations and XPRAM, and pre-dates
> all Mac hardware supported in mainline Linux. But it does offer some
> useful data, though not enough to answer all of your criticisms (as I
> said).

I understand.

>> [...] I think they should be applied across the entire file, and in a
>> different patch. Inconsistent use of such macros would be undesirable
>> IMHO.
>
> So, unless you have other ideas, I will revise this patch and insert an
> earlier patch to address existing code, and codify what little reliable
> chip data we have.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
