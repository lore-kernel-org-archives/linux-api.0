From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [RESEND PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Tue, 8 Jan 2019 08:01:10 +0100
Message-ID: <20190108070110.GA7998@light.dominikbrodowski.net>
References: <20190107222700.15954-1-christian@brauner.io>
 <20190107222700.15954-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190107222700.15954-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 07, 2019 at 11:27:00PM +0100, Christian Brauner wrote:
> @@ -2833,6 +2836,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  				break;
>  			if (neg)
>  				continue;
> +			if ((max && val > *max) || (min && val < *min)) {
> +				err = -EINVAL;
> +				break;
> +			}
>  			val = convmul * val / convdiv;
>  			if ((min && val < *min) || (max && val > *max))
>  				continue;

This is a generic change which affects all users of
do_proc_doulongvec_minmax() that have extra1 or extra2 set. In sysctl.c, I
do not see another user of proc_doulongvec_minmax() that has extra1 or
extra2 set. However, have you verified whether your patch changes the
behaviour for other files that make use of proc_doulongvec_minmax() or
proc_doulongvec_ms_jiffies_minmax(), and not only of the file-max sysctl?

Thanks,
	Dominik
