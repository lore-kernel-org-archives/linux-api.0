From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH] add support for Freescale's MMA8653FC 10 bit
 accelerometer
Date: Tue, 17 Mar 2015 20:00:43 +0100
Message-ID: <1426618843.15575.5.camel@x220>
References: <1426612146-7836-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426612146-7836-1-git-send-email-martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Just a license nit.

On Tue, 2015-03-17 at 18:09 +0100, Martin Kepplinger wrote:
> --- /dev/null
> +++ b/drivers/input/misc/mma8653fc.c

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

This states the license is GPL v2.

> +MODULE_LICENSE("GPL");

And
    MODULE_LICENSE("GPL v2");

would match that statement.


Paul Bolle
