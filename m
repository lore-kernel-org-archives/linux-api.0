From: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] iio: Documentation: Add trigger name attribute ABI documentation
Date: Thu, 6 Aug 2015 10:33:11 +0300
Message-ID: <CAEnQRZAKq-Fp8YcKT2z_ADrEjSs5zoh2qBvJ8jKbCZ5S6N2F6g@mail.gmail.com>
References: <998736994e24f0bc3e7864b1e6b6e0de607c8447.1438793211.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <998736994e24f0bc3e7864b1e6b6e0de607c8447.1438793211.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

+ linux-iio.

On Wed, Aug 5, 2015 at 8:09 PM, Cristina Opriceana
<cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds an entry in the ABI Documentation for the
> name attribute issued when a trigger is created.
>
> Signed-off-by: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
> index 5235e6c..85c8e4d 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
> @@ -9,3 +9,12 @@ Description:
>                 automated testing or in situations, where other trigger methods
>                 are not applicable. For example no RTC or spare GPIOs.
>                 X is the IIO index of the trigger.
> +
> +What:          /sys/bus/iio/devices/triggerX/name
> +KernelVersion: 2.6.39
> +Contact:       linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:
> +               The name attribute holds a description string for the current
> +               trigger. A device should write this name string to
> +               /sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
> +               in order to use this trigger.

Better, "In order to associate this trigger with an IIO device one
should write this name string to /sys/bus/...".
Also, please use iio:deviceY instead of iio:deviceX to make it clear
that trigger and device indexes are not
related.

thanks,
Daniel.
