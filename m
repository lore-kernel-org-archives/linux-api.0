From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 14:54:02 +0200
Message-ID: <20170629125402.GH26046@kroah.com>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170614222017.14653-3-mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.orgs
List-Id: linux-api@vger.kernel.org

On Wed, Jun 14, 2017 at 03:20:15PM -0700, Luis R. Rodriguez wrote:
> Code in kernel which incorrectly used the non-killable variants could
> end up having waits killed improperly. The respective killable waits
> have been upstream for a while:
> 
>   o wait_for_completion_killable()
>   o wait_for_completion_killable_timeout()
> 
> swait has been upstream since v4.6. Older kernels have had the
> above variants in place for a long time.
> 
> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.6
> Signed-off-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/swait.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/swait.h b/include/linux/swait.h
> index c1f9c62a8a50..2c700694d50a 100644
> --- a/include/linux/swait.h
> +++ b/include/linux/swait.h
> @@ -169,4 +169,29 @@ do {									\
>  	__ret;								\
>  })
>  
> +#define __swait_event_killable(wq, condition)				\
> +	___swait_event(wq, condition, TASK_KILLABLE, 0, schedule())
> +
> +#define swait_event_killable(wq, condition)				\
> +({									\
> +	int __ret = 0;							\
> +	if (!(condition))						\
> +		__ret = __swait_event_killable(wq, condition);		\
> +	__ret;								\
> +})
> +
> +#define __swait_event_killable_timeout(wq, condition, timeout)		\
> +	___swait_event(wq, ___wait_cond_timeout(condition),		\
> +		       TASK_KILLABLE, timeout,				\
> +		       __ret = schedule_timeout(__ret))
> +
> +#define swait_event_killable_timeout(wq, condition, timeout)		\
> +({									\
> +	long __ret = timeout;						\
> +	if (!___wait_cond_timeout(condition))				\
> +		__ret = __swait_event_killable_timeout(wq,		\
> +						condition, timeout);	\
> +	__ret;								\
> +})
> +
>  #endif /* _LINUX_SWAIT_H */

Do you really still want to add these, now that we know we shouldn't be
using swait in "real" code? :)

thanks,

greg k-h
