From: Orson Zhai <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 2/5] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Sat, 17 Jan 2015 16:10:32 +0800
Message-ID: <CA+H2tpHA7PRL98VMd3d3jeaOr_6Q5ktmM3fbdaBKRpm_pXVqVw@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<20150116102135.GC21809@leverpostej>
	<CAAfSe-teDdPzRUnvzM+NErfZwmqM04yUMgic--hyZL8-Jjd8jw@mail.gmail.com>
	<20150116141109.GC22569@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150116141109.GC22569@leverpostej>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely@lin>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 10:11 PM, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Jan 16, 2015 at 12:53:16PM +0000, Lyra Zhang wrote:
>> Hi, Mark
>>
>> >> +
>> >> +Required properties:
>> >> +- compatible: must be "sprd,sc9836-uart"
>> >> +- reg: offset and length of the register set for the device
>> >> +- interrupts: exactly one interrupt specifier
>> >> +- clocks: phandles to input clocks.
>> >
>> > The order and relevance of each should be specified. If you have
>> > multiple clocks I would strongly recommend you use clock-names to
>> > distinguish them.
>> >
>>
>> Thank you for the recommendation.
>> but, since we haven't made the clock driver ready, for this initial
>> commit, we just let 4 UARTs share a single fixed 26 MHz clock source.
>> we'll do like you've recommended when we will submit the clock driver
>> in the future.
>
> I'm on about the clock input lines on the UART instance, not the
> providers they come from.
>
> Is there only a single clock input line on each UART? Perhaps multiple
> input lines which are currently fed by the same clock?

________
| 26MHz |-------------------------------------------------
-------------        |                  |
                     |                  |
                _______       ________
               | UART1 |      | UART2 |    .........
               --------------      -------------

the hardware is something like the diagram.

4 Uart modules are all connected to a fixed 26Mhz crystal by power-on default.

There should be a clock-mux between uart and 26Mhz which
could select other clock source such as some pll output.

But as initial commit , we are not ready to describe other inputs by
these muxes.
So  we treat the UART as a simple model with only one fixed-clock input.
And we plan to add the other inputs path back in a not very far future.
Is it appropriate  to do like this?

  Orson


>
> Thanks,
> Mark.
