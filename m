From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 10/14] serial: pic32_uart: Add PIC32 UART driver
Date: Fri, 15 Apr 2016 18:28:32 +0100
Message-ID: <CAPKp9uYOnhJhNq8YDVRMpLSmGa7yWsktYnhVsMdWLtH1Jru3bw@mail.gmail.com>
References: <1452734299-460-1-git-send-email-joshua.henderson@microchip.com>
	<1452734299-460-11-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452734299-460-11-git-send-email-joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Andrei Pistirica <andrei.pistirica-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

I just noticed this now. I am having similar issue with MPS2 UART driver
posted @[1], hence I am asking here to get some clarification myself.
Sorry for replying on very old thread.

On Thu, Jan 14, 2016 at 1:15 AM, Joshua Henderson
<joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org> wrote:
> From: Andrei Pistirica <andrei.pistirica-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
>
> This adds UART and a serial console driver for Microchip PIC32 class
> devices.
>
> Signed-off-by: Andrei Pistirica <andrei.pistirica-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> Signed-off-by: Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
> Cc: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>

[...]

> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> index 93ba148..9df0a98 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -261,4 +261,7 @@
>  /* STM32 USART */
>  #define PORT_STM32     113
>
> +/* Microchip PIC32 UART */
> +#define PORT_PIC32     114

This was posted before v4.6-rc1 similar to MPS2 UART and has taken
port# 114 for it. However MVEBU UART obtained 114 with v4.6-rc1
And MPS2 UART was assigned 115 when it got revised/reposted.

I also see this patch in linux-next with 114 itself as its port number.
So the allocation of port number needs to be resolved before it gets
merged or it's OK to wait for v4.7-rc1 ?

If it's former, can PORT_PIC32 take 116 as the latest post of MPS2 assigned
it 115 and I have pulled the same to take it via arm-soc.

I am fine with any solution, just want to be notified if I need to
take any action.

Regards,
Sudeep

[1] http://www.spinics.net/lists/devicetree/msg120727.html
