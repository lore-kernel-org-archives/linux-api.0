From: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3] serial: support 16-bit register interface for console
Date: Wed, 28 Oct 2015 12:29:41 +0900
Message-ID: <CAK7LNAQ_uVAQUL3Z3eX13ZPYOgN8b6FOodgizWoQBzmAweAcDA@mail.gmail.com>
References: <1445832662-23250-1-git-send-email-yamada.masahiro@socionext.com>
	<562F81BE.3000502@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562F81BE.3000502-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vineet Gupta <Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Peter,

2015-10-27 22:53 GMT+09:00 Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>:
> Hi Masahiro,
>
> On 10/26/2015 12:11 AM, Masahiro Yamada wrote:
>> Currently, 8-bit (MMIO) and 32-bit (MMIO32) register interfaces are
>> supported for the 8250 console, but the 16-bit (MMIO16) is not.
>> The 8250 UART device on my board is connected to a 16-bit bus
>> and my main motivation is to use earlycon with it.
>> (Refer to arch/arm/boot/dts/uniphier-support-card.dtsi)
>
> As I noted in reviewing v2, the patch hunk below does not apply.
> You must rebase your changes on top of Greg's tty-next tree.
>


Sorry, I missed your comment on v2.

I will send v4.


-- 
Best Regards
Masahiro Yamada
