From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v3] serial: support 16-bit register interface for console
Date: Tue, 27 Oct 2015 09:53:02 -0400
Message-ID: <562F81BE.3000502@hurleysoftware.com>
References: <1445832662-23250-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445832662-23250-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-doc-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-serial@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>, Rob Herring <robh@kernel.org>, Kevin Cernekee <cernekee@gmail.com>, linux-api@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Hi Masahiro,

On 10/26/2015 12:11 AM, Masahiro Yamada wrote:
> Currently, 8-bit (MMIO) and 32-bit (MMIO32) register interfaces are
> supported for the 8250 console, but the 16-bit (MMIO16) is not.
> The 8250 UART device on my board is connected to a 16-bit bus
> and my main motivation is to use earlycon with it.
> (Refer to arch/arm/boot/dts/uniphier-support-card.dtsi)

As I noted in reviewing v2, the patch hunk below does not apply.
You must rebase your changes on top of Greg's tty-next tree.

Regards,
Peter Hurley

> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 603d2cc..325acce 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1819,8 +1819,8 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
>   *	@options: ptr for <options> field; NULL if not present (out)
>   *
>   *	Decodes earlycon kernel command line parameters of the form
> - *	   earlycon=<name>,io|mmio|mmio32|mmio32be,<addr>,<options>
> - *	   console=<name>,io|mmio|mmio32|mmio32be,<addr>,<options>
> + *	   earlycon=<name>,io|mmio|mmio16|mmio32|mmio32be,<addr>,<options>
> + *	   console=<name>,io|mmio|mmio16|mmio32|mmio32be,<addr>,<options>
>   *
>   *	The optional form
>   *	   earlycon=<name>,0x<addr>,<options>

