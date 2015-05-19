From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/19] y2038: add compat handling for sys_semtimedop
Date: Tue, 19 May 2015 11:19:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191116050.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430929826-318934-14-git-send-email-arnd@arndb.de> <alpine.DEB.2.11.1505160041370.4225@nanos> <5686498.JnFHvQTH21@wuerfel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <libc-alpha-return-59010-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <5686498.JnFHvQTH21@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Sat, 16 May 2015, Arnd Bergmann wrote:
> On Saturday 16 May 2015 00:46:44 Thomas Gleixner wrote:
> > On Wed, 6 May 2015, Arnd Bergmann wrote:
> > > +SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
> > > +		unsigned, nsops,
> > > +		const struct __kernel_timespec  __user *, timeout)
> > > +{
> > > +	unsigned long jiffies_left = 0;
> > > +
> > > +	if (timeout) {
> > > +		struct timespec64 _timeout;
> > > +		if (get_timespec64(&_timeout, timeout))
> > 
> > Moo. I had to look 3 times to get not confused by the extra
> > underscore. What's wrong with a proper variable name which is easy to
> > distinguish?
> > 
> > > +			return -EFAULT;
> > 
> > > +		if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
> > > +			_timeout.tv_nsec >= 1000000000L)
> > > +			return -EINVAL;
> > 
> > We have proper helper functions to validate time specs.
> 
> I ended up fixing both issues you noticed in the same patch
> after all, and also simplified it slightly more.
> 
> Finally, I also noticed that I had not done a timespec64_to_jiffies()
> call at the time when I wrote this patch, but it actually exists now,
> so I've reordered my series and am using it in the new version, as
> I should have done to start with.

Indeed. I didn't notice either.
 
> >From e04b14d49273c27d92f1799233b82bcdafb43d9a Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Mon, 27 Apr 2015 23:30:39 +0200
> Subject: [UPDATED PATCH] y2038: add compat handling for sys_semtimedop
> 
> This moves the compat_sys_semtimedop function to ipc/sem.c so it
> can be shared with 32-bit architectures efficiently. Instead of
> copying the timespec back to user space, we take a shortcut and
> pass the kernel timespec64 value to the low-level implementation
> directly.
> 
> The native sys_semtimedop() function is modified to take a
> __kernel_timespec structure, which will be based on a 64-bit
> time_t in the future.
> 
> There is a small API change here: if multiple errors are present,
> and the timespec argument is an invalid pointer, we now return
> -EFAULT before checking any of the other error conditions.
> This is what the compat version has always done, but if it is a
> problem, we need a more sophisticated approach.

The important part of error checks is that they catch all
cases and combinations. In which order is completely irrelevant.

If something relies on the ordering of error check returns, it's
broken by definition.
 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
