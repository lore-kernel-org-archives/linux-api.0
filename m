From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] tty: serial: 8250: Add new capability for highspeed
 register
Date: Tue, 5 Aug 2014 12:43:43 +0100
Message-ID: <20140805124343.27ff9b32@alan.etchedpixels.co.uk>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
	<1407236054-30994-2-git-send-email-matthias.bgg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407236054-30994-2-git-send-email-matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, heikki.krogerus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, asierra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org, mwelling-EkmVulN54Sk@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, m-karicheri2-l0cyMroinI0@public.gmane.org, jschultz-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, balbi-l0cyMroinI0@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>  
>  	/*
> +	 * Mediatek UARTs use an extra highspeed register (UART_MTK_HIGHS)
> +	 *
> +	 * We need to recalcualte the quot register, as the claculation depends
> +	 * on the vaule in the highspeed register.
> +	 *
> +	 * Some baudrates are not supported by the chip, so we use the next
> +	 * lower rate supported.
> +	 *
> +	 * If highspeed register is set to 3, we need to specify sample count
> +	 * and sample point to increase accuracy. If not, we reset the
> +	 * registers to their default values.
> +	 */

Don't put stuff in the core driver core for your chip specific weirdness,
wrap the termios method with your own in your driver code as a fair
number of other 8250ish drivers do.

If you do that then you don't need to waste a UART CAPS flag and you
don't need to put anything in the core driver code.

Alan
