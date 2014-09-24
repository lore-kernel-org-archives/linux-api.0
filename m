From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Wed, 24 Sep 2014 15:07:58 +0900
Message-ID: <87oau5k0u9.fsf@sejong.aot.lge.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-3-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411491787-25938-3-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org> (Pawel
	Moll's message of "Tue, 23 Sep 2014 18:03:07 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
> This patch adds a new PERF_COUNT_SW_UEVENT software event
> and a related PERF_SAMPLE_UEVENT sample. User can now
> write to the the perf file descriptor, injecting such
> event in the perf buffer.

It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
SW_DUMMY event for that purpose.

Also I think it'd be better to be a record type (PERF_RECORD_XXX)
instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
use perf_user_event_type for synthesized userspace events.  This way it
can avoid unnecessary sample processing for userspace events.

For contents, I prefer to give complete control to users - kernel
doesn't need to care about it other than its size.  If one just wants to
use strings only, she can write them directly.  If others want to mix
different types of data, they might need to define a data format for
their use.

Thanks,
Namhyung


>
> The UEVENT sample begins with a 32 bit unsigned integer
> value describing type of the generated event. The type
> can be set with PERF_EVENT_IOC_SET_UEVENT_TYPE ioctl
> (zero is the default value). Then follows the 32 bit
> unsigned size of the data (provided as the "count" argument
> of the write syscall) and the data itself plus padding
> aligning the overall sample size to 8 bytes.
>
> Data Events with type equal 0 are defined as zero-terminated
> strings, other types are defined by userspace (the perf tool
> will contain a list of known values with reference
> implementation of data content parsers).
>
> Possible use cases for this feature:
>
> - "perf_printf" like mechanism to add logging messages
>   to one's perf session; in the simplest case it can be just
>
> 	uint32_t type = 0;
> 	ioctl(perf_fd, PERF_EVENT_IOC_SET_UEVENT_TYPE, &type);
> 	dprintf(perf_fd, "Message");
>
>   (note that dprintf does *not* write the terminating '\0'; for
>    users' convenience kernel add it when type is set to zero)
>
> - "perf_printf" used by for perf trace tool,
>   where certain traced process' calls are intercepted
>   (eg. using LD_PRELOAD) and treated as logging
>   requests, with it output redirected into the
>   perf buffer
>
> - synchronisation of performance data generated in
>   user space with the perf stream coming from the kernel.
>   For example, the marker can be inserted by a JIT engine
>   after it generated portion of the code, but before the
>   code is executed for the first time, allowing the
>   post-processor to pick the correct debugging
>   information.
>
> - other example is a system profiling tool taking data
>   from other sources than just perf, which generates a marker
>   at the beginning at at the end of the session
>   (also possibly periodically during the session) to
>   synchronise kernel timestamps with clock values
>   obtained in userspace (gtod or raw_monotonic).
>
> Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
> ---
> Changes since v1:
>
> - replaced ioctl-based interface with write syscall
>   (there's still a ioctl to set an event type)
>
> - replaced all "USERSPACE_EVENT" and alike strings
>   with much shorter "UEVENT"
>
>  include/linux/perf_event.h      | 14 ++++++++
>  include/uapi/linux/perf_event.h | 24 ++++++++++++-
>  kernel/events/core.c            | 80 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 117 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 28b73b2..c130579 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -64,6 +64,12 @@ struct perf_raw_record {
>  	void				*data;
>  };
>  
> +struct perf_uevent {
> +	u32				type;
> +	u32				size;
> +	u8				data[0];
> +};
> +
>  /*
>   * branch stack layout:
>   *  nr: number of taken branches stored in entries[]
> @@ -433,6 +439,7 @@ struct perf_event {
>  
>  	struct pid_namespace		*ns;
>  	u64				id;
> +	u32				uevent_type;
>  
>  	perf_overflow_handler_t		overflow_handler;
>  	void				*overflow_handler_context;
> @@ -604,6 +611,8 @@ struct perf_sample_data {
>  	u64				txn;
>  	/* Raw monotonic timestamp, for userspace time correlation */
>  	u64				clock_raw_monotonic;
> +	/* Userspace-originating event */
> +	struct perf_uevent		*uevent;
>  };
>  
>  static inline void perf_sample_data_init(struct perf_sample_data *data,
> @@ -685,6 +694,9 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
>  	}
>  }
>  
> +int perf_uevent_write(struct perf_event *event, u32 type, u32 size,
> +		const char __user *data);
> +
>  extern struct static_key_deferred perf_sched_events;
>  
>  static inline void perf_event_task_sched_in(struct task_struct *prev,
> @@ -807,6 +819,8 @@ static inline int perf_event_refresh(struct perf_event *event, int refresh)
>  
>  static inline void
>  perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
> +static inline int perf_uevent_write(struct perf_event *event, u32 type,
> +		u32 size, const char __user *data)			{ return -EINVAL; }
>  static inline void
>  perf_bp_event(struct perf_event *event, void *data)			{ }
>  
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index e5a75c5..1fabc2c 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -110,6 +110,7 @@ enum perf_sw_ids {
>  	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
>  	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
>  	PERF_COUNT_SW_DUMMY			= 9,
> +	PERF_COUNT_SW_UEVENT			= 10,
>  
>  	PERF_COUNT_SW_MAX,			/* non-ABI */
>  };
> @@ -138,8 +139,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
>  	PERF_SAMPLE_TRANSACTION			= 1U << 17,
>  	PERF_SAMPLE_CLOCK_RAW_MONOTONIC		= 1U << 18,
> +	PERF_SAMPLE_UEVENT			= 1U << 19,
>  
> -	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 20,		/* non-ABI */
>  };
>  
>  /*
> @@ -350,6 +352,7 @@ struct perf_event_attr {
>  #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
>  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
>  #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
> +#define PERF_EVENT_IOC_SET_UEVENT_TYPE	_IOW('$', 8, __u32)
>  
>  enum perf_event_ioc_flags {
>  	PERF_IOC_FLAG_GROUP		= 1U << 0,
> @@ -688,6 +691,25 @@ enum perf_event_type {
>  	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
>  	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
>  	 *	{ u64			clock_raw_monotonic; } && PERF_SAMPLE_CLOCK_RAW_MONOTONIC
> +	 *
> +	 *	#
> +	 *	# Contents of UEVENT sample data depend on its type.
> +	 *	#
> +	 *	# Type 0 means that the data is a zero-terminated string that
> +	 *	# can be printf-ed in the normal way.
> +	 *	#
> +	 *	# Meaning of other type values depends on the userspace
> +	 *	# and the perf tool code contains a list of those with
> +	 *	# reference implementations of parsers.
> +	 *	#
> +	 *	# Overall size of the sample (including type and size fields)
> +	 *	# is always aligned to 8 bytes by adding padding after
> +	 *	# the data.
> +	 *	#
> +	 *	{ u32			type;
> +	 *	  u32			size;
> +	 *	  char			data[size];
> +	 *	  char                  __padding[] } && PERF_SAMPLE_UEVENT
>  	 * };
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f6df547..69ca8c9 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3526,6 +3526,15 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	return perf_read_hw(event, buf, count);
>  }
>  
> +static ssize_t
> +perf_write(struct file *file, const char __user *buf, size_t count,
> +		loff_t *ppos)
> +{
> +	struct perf_event *event = file->private_data;
> +
> +	return perf_uevent_write(event, event->uevent_type, count, buf);
> +}
> +
>  static unsigned int perf_poll(struct file *file, poll_table *wait)
>  {
>  	struct perf_event *event = file->private_data;
> @@ -3636,6 +3645,17 @@ unlock:
>  	return ret;
>  }
>  
> +static int perf_event_set_uevent_type(struct perf_event *event, u32 __user *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&event->uevent_type, arg, sizeof(*arg)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static const struct file_operations perf_fops;
>  
>  static inline int perf_fget_light(int fd, struct fd *p)
> @@ -3709,6 +3729,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	case PERF_EVENT_IOC_SET_FILTER:
>  		return perf_event_set_filter(event, (void __user *)arg);
>  
> +	case PERF_EVENT_IOC_SET_UEVENT_TYPE:
> +		return perf_event_set_uevent_type(event, (u32 __user *)arg);
> +
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -4244,6 +4267,7 @@ static const struct file_operations perf_fops = {
>  	.llseek			= no_llseek,
>  	.release		= perf_release,
>  	.read			= perf_read,
> +	.write			= perf_write,
>  	.poll			= perf_poll,
>  	.unlocked_ioctl		= perf_ioctl,
>  	.compat_ioctl		= perf_compat_ioctl,
> @@ -4727,6 +4751,16 @@ void perf_output_sample(struct perf_output_handle *handle,
>  	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC)
>  		perf_output_put(handle, data->clock_raw_monotonic);
>  
> +	if (sample_type & PERF_SAMPLE_UEVENT) {
> +		int size = data->uevent->size;
> +		int padding = ALIGN(size, sizeof(u64)) - size;
> +
> +		perf_output_put(handle, data->uevent->type);
> +		perf_output_put(handle, size);
> +		__output_copy(handle, data->uevent->data, size);
> +		perf_output_skip(handle, padding);
> +	};
> +
>  	if (!event->attr.watermark) {
>  		int wakeup_events = event->attr.wakeup_events;
>  
> @@ -4834,6 +4868,10 @@ void perf_prepare_sample(struct perf_event_header *header,
>  		data->stack_user_size = stack_size;
>  		header->size += size;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_UEVENT)
> +		header->size += sizeof(u32) + sizeof(u32) +
> +				ALIGN(data->uevent->size, sizeof(u64));
>  }
>  
>  static void perf_event_output(struct perf_event *event,
> @@ -5961,6 +5999,48 @@ static struct pmu perf_swevent = {
>  	.event_idx	= perf_swevent_event_idx,
>  };
>  
> +int perf_uevent_write(struct perf_event *event, u32 type, u32 size,
> +		const char __user *data)
> +{
> +	struct perf_uevent *uevent;
> +	struct perf_sample_data sample;
> +	struct pt_regs *regs = current_pt_regs();
> +
> +	/* Need some sane limit */
> +	if (size > PAGE_SIZE)
> +		return -EFBIG;
> +
> +	/*
> +	 * Type 0 means zero-terminated string, but standard dprintf()
> +	 * doesn't write the zero character. Let's allocate one more byte
> +	 * for such event...
> +	 */
> +	uevent = kmalloc(sizeof(*uevent) + size + (type == 0 ? 1 : 0),
> +			GFP_KERNEL);
> +	if (!uevent)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(uevent->data, data, size)) {
> +		kfree(uevent);
> +		return -EFAULT;
> +	}
> +
> +	/* ... and then zero it, if necessary. */
> +	if (type == 0 && uevent->data[size - 1])
> +		uevent->data[size++] = '\0';
> +
> +	uevent->type = type;
> +	uevent->size = size;
> +
> +	perf_sample_data_init(&sample, 0, 0);
> +	sample.uevent = uevent;
> +	perf_event_output(event, &sample, regs);
> +
> +	kfree(uevent);
> +
> +	return size;
> +}
> +
>  #ifdef CONFIG_EVENT_TRACING
>  
>  static int perf_tp_filter_match(struct perf_event *event,
