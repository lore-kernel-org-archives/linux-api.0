From: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] iio: Documentation: Add trigger name attribute ABI documentation
Date: Thu, 6 Aug 2015 15:00:25 +0300
Message-ID: <CAEnQRZDH3Gu_FSiSrceC3nK4SOwKj+6WCzxdc9iU9DMsZmmrTA@mail.gmail.com>
References: <7d408fb8def6478565e30d01edcfc98d9cf42b48.1438859058.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7d408fb8def6478565e30d01edcfc98d9cf42b48.1438859058.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 6, 2015 at 2:17 PM, Cristina Opriceana
<cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds an entry in ABI Documentation for the name attribute
> issued when a trigger is created.
>
> Signed-off-by: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
> Changes in v2:
>  - deviceX to deviceY, to avoid confusion
>  - clearer description
>
>  Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
> index 5235e6c..0c1e843 100644
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
> +               trigger. In order to associate the trigger with an IIO device
> +               one should write this name string to
> +               /sys/bus/iio/devices/iio:deviceY/trigger/current_trigger.
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
