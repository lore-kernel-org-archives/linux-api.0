From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 06/37] alarmtimer: Provide get_timespec() callback
Date: Wed, 7 Aug 2019 08:04:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908070803030.24014@nanos.tec.linutronix.de>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-7-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-7-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 29 Jul 2019, Dmitry Safonov wrote:
>  /**
> @@ -869,8 +871,10 @@ static int __init alarmtimer_init(void)
>  	/* Initialize alarm bases */
>  	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
>  	alarm_bases[ALARM_REALTIME].get_ktime = &ktime_get_real;
> +	alarm_bases[ALARM_REALTIME].get_timespec = posix_get_timespec,

That's just wrong:

>  /*
>   * Get monotonic time for posix timers
>   */
> -static int posix_get_timespec(clockid_t which_clock, struct timespec64 *tp)
> +int posix_get_timespec(clockid_t which_clock, struct timespec64 *tp)
>  {
>  	ktime_get_ts64(tp);
>  	return 0;

Using a proper function name would have avoided this.
