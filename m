From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv5 06/37] alarmtimer: Provide get_timespec() callback
Date: Wed, 7 Aug 2019 23:18:19 -0700
Message-ID: <20190808061819.GA20004@gmail.com>
References: <20190729215758.28405-1-dima@arista.com>
 <20190729215758.28405-7-dima@arista.com>
 <alpine.DEB.2.21.1908070803030.24014@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908070803030.24014@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 07, 2019 at 08:04:10AM +0200, Thomas Gleixner wrote:
> On Mon, 29 Jul 2019, Dmitry Safonov wrote:
> >  /**
> > @@ -869,8 +871,10 @@ static int __init alarmtimer_init(void)
> >  	/* Initialize alarm bases */
> >  	alarm_bases[ALARM_REALTIME].base_clockid = CLOCK_REALTIME;
> >  	alarm_bases[ALARM_REALTIME].get_ktime = &ktime_get_real;
> > +	alarm_bases[ALARM_REALTIME].get_timespec = posix_get_timespec,
> 
> That's just wrong:
> 
> >  /*
> >   * Get monotonic time for posix timers
> >   */
> > -static int posix_get_timespec(clockid_t which_clock, struct timespec64 *tp)
> > +int posix_get_timespec(clockid_t which_clock, struct timespec64 *tp)
> >  {
> >  	ktime_get_ts64(tp);
> >  	return 0;
> 
> Using a proper function name would have avoided this.

You are right. Will fix. Thanks!
> 
