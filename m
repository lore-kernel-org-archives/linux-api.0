From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
Date: Fri, 16 Jan 2015 08:11:23 -0600
Message-ID: <CAL_JsqL9hkfuGi-BmRHTZ=F3KVL8miu2LXkftbswpVuuSx0dtA@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com> <1421402411-3479-2-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421402411-3479-2-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Florian Vaussard <florian.vaussard-p8DiymsW2f8@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Antony Pavlov <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel Schopp <Joel.Schopp-5C7GfCeVMHo@public.gmane.org>, Suravee Suthikulanit <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, Shawn Guo <shaw>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 16, 2015 at 4:00 AM, Chunyan Zhang
<chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org> wrote:
> The file of-serial.txt was only for 8250 compatible UART implementations,
> so renamed it to 8250.txt to avoid confusing other persons.
> This is suggested by Arnd, see:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html
>
> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

This is pretty much un-related to the rest of the series, so I will apply it.

Rob

> ---
>  .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
>
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/8250.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/serial/of-serial.txt
> rename to Documentation/devicetree/bindings/serial/8250.txt
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
