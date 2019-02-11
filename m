From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC PATCH v4 3/3] sysctl: return -EINVAL if val violates minmax
Date: Mon, 11 Feb 2019 11:50:25 -0800
Message-ID: <20190211195025.GT11489@garbanzo.do-not-panic.com>
References: <20190210203943.8227-1-christian@brauner.io>
 <20190210203943.8227-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190210203943.8227-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Feb 10, 2019 at 09:39:43PM +0100, Christian Brauner wrote:
> Currently when userspace gives us a values that overflow e.g. file-max and
> other callers of __do_proc_doulongvec_minmax() we simply
> ignore the new value and leave the current value untouched. This can be
> problematic as it gives the illusion that the limit has indeed be bumped
> when in fact it failed.
> This commit makes sure to return EINVAL when an overflow is detected.
> Please note that this is a userspace facing change.
> 

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

> Signed-off-by: Christian Brauner <christian@brauner.io>
> ---
> /* Changelog */
> v4:
> - patch introduced
> 
> v1-v3:
> - patch not present
> ---
>  kernel/sysctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c4a44b7ccb8a..516bc8a2812d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2846,8 +2846,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  			if (neg)
>  				continue;
>  			val = convmul * val / convdiv;
> -			if ((min && val < *min) || (max && val > *max))
> -				continue;
> +			if ((min && val < *min) || (max && val > *max)) {
> +				err = -EINVAL;
> +				break;
> +			}
>  			*i = val;
>  		} else {
>  			val = convdiv * (*i) / convmul;
> -- 
> 2.20.1
> 
