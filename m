From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 09:20:20 +0100
Message-ID: <3546486.lOZcZMmXYe@wuerfel>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-3-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-3-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 29 October 2014 15:00:46 Greg Kroah-Hartman wrote:
> +enum kdbus_ioctl_type {
> +       KDBUS_CMD_BUS_MAKE =            _IOW(KDBUS_IOCTL_MAGIC, 0x00,
> +                                            struct kdbus_cmd_make),
> +       KDBUS_CMD_DOMAIN_MAKE =         _IOW(KDBUS_IOCTL_MAGIC, 0x10,
> +                                            struct kdbus_cmd_make),
> +       KDBUS_CMD_ENDPOINT_MAKE =       _IOW(KDBUS_IOCTL_MAGIC, 0x20,
> +                                            struct kdbus_cmd_make),
> +
> +       KDBUS_CMD_HELLO =               _IOWR(KDBUS_IOCTL_MAGIC, 0x30,
> +                                             struct kdbus_cmd_hello),
> +       KDBUS_CMD_BYEBYE =              _IO(KDBUS_IOCTL_MAGIC, 0x31),
> +
> +       KDBUS_CMD_MSG_SEND =            _IOWR(KDBUS_IOCTL_MAGIC, 0x40,
> +                                             struct kdbus_msg),
> +       KDBUS_CMD_MSG_RECV =            _IOWR(KDBUS_IOCTL_MAGIC, 0x41,
> +                                             struct kdbus_cmd_recv),
> +       KDBUS_CMD_MSG_CANCEL =          _IOW(KDBUS_IOCTL_MAGIC, 0x42,
> +                                            struct kdbus_cmd_cancel),
> +       KDBUS_CMD_FREE =                _IOW(KDBUS_IOCTL_MAGIC, 0x43,
> +                                            struct kdbus_cmd_free),
> 

I think in general, using enum is great, but for ioctl command numbers,
we probably want to have defines so the user space implementation can
use #ifdef to see if the kernel version that it is being built for
knows a particular command.

You could do that using 

#define KDBUS_CMD_BUS_MAKE KDBUS_CMD_BUS_MAKE

while keeping the enum, or do it like everybody else using

#define KDBUS_CMD_BUS_MAKE _IOW(KDBUS_IOCTL_MAGIC, 0x00, struct kdbus_cmd_make)

which might in fact help some tools that try to do automated parsing
of header files to find ioctl commands.

	Arnd
