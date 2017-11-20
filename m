From: peter enderborg <peter.enderborg@sony.com>
Subject: Re: [PATCH] time: Make NTP optionnal
Date: Mon, 20 Nov 2017 15:10:07 +0100
Message-ID: <dd52374f-af2d-3ff1-b9cf-fbf28634a739@sony.com>
References: <20171102182950.6129-1-romain.perier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102182950.6129-1-romain.perier@gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Romain Perier <romain.perier@gmail.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

I think it should return a error code at least.

On 11/02/2017 07:29 PM, Romain Perier wrote:
> On embedded systems with limited space, synchronizing system clock via
> NTP might be not needed.
>
> This commit introduces a new Kconfig entry. When disabled, it compiles
> out the adjtimex and clock_adjtimes system calls. The corresponding NTP
> accessors are also disabled from timekeeping.c and their declaration are
> replaced by no_op static inline functions in time.h
>
> The bloat-o-meter output is the following:
>
> add/remove: 1/35 grow/shrink: 2/9 up/down: 170/-3760 (-3590)
> function                                     old     new   delta
> tk_set_wall_to_mono.constprop                  -     164    +164
> tk_xtime_add.constprop                       200     204      +4
> timespec_trunc                                60      62      +2
> ntp_notify_cmos_timer                          2       -      -2
> k_itimer_rcu_free                             18      16      -2
> timekeeping_forward_now.constprop            256     252      -4
> time_status                                    4       -      -4
> time_state                                     4       -      -4
> time_maxerror                                  4       -      -4
> time_esterror                                  4       -      -4
> time_constant                                  4       -      -4
> time_adjust                                    4       -      -4
> tick_usec                                      4       -      -4
> tick_nsec                                      4       -      -4
> ntp_init                                       4       -      -4
> posix_clock_realtime_adj                       6       -      -6
> time_reftime                                   8       -      -8
> time_offset                                    8       -      -8
> time_freq                                      8       -      -8
> tick_length_base                               8       -      -8
> tick_length                                    8       -      -8
> ntp_tick_adj                                   8       -      -8
> ntp_next_leap_sec                              8       -      -8
> mask_to_bit_num                                8       -      -8
> mask_to_allowed_status                         8       -      -8
> ntp_tick_length                               12       -     -12
> __setup_ntp_tick_adj_setup                    12       -     -12
> __setup_str_ntp_tick_adj_setup                14       -     -14
> timekeeping_resume                           614     598     -16
> timekeeping_inject_offset                    352     336     -16
> timekeeping_init                             400     384     -16
> do_settimeofday64                            342     326     -16
> ntp_tick_adj_setup                            28       -     -28
> timekeeping_update                           236     206     -30
> branch_table                                  32       -     -32
> sys_adjtimex                                  42       -     -42
> sys_clock_adjtime                             64       -     -64
> ntp_clear                                     72       -     -72
> ntp_get_next_leap                             76       -     -76
> ntp_validate_timex                            78       -     -78
> tk_set_wall_to_mono                          166       -    -166
> ntp_update_frequency                         180       -    -180
> update_wall_time                            1846    1590    -256
> do_adjtimex                                  272       -    -272
> second_overflow                              476       -    -476
> bcj_apply                                   1100     224    -876
> __do_adjtimex                                888       -    -888
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  include/linux/timex.h      | 14 +++++++++++---
>  init/Kconfig               |  9 +++++++++
>  kernel/compat.c            |  2 ++
>  kernel/sys_ni.c            |  6 ++++++
>  kernel/time/Makefile       |  6 +++++-
>  kernel/time/ntp_internal.h | 29 +++++++++++++++++++++++++++++
>  kernel/time/posix-timers.c | 13 ++++++++-----
>  kernel/time/time.c         |  4 ++--
>  kernel/time/timekeeping.c  |  2 ++
>  9 files changed, 74 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/timex.h b/include/linux/timex.h
> index 39c25dbebfe8..5906b654821a 100644
> --- a/include/linux/timex.h
> +++ b/include/linux/timex.h
> @@ -151,12 +151,20 @@ extern unsigned long tick_nsec;		/* SHIFTED_HZ period (nsec) */
>  #define NTP_INTERVAL_FREQ  (HZ)
>  #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
>  
> +#ifdef CONFIG_NTP
>  extern int do_adjtimex(struct timex *);
>  extern void hardpps(const struct timespec64 *, const struct timespec64 *);
> -
> -int read_current_timer(unsigned long *timer_val);
>  void ntp_notify_cmos_timer(void);
> -
> +#else
> +static inline int do_adjtimex(struct timex *txc)
> +{
> +	return TIME_OK;
> +}
> +static inline void hardpps(const struct timespec64 *phase_ts,
> +			   const struct timespec64 *raw_ts)
> +{}
> +#endif
> +int read_current_timer(unsigned long *timer_val);
>  /* The clock frequency of the i8253/i8254 PIT */
>  #define PIT_TICK_RATE 1193182ul
>  
> diff --git a/init/Kconfig b/init/Kconfig
> index 3c1faaa2af4a..d4b0b33f7e91 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1332,6 +1332,15 @@ config EVENTFD
>  
>  	  If unsure, say Y.
>  
> +config NTP
> +	bool "Enable NTP support" if EXPERT
> +	default y
> +	help
> +	  This enables support for synchronizing system clock with NTP
> +	  and its corresponding syscalls adjtimex and clock_adjtimex.
> +
> +          If unsure, say Y.
> +
>  # syscall, maps, verifier
>  config BPF_SYSCALL
>  	bool "Enable bpf() system call"
> diff --git a/kernel/compat.c b/kernel/compat.c
> index 772e038d04d9..12945ae5ae94 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -30,6 +30,7 @@
>  
>  #include <linux/uaccess.h>
>  
> +#ifdef CONFIG_NTP
>  int compat_get_timex(struct timex *txc, const struct compat_timex __user *utp)
>  {
>  	struct compat_timex tx32;
> @@ -91,6 +92,7 @@ int compat_put_timex(struct compat_timex __user *utp, const struct timex *txc)
>  		return -EFAULT;
>  	return 0;
>  }
> +#endif
>  
>  static int __compat_get_timeval(struct timeval *tv, const struct compat_timeval __user *ctv)
>  {
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 8acef8576ce9..f854d24b813c 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -258,3 +258,9 @@ cond_syscall(sys_membarrier);
>  cond_syscall(sys_pkey_mprotect);
>  cond_syscall(sys_pkey_alloc);
>  cond_syscall(sys_pkey_free);
> +#ifndef CONFIG_NTP
> +cond_syscall(sys_adjtimex);
> +cond_syscall(sys_clock_adjtime);
> +cond_syscall(compat_sys_adjtimex);
> +cond_syscall(compat_sys_clock_adjtime);
> +#endif
> diff --git a/kernel/time/Makefile b/kernel/time/Makefile
> index 938dbf33ef49..44bd321e4560 100644
> --- a/kernel/time/Makefile
> +++ b/kernel/time/Makefile
> @@ -1,7 +1,11 @@
>  obj-y += time.o timer.o hrtimer.o
> -obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
> +obj-y += timekeeping.o clocksource.o jiffies.o timer_list.o
>  obj-y += timeconv.o timecounter.o alarmtimer.o
>  
> +ifeq ($(CONFIG_NTP),y)
> + obj-y += ntp.o
> +endif
> +
>  ifeq ($(CONFIG_POSIX_TIMERS),y)
>   obj-y += posix-timers.o posix-cpu-timers.o posix-clock.o itimer.o
>  else
> diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
> index d8a7c11fa71a..9d1ebc042968 100644
> --- a/kernel/time/ntp_internal.h
> +++ b/kernel/time/ntp_internal.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_NTP_INTERNAL_H
>  #define _LINUX_NTP_INTERNAL_H
>  
> +#ifdef CONFIG_NTP
>  extern void ntp_init(void);
>  extern void ntp_clear(void);
>  /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
> @@ -10,4 +11,32 @@ extern int second_overflow(time64_t secs);
>  extern int ntp_validate_timex(struct timex *);
>  extern int __do_adjtimex(struct timex *, struct timespec64 *, s32 *);
>  extern void __hardpps(const struct timespec64 *, const struct timespec64 *);
> +#else
> +static inline void ntp_init(void)
> +{}
> +static inline void ntp_clear(void)
> +{}
> +static inline u64 ntp_tick_length(void)
> +{
> +	return 0;
> +}
> +static inline ktime_t ntp_get_next_leap(void)
> +{
> +	return KTIME_MAX;
> +}
> +static inline int second_overflow(time64_t secs)
> +{
> +	return 0;
> +}
> +static inline int ntp_validate_timex(struct timex *txc)
> +{
> +	return 0;
> +}
> +static inline int __do_adjtimex(struct timex *txc, struct timespec64 *ts,
> +				s32 *time_tai)
> +{
> +	return TIME_OK;
> +}
> +#endif
> +
>  #endif /* _LINUX_NTP_INTERNAL_H */
> diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
> index 13d6881f908b..dd31eaddc196 100644
> --- a/kernel/time/posix-timers.c
> +++ b/kernel/time/posix-timers.c
> @@ -207,12 +207,13 @@ static int posix_clock_realtime_set(const clockid_t which_clock,
>  	return do_sys_settimeofday64(tp, NULL);
>  }
>  
> +#ifdef CONFIG_NTP
>  static int posix_clock_realtime_adj(const clockid_t which_clock,
>  				    struct timex *t)
>  {
>  	return do_adjtimex(t);
>  }
> -
> +#endif
>  /*
>   * Get monotonic time for posix timers
>   */
> @@ -1065,7 +1066,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
>  
>  	return error;
>  }
> -
> +#ifdef CONFIG_NTP
>  SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
>  		struct timex __user *, utx)
>  {
> @@ -1088,7 +1089,7 @@ SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
>  
>  	return err;
>  }
> -
> +#endif
>  SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
>  		struct timespec __user *, tp)
>  {
> @@ -1141,7 +1142,7 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
>  
>  	return err;
>  }
> -
> +#ifdef CONFIG_NTP
>  COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>  		       struct compat_timex __user *, utp)
>  {
> @@ -1165,7 +1166,7 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>  
>  	return err;
>  }
> -
> +#endif
>  COMPAT_SYSCALL_DEFINE2(clock_getres, clockid_t, which_clock,
>  		       struct compat_timespec __user *, tp)
>  {
> @@ -1252,7 +1253,9 @@ static const struct k_clock clock_realtime = {
>  	.clock_getres		= posix_get_hrtimer_res,
>  	.clock_get		= posix_clock_realtime_get,
>  	.clock_set		= posix_clock_realtime_set,
> +#ifdef CONFIG_NTP
>  	.clock_adj		= posix_clock_realtime_adj,
> +#endif
>  	.nsleep			= common_nsleep,
>  	.timer_create		= common_timer_create,
>  	.timer_set		= common_timer_set,
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index 44a8c1402133..413eca43a09c 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -297,7 +297,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct compat_timeval __user *, tv,
>  	return do_sys_settimeofday64(tv ? &new_ts : NULL, tz ? &new_tz : NULL);
>  }
>  #endif
> -
> +#ifdef CONFIG_NTP
>  SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
>  {
>  	struct timex txc;		/* Local copy of parameter */
> @@ -333,7 +333,7 @@ COMPAT_SYSCALL_DEFINE1(adjtimex, struct compat_timex __user *, utp)
>  	return ret;
>  }
>  #endif
> -
> +#endif
>  /*
>   * Convert jiffies to milliseconds and back.
>   *
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 2cafb49aa65e..223fe15daa75 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -2247,6 +2247,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
>  	return base;
>  }
>  
> +#ifdef CONFIG_NTP
>  /**
>   * do_adjtimex() - Accessor function to NTP __do_adjtimex function
>   */
> @@ -2317,6 +2318,7 @@ void hardpps(const struct timespec64 *phase_ts, const struct timespec64 *raw_ts)
>  }
>  EXPORT_SYMBOL(hardpps);
>  #endif /* CONFIG_NTP_PPS */
> +#endif /* CONFIG_NTP */
>  
>  /**
>   * xtime_update() - advances the timekeeping infrastructure
