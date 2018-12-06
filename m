From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 13:53:57 +0100
Message-ID: <20181206125354.ef3zlg3o75w32ymx@brauner.io>
References: <20181206121858.12215-1-christian@brauner.io>
 <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 01:30:19PM +0100, Florian Weimer wrote:
> * Christian Brauner:
> 
> > /* zombies */
> > Zombies can be signaled just as any other process. No special error will be
> > reported since a zombie state is an unreliable state (cf. [3]).
> 
> I still disagree with this analysis.  If I know that the target process
> is still alive, and it is not, this is a persistent error condition
> which can be reliably reported.  Given that someone might send SIGKILL
> to the process behind my back, detecting this error condition could be
> useful.

Apart from my objection that this is not actually a reliable state
because of timing issues between e.g. calling wait and a process exiting
I have two more concerns and one helpful suggestion.
First, this is hooking pretty deep into kernel internals. So far
EXIT_ZOMBIE is only exposed in kernel/exit.c and I don't see enough
value to drag all of this into kernel/signal.c
Second, all other signal syscalls don't do report errors when signaling
to zombies as well. It would be odd if this one suddenly did.
Third, if this really becomes such a big issue for userspace in the
future that we want to do that work then we can add a flag like
TASKFD_DETECT_ZOMBIE (or some such name) that will allow userspace to
get an error back when signaling a zombie.
As far as I'm concerned, this is out of scope for an initial
implementation. We are going to use fds for tasks that's enough
excitement for one patchset!

> 
> Rest looks good to me (with the usual caveats).

I take it that's your way of saying Acked-by? :)

Christian
