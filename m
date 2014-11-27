From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 1/5] Documentation: DT: Renamed of-serial.txt to
 8250.txt
Date: Thu, 27 Nov 2014 11:38:20 +0000
Message-ID: <20141127113819.GD857@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-2-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1416917818-10506-2-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Cc: "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "broonie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <broonie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "m-karicheri2-l0cyMroinI0@public.gmane.org" <m-karicheri2-l0cyMroinI0@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "shawn.guo-KZfg59tc24xl57MIdRCFDg@public.gmane.org" <shawn.g>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 12:16:54PM +0000, Chunyan Zhang wrote:
> The file of-serial.txt was only for 8250 compatible UART implementations,
> so renamed it to 8250.txt to avoid confusing other persons.
> This is recommended by Arnd, see:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>

My prior Ack [1] still applies (given you've just changed the way the
patch was generated, as Arnd and I suggested).

Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/295152.html

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
