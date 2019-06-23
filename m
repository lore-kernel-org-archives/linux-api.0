From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V34 18/29] Lock down TIOCSSERIAL
Date: Sat, 22 Jun 2019 17:01:05 -0700
Message-ID: <201906221700.852B22FCE0@keescook>
References: <20190622000358.19895-1-matthewgarrett@google.com>
 <20190622000358.19895-19-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190622000358.19895-19-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matthew Garrett <mjg59@google.com>, Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 05:03:47PM -0700, Matthew Garrett wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Lock down TIOCSSERIAL as that can be used to change the ioport and irq
> settings on a serial port.  This only appears to be an issue for the serial
> drivers that use the core serial code.  All other drivers seem to either
> ignore attempts to change port/irq or give an error.
> 
> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> cc: Jiri Slaby <jslaby@suse.com>
> Cc: linux-serial@vger.kernel.org
> ---
>  drivers/tty/serial/serial_core.c | 5 +++++
>  include/linux/security.h         | 1 +
>  security/lockdown/lockdown.c     | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 351843f847c0..a84f231a5df4 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -22,6 +22,7 @@
>  #include <linux/serial_core.h>
>  #include <linux/delay.h>
>  #include <linux/mutex.h>
> +#include <linux/security.h>
>  
>  #include <linux/irq.h>
>  #include <linux/uaccess.h>
> @@ -852,6 +853,10 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
>  	new_flags = (__force upf_t)new_info->flags;
>  	old_custom_divisor = uport->custom_divisor;
>  
> +	retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
> +	if (retval && (change_port || change_irq))
> +		goto exit;
> +
>  	if (!capable(CAP_SYS_ADMIN)) {
>  		retval = -EPERM;
>  		if (change_irq || change_port ||

This should be moved after the capable test. With that fixed:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> diff --git a/include/linux/security.h b/include/linux/security.h
> index 03c125b277ca..61e3f4a62d16 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -91,6 +91,7 @@ enum lockdown_reason {
>  	LOCKDOWN_MSR,
>  	LOCKDOWN_ACPI_TABLES,
>  	LOCKDOWN_PCMCIA_CIS,
> +	LOCKDOWN_TIOCSSERIAL,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_CONFIDENTIALITY_MAX,
>  };
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
> index 7be3e8fb5847..c89046dc2155 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -27,6 +27,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_MSR] = "raw MSR access",
>  	[LOCKDOWN_ACPI_TABLES] = "modified ACPI tables",
>  	[LOCKDOWN_PCMCIA_CIS] = "direct PCMCIA CIS storage",
> +	[LOCKDOWN_TIOCSSERIAL] = "reconfiguration of serial port IO",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>  };
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook
