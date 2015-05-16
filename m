From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 13/19] y2038: add compat handling for sys_semtimedop
Date: Sat, 16 May 2015 09:28:49 +0200
Message-ID: <2124771.PTAe8S6R1g@wuerfel>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430929826-318934-14-git-send-email-arnd@arndb.de> <alpine.DEB.2.11.1505160041370.4225@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <libc-alpha-return-58955-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <alpine.DEB.2.11.1505160041370.4225@nanos>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Saturday 16 May 2015 00:46:44 Thomas Gleixner wrote:
> On Wed, 6 May 2015, Arnd Bergmann wrote:
> > +SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
> > +             unsigned, nsops,
> > +             const struct __kernel_timespec  __user *, timeout)
> > +{
> > +     unsigned long jiffies_left = 0;
> > +
> > +     if (timeout) {
> > +             struct timespec64 _timeout;
> > +             if (get_timespec64(&_timeout, timeout))
> 
> Moo. I had to look 3 times to get not confused by the extra
> underscore. What's wrong with a proper variable name which is easy to
> distinguish?
> 
> > +                     return -EFAULT;
> 
> > +             if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
> > +                     _timeout.tv_nsec >= 1000000000L)
> > +                     return -EINVAL;
> 
> We have proper helper functions to validate time specs.

I tried to change the existing code as little as possible, but I agree
with your points here. I'll add a cleanup patch to fix the current code
before my own patches.

	Arnd
