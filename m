From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 14:17:09 +0100
Message-ID: <87lg526bhm.fsf@oldenburg2.str.redhat.com>
References: <20181206121858.12215-1-christian@brauner.io>
        <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
        <20181206125354.ef3zlg3o75w32ymx@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181206125354.ef3zlg3o75w32ymx@brauner.io> (Christian Brauner's
        message of "Thu, 6 Dec 2018 13:53:57 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> On Thu, Dec 06, 2018 at 01:30:19PM +0100, Florian Weimer wrote:
>> * Christian Brauner:
>> 
>> > /* zombies */
>> > Zombies can be signaled just as any other process. No special error will be
>> > reported since a zombie state is an unreliable state (cf. [3]).
>> 
>> I still disagree with this analysis.  If I know that the target process
>> is still alive, and it is not, this is a persistent error condition
>> which can be reliably reported.  Given that someone might send SIGKILL
>> to the process behind my back, detecting this error condition could be
>> useful.
>
> Apart from my objection that this is not actually a reliable state
> because of timing issues between e.g. calling wait and a process
> exiting

The point is that if you are in an error state, the error state does not
go away, *especially* if you do not expect the process to terminate and
have not arranged for something calling waitpid on the PID.

> I have two more concerns and one helpful suggestion.
> First, this is hooking pretty deep into kernel internals. So far
> EXIT_ZOMBIE is only exposed in kernel/exit.c and I don't see enough
> value to drag all of this into kernel/signal.c
> Second, all other signal syscalls don't do report errors when signaling
> to zombies as well.

They cannot do this reliably because the error state is not persistent:
the PID can be reused.  So for the legacy interface, a difference in
error signaling would just have encouraged a bad programming model.

> It would be odd if this one suddenly did.

I don't think so.  My point is that the FD-based mechanism finally
allows to cope with this in a reasonable way.

> Third, if this really becomes such a big issue for userspace in the
> future that we want to do that work then we can add a flag like
> TASKFD_DETECT_ZOMBIE (or some such name) that will allow userspace to
> get an error back when signaling a zombie.

I can live with that.

Thanks,
Florian
