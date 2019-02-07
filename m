From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 05/32] timerfd/timens: Take into account ns clock offsets
Date: Wed, 6 Feb 2019 22:38:31 -0800
Message-ID: <20190207063830.GB24912@gmail.com>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-6-dima@arista.com>
 <20190206085203.GB25251@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206085203.GB25251@uranus>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 06, 2019 at 11:52:03AM +0300, Cyrill Gorcunov wrote:
> On Wed, Feb 06, 2019 at 12:10:39AM +0000, Dmitry Safonov wrote:
> > From: Andrei Vagin <avagin@gmail.com>
> > 
> > Make timerfd respect timens offsets.
> > Provide two helpers timens_clock_to_host() timens_clock_from_host() that
> > are useful to wire up timens to different kernel subsystems.
> > Following patches will use timens_clock_from_host(), added here for
> > completeness.
> > 
> > Signed-off-by: Andrei Vagin <avagin@openvz.org>
> > Co-developed-by: Dmitry Safonov <dima@arista.com>
> > Signed-off-by: Dmitry Safonov <dima@arista.com>
> > ---
> >  fs/timerfd.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/timerfd.c b/fs/timerfd.c
> > index 803ca070d42e..c7ae1e371912 100644
> > --- a/fs/timerfd.c
> > +++ b/fs/timerfd.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/compat.h>
> >  #include <linux/rcupdate.h>
> > +#include <linux/time_namespace.h>
> >  
> >  struct timerfd_ctx {
> >  	union {
> > @@ -433,22 +434,27 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
> >  }
> >  
> >  static int do_timerfd_settime(int ufd, int flags, 
> > -		const struct itimerspec64 *new,
> > +		struct itimerspec64 *new,
> >  		struct itimerspec64 *old)
> >  {
> >  	struct fd f;
> >  	struct timerfd_ctx *ctx;
> >  	int ret;
> >  
> > -	if ((flags & ~TFD_SETTIME_FLAGS) ||
> > -		 !itimerspec64_valid(new))
> > -		return -EINVAL;
> 
> Please don't defer this early test of a @flags value. Otherwise
> if @flags is invalid you continue fget/put/clock-to-host even
> if result will be dropped out then.

Cyrill, you are right. I moved this check together with
itimerspec64_valid(). The idea was to call itimerspec64_valid() after
applying clock offsets but for that, we need to know clockid.

Let's wait a bit for other comments to this patch set and then we will
fix all things what will be found.

Thanks,
Andrei
