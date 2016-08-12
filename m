From: Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH] perf_event_open.2: 4.9 PERF_EVENT_IOC_SET_DRV_CONFIGS
 support
Date: Fri, 12 Aug 2016 12:52:42 -0400 (EDT)
Message-ID: <alpine.DEB.2.11.1608121248100.10883@pianoman.cluster.toy>
References: <1470935365-2097-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470935365-2097-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 11 Aug 2016, Mathieu Poirier wrote:

> This manpage patch relates to the addition of the
> PERF_EVENT_IOC_SET_DRV_CONFIGS ioctl.
> 
> link: http://www.spinics.net/lists/kernel/msg2318998.html
> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  man2/perf_event_open.2 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/man2/perf_event_open.2 b/man2/perf_event_open.2
> index 3c894ccd1209..315b6a91079a 100644
> --- a/man2/perf_event_open.2
> +++ b/man2/perf_event_open.2
> @@ -2732,6 +2732,12 @@ The argument is a BPF program file descriptor that was created by
>  a previous
>  .BR bpf (2)
>  system call.
> +.TP
> +.BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
> +This makes it possible to pass configuration parameters to PMU drivers.
> +Configuration parameters are specific to each drivers.
> +
> +The argument is a pointer to the desired configuration parameters.
>  .SS Using prctl
>  A process can enable or disable all the event groups that are
>  attached to it using the

This is a bit... vague.  So we're adding an interface to allow passing 
arbitrary binary blobs through the perf_event interface?

Is there any structure at all to these blobs?  From the other commit 
messages it looked like you'd be passing in some sort of string.

Vince
