From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 05/32] timerfd/timens: Take into account ns clock offsets
Date: Wed, 6 Feb 2019 11:55:25 +0300
Message-ID: <20190206085525.GC25251@uranus>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-6-dima@arista.com>
 <20190206085203.GB25251@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206085203.GB25251@uranus>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 06, 2019 at 11:52:03AM +0300, Cyrill Gorcunov wrote:
...
> >  
> > -	if ((flags & ~TFD_SETTIME_FLAGS) ||
> > -		 !itimerspec64_valid(new))
> > -		return -EINVAL;
> 
> Please don't defer this early test of a @flags value. Otherwise
> if @flags is invalid you continue fget/put/clock-to-host even
> if result will be dropped out then.

Just to clarify -- this could be done on top of the series to
not resend the whole bunch.
