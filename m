From: Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH] perf_event_open.2: 4.9 PERF_EVENT_IOC_SET_DRV_CONFIGS
 support
Date: Fri, 12 Aug 2016 13:57:51 -0400 (EDT)
Message-ID: <alpine.DEB.2.11.1608121351590.15187@pianoman.cluster.toy>
References: <1470935365-2097-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470935365-2097-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 11 Aug 2016, Mathieu Poirier wrote:
> +.TP
> +.BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
> +This makes it possible to pass configuration parameters to PMU drivers.
> +Configuration parameters are specific to each drivers.
> +
> +The argument is a pointer to the desired configuration parameters.

So I gave up and read the code and I'm guessing this is what you really 
mean:

.TP
.BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
Pass custom configuration paramaters to a PMU driver.

The argument is a pointer to a NUL-termiated string of up to
PAGE_SIZE in length.
The string contains a list of comma-separated configuration options
that will be parsed by the kernel.
The kernel handles both singleton values as well as name/value pairs
that are indicated with the '=' character.
The size of the strings is limited internally to PERF_DRV_CONFIG_MAX
(which is not visible to userspace).



some additional questions: can this ioctl be run at any time or should it 
only be run while the event is quiet?  Does the change in options take
place immediately?

Vince
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
