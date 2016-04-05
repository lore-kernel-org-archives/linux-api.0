From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 04/10] lib/uuid: introduce few more generic helpers
 for UUID
Date: Tue, 05 Apr 2016 17:15:58 +0300
Message-ID: <1459865758.17884.19.camel@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1459864579-55988-5-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459864579-55988-5-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2016-04-05 at 16:56 +0300, Andy Shevchenko wrote:
> There are new helpers in this patch:
> 
> uuid_is_valid		checks if a UUID is valid
> uuid_be_to_bin		converts from string to binary (big
> endian)
> uuid_le_to_bin		converts from string to binary (little
> endian)
> 
> They will be used in future, i.e. in the following patches in the
> series.
> 
> This also moves indices arrays to lib/uuid.c to be shared accross
> modules.
> 

> --- a/lib/uuid.c
> +++ b/lib/uuid.c

> +static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8
> ei[16])
> +{
> +	static const u8 si[16] =
> {0,2,4,6,9,11,14,16,19,21,24,26,28,30,32,34};
> +	unsigned int i;
> +
> +	if (uuid_is_valid(uuid))

Oops, sorry, typo is here, should be negative check.

if (!uuid_is_valid(uuid))


> +		return -EINVAL;
> +
> +	for (i = 0; i < 16; i++) {
> +		int hi = hex_to_bin(uuid[si[i]] + 0);
> +		int lo = hex_to_bin(uuid[si[i]] + 1);
> +
> +		b[ei[i]] = (hi << 4) | lo;
> +	}
> +
> +	return 0;
> +}

-- 
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
