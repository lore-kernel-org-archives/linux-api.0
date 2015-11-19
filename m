From: Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] restartable sequences: user-space per-cpu
 critical sections
Date: Thu, 19 Nov 2015 17:38:10 +0100
Message-ID: <1447951090.2765.9.camel@sipsolutions.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
	 <20151027235653.16059.8933.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027235653.16059.8933.stgit-G8L5E6GV2z5XSTzz+wBt03oUN1GumTyQ7j82oEJ37pA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-10-27 at 16:56 -0700, Paul Turner wrote:
>=C2=A0
> + *=C2=A0=C2=A0flags is currently unused.
> + */
> +SYSCALL_DEFINE3(restartable_sequences,
> +> 	> 	> int, flags, long, event_and_cpu, long, post_commit_instr_add=
r)
=09
> +{
> +	return rseq_configure_current((__user u64 *)event_and_cpu,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(__user void *)post_commit_i=
nstr_addr);

It seems that, for forward compatibility and actually usefulness of the
'flags' argument, you need to reject the syscall if it's passed non-
zero right now. Otherwise applications can (inadvertedly) pass garbage
and you'll not be able to use it in the future.

johannes
