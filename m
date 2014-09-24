From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Wed, 24 Sep 2014 14:41:46 +0900
Message-ID: <87sijhk21x.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-2-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411491787-25938-2-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org> (Pawel
	Moll's message of "Tue, 23 Sep 2014 18:03:06 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Pawel,

On Tue, 23 Sep 2014 18:03:06 +0100, Pawel Moll wrote:
> This patch adds an option to sample raw monotonic clock
> value with any perf event, with the the aim of allowing
> time correlation between data coming from perf and
> additional performance-related information generated in
> userspace.
>
> In order to correlate timestamps in perf data stream
> with events happening in userspace (be it JITed debug
> symbols or hwmon-originating environment data), user
> requests a more or less periodic event (sched_switch
> trace event of a hrtimer-based cpu-clock being the
> most obvious examples) with PERF_SAMPLE_TIME *and*
> PERF_SAMPLE_CLOCK_RAW_MONOTONIC and stamps
> user-originating data with values obtained from
> clock_gettime(CLOCK_MONOTONIC_RAW). Then, during
> analysis, one looks at the perf events immediately
> preceding and following (in terms of the
> clock_raw_monotonic sample) the userspace event and
> does simple linear approximation to get the equivalent
> perf time.
>
>         perf event     user event
>        -----O--------------+-------------O------> t_mono
>             :              |             :
>             :              V             :
>        -----O----------------------------O------> t_perf

Probably a dumb question: why not make PERF_SAMPLE_TIME being monotonic
clock instead of adding a new PERF_SAMPLE_CLOCK_XXX flag?  Maybe we can
add a new ioctl command like PERF_EVENT_IOC_SET_CLOCK so that one can
pass a clock id.

Thanks,
Namhyung


>
> Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
> ---
> Changes since v1:
>
> - none
>
>  include/linux/perf_event.h      |  2 ++
>  include/uapi/linux/perf_event.h |  4 +++-
>  kernel/events/core.c            | 13 +++++++++++++
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 707617a..28b73b2 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -602,6 +602,8 @@ struct perf_sample_data {
>  	 * Transaction flags for abort events:
>  	 */
>  	u64				txn;
> +	/* Raw monotonic timestamp, for userspace time correlation */
> +	u64				clock_raw_monotonic;
>  };
>  
>  static inline void perf_sample_data_init(struct perf_sample_data *data,
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 9269de2..e5a75c5 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -137,8 +137,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_DATA_SRC			= 1U << 15,
>  	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
>  	PERF_SAMPLE_TRANSACTION			= 1U << 17,
> +	PERF_SAMPLE_CLOCK_RAW_MONOTONIC		= 1U << 18,
>  
> -	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
>  };
>  
>  /*
> @@ -686,6 +687,7 @@ enum perf_event_type {
>  	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
>  	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
>  	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
> +	 *	{ u64			clock_raw_monotonic; } && PERF_SAMPLE_CLOCK_RAW_MONOTONIC
>  	 * };
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f9c1ed0..f6df547 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1216,6 +1216,9 @@ static void perf_event__header_size(struct perf_event *event)
>  	if (sample_type & PERF_SAMPLE_TRANSACTION)
>  		size += sizeof(data->txn);
>  
> +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC)
> +		size += sizeof(data->clock_raw_monotonic);
> +
>  	event->header_size = size;
>  }
>  
> @@ -4456,6 +4459,13 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>  		data->cpu_entry.cpu	 = raw_smp_processor_id();
>  		data->cpu_entry.reserved = 0;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC) {
> +		struct timespec now;
> +
> +		getrawmonotonic(&now);
> +		data->clock_raw_monotonic = timespec_to_ns(&now);
> +	}
>  }
>  
>  void perf_event_header__init_id(struct perf_event_header *header,
> @@ -4714,6 +4724,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>  	if (sample_type & PERF_SAMPLE_TRANSACTION)
>  		perf_output_put(handle, data->txn);
>  
> +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC)
> +		perf_output_put(handle, data->clock_raw_monotonic);
> +
>  	if (!event->attr.watermark) {
>  		int wakeup_events = event->attr.wakeup_events;
