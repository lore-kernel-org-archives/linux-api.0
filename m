From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2] perf: Add PERF_EVENT_IOC_FLUSH ioctl
Date: Wed, 20 May 2015 14:12:26 +0200
Message-ID: <20150520121226.GA11195@gmail.com>
References: <20150507142009.GX22099@nuc-i3427.alporthouse.com>
 <1431969919-32233-1-git-send-email-robert@sixbynine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431969919-32233-1-git-send-email-robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
Cc: intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org> wrote:

> To allow for pmus that may have internal buffering (e.g. the hardware
> itself writes out data to its own circular buffer which is only
> periodically forwarded to userspace via perf) this ioctl enables
> userspace to explicitly ensure it has received all samples before a
> point in time.
> 
> v2: return int error status
> 
> Signed-off-by: Robert Bragg <robert-St23OQVBDYPNLxjTenLetw@public.gmane.org>
> ---
>  include/linux/perf_event.h      | 7 +++++++
>  include/uapi/linux/perf_event.h | 1 +
>  kernel/events/core.c            | 5 +++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index cf1d096..0c591eb 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -305,6 +305,13 @@ struct pmu {
>  	 * Free pmu-private AUX data structures
>  	 */
>  	void (*free_aux)		(void *aux); /* optional */
> +
> +	/*
> +	 * Flush buffered samples (E.g. for pmu hardware that writes samples to
> +	 * some intermediate buffer) userspace may need to explicitly ensure
> +	 * such samples have been forwarded to perf.
> +	 */
> +	int (*flush)			(struct perf_event *event); /*optional */
>  };
>  
>  /**
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 309211b..cbf1b80 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -389,6 +389,7 @@ struct perf_event_attr {
>  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
>  #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
>  #define PERF_EVENT_IOC_SET_BPF		_IOW('$', 8, __u32)
> +#define PERF_EVENT_IOC_FLUSH		_IO ('$', 9)
>  
>  enum perf_event_ioc_flags {
>  	PERF_IOC_FLAG_GROUP		= 1U << 0,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 3fe532a..72daee6 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4079,6 +4079,11 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
>  	case PERF_EVENT_IOC_SET_BPF:
>  		return perf_event_set_bpf_prog(event, arg);
>  
> +	case PERF_EVENT_IOC_FLUSH:
> +		if (event->pmu->flush)
> +			return event->pmu->flush(event);
> +		return 0;
> +
>  	default:
>  		return -ENOTTY;
>  	}

So 'struct file_operations' has a callback for:

        int (*fsync) (struct file *, loff_t, loff_t, int datasync);

Could we use that perhaps, instead of an ioctl()? Not sure how it all 
integrates with the VFS though.

Thanks,

	Ingo
