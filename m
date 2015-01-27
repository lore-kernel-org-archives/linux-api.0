From: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Tue, 27 Jan 2015 23:43:51 +0800
Message-ID: <CAAfSe-sPv+TDrUXYfW8DRJZiXjhVpRr=Wd3td7kHeB5r2LEnjw@mail.gmail.com>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<2196748.ag4UzqF1Px@wuerfel>
	<20150127145518.GA32531@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150127145518.GA32531-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shawn Guo <shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Orson Zhai <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, zhizhou.zhang
List-Id: linux-api@vger.kernel.org

On Tue, Jan 27, 2015 at 10:55 PM, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Tue, Jan 27, 2015 at 02:24:02PM +0100, Arnd Bergmann wrote:
>> On Tuesday 27 January 2015 15:56:45 Chunyan Zhang wrote:
>> > This patch-set split the last version, and addressed the review comments from
>> > last version on serial driver code.
>> >
>> > Changes from v7:
>> > * Addressed review comments from Peter:
>> >         - Initialized the stack local with zero in sprd_set_termios()
>> >         - Used dev_get_drvdata() to get sprd_uart_port
>> >
>>
>> Looks good to me, but you still have too many people on 'To', so Greg
>> might be missing that you expect him to merge it.
>>
>> Greg, if there are no further comments, can you take both patches through
>> the tty git?
>
> Will do, thanks.
>
> greg k-h

To Arnd, Greg, Peter, and to all of others

thank you so much for your help.
You all gave us so many important comments and valuable suggestions
these months.

Best regards,
Chunyan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
