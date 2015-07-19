From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iio: Documentation: Remove bytes_per_datum attribute
Date: Sun, 19 Jul 2015 10:29:08 +0100
Message-ID: <55AB6DE4.1010300@kernel.org>
References: <5fde6d1bda5e397469400876e3cc1c70243f31fb.1437257911.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5fde6d1bda5e397469400876e3cc1c70243f31fb.1437257911.git.cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 18/07/15 23:33, Cristina Opriceana wrote:
> Remove sysfs bytes_per_datum device attribute ABI documentation
> since the attribute is not present anymore.
> 
> Signed-off-by: Cristina Opriceana <cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Good spot.

Applied to the togreg branch of iio.git.

Jonathan
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 666a341..400d234 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -1040,13 +1040,6 @@ Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  Description:
>  		Number of scans contained by the buffer.
>  
> -What:		/sys/bus/iio/devices/iio:deviceX/buffer/bytes_per_datum
> -KernelVersion:	2.6.37
> -Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> -Description:
> -		Bytes per scan.  Due to alignment fun, the scan may be larger
> -		than implied directly by the scan_element parameters.
> -
>  What:		/sys/bus/iio/devices/iio:deviceX/buffer/enable
>  KernelVersion:	2.6.35
>  Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
