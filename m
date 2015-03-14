From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
	exit notification via fd
Date: Sat, 14 Mar 2015 21:20:59 +0100
Message-ID: <20150314202059.GA11012@redhat.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <20150314141414.GA11062@redhat.com> <20150314143235.GA12086@redhat.com> <28025621.k7WkrfHd4d@tjmaciei-mobl4> <20150314190132.GB22130@thin> <20150314191836.GA8416@redhat.com> <20150314200318.GG22130@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150314200318.GG22130@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/14, Josh Triplett wrote:
>
> On Sat, Mar 14, 2015 at 08:18:36PM +0100, Oleg Nesterov wrote:
>
> Is there any information somewhere on how this state machine of doom is
> *supposed* to work? :)

This looks as if you think that other parts of this kernel differ ;)

> Why would "p->task_state == EXIT_DEAD" mean
> something different in wait_consider_task?

different? but once again, EXIT_DEAD never meant "autoreap". It always
means "already reaped". OK, more correctly it means "release_task() will
be called soon, please ignore me".

> Pulling the EXIT_DEAD tasks out of those lists completely does sound
> like a good simplification.  However, that doesn't seem to be the
> current expectation in wait_consider_task, which just returns if
> p->task_state == EXIT_DEAD to skip considering that task.

See above. And another email I sent.

> And an autoreaping task isn't necessarily dead yet; it just shouldn't be
> waited on.

Yes, sure, but please do not confuse this with EXIT_DEAD. In fact, please
do not confuse this with ->task_state.

> > However, currently this is TODO. The main problem is the locking in
> > wait_task_zombie(), we can set EXIT_DEAD and remove the task from list
                        ^^^^^^
I mean, "we can't".

> > under read_lock().
>
> That appears to be only reachable for zombies, which an autoreaping task
> should never become.

Sure. I meant that other paths which can set EXIT_DEAD are simpler wrt
"kill the EXIT_DEAD and EXIT_TRACE state" patch we actually want. But lets
not discuss this here, this is offtopic.

Oleg.
