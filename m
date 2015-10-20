From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v2 1/2] serial: support register interface with 16-bit
 stride for console
Date: Tue, 20 Oct 2015 09:42:23 -0400
Message-ID: <562644BF.4020204@hurleysoftware.com>
References: <1445312189-28876-1-git-send-email-yamada.masahiro@socionext.com>
 <1445312189-28876-2-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1445312189-28876-2-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-doc-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-serial@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>, Kevin Cernekee <cernekee@gmail.com>, Jiri Slaby <jslaby@suse.com>, Rob Herring <robh@kernel.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Eddie Huang <eddie.huang@mediatek.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 10/19/2015 11:36 PM, Masahiro Yamada wrote:
> Currently, 8-bit (MMIO) and 32-bit (MMIO32) register strides are
> supported for the 8250 console, but 16-bit (MMIO16) stride is not.
> The 8250 UART device on my board is connected to a 16-bit bus
> (reg-shift = <1>) and I am eager to use earlycon with it.
> 
> Refer to arch/arm/boot/dts/uniphier-support-card.dtsi:
> 
>         serialsc: uart@000b0000 {
>                 compatible = "ns16550a";
>                 reg = <0x000b0000 0x20>;
>                 clock-frequency = <12288000>;
>                 reg-shift = <1>;
>         };
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
> Changes in v2:
>   - Do not change userspace-exported macros
> 
>  Documentation/kernel-parameters.txt  |  9 +++++----
>  drivers/tty/serial/8250/8250_early.c |  5 +++++
>  drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
>  drivers/tty/serial/earlycon.c        | 15 +++++++++++----
>  drivers/tty/serial/serial_core.c     |  9 +++++++--
>  include/linux/serial_core.h          |  1 +
>  include/uapi/linux/serial.h          |  1 +
>  7 files changed, 50 insertions(+), 10 deletions(-)

[...]

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

This hunk fails to apply. Please rebase on top of tty-next branch of
Greg's tty.git tree (git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git)

Regards,
Peter Hurley

