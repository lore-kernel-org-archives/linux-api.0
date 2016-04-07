From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 18:43:12 +0000 (UTC)
Message-ID: <1025228632.49344.1460054592801.JavaMail.zimbra@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com> <20160405164722.GB3430@twins.programming.kicks-ass.net> <570621E5.7060306@redhat.com> <20160407103158.GP3430@twins.programming.kicks-ass.net> <570638D9.7010108@redhat.com> <20160407111938.GR3430@twins.programming.kicks-ass.net> <CA+55aFxrWx5pFN3LseaKpUHtB6nqXtkgP84seU3pjys-kq7utQ@mail.gmail.com> <CA+55aFyB6CPNiMKGWoaV7vxFWWBTgqOTqG4u2aNnq6uq1cHWZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyB6CPNiMKGWoaV7vxFWWBTgqOTqG4u2aNnq6uq1cHWZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 7, 2016, at 12:52 PM, Linus Torvalds torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:

> On Thu, Apr 7, 2016 at 9:39 AM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>
>> Because if not, then this discussion is done for. Stop with the
>> f*cking idiotic "let's look at some kernel size and user-space size
>> and try to match them up". The kernel doesn't care. The kernel MUST
>> NOT care. The kernel will touch one single word, and that's all the
>> kernel does, and user space had better be able make up their own
>> semantics around that.
> 
> .. and btw - if people aren't sure that that is a "good enough"
> interface, then I'm sure as hell not going to merge that patch anyway.
> Andy mentions rseq. Yeah, I'm not going to merge anything where part
> of the discussion is "and we might want to do something else for X".
> 
> Either the suggested patches are useful and generic enough that people
> can do this, or they aren't.
> 
> If people can agree that "yes, this whole cpu id cache is a great
> interface that we can build up interesting user-space constructs
> around", then great. Such a new kernel interface may be worth merging.

One basic use of cpu id cache is to speed up the sched_getcpu(3)
implementation in glibc. This is why I'm proposing it as a stand-alone
feature that does not require the restartable sequences. It can
also be used directly from applications to remove the function call
overhead of sched_getcpu, which further accelerates this operation.

> 
> But if people cannot be convinced that it is sufficient, then I don't
> want to merge some half-arsed interface that generates these kinds of
> discussions.
> 
> So the fact that currently makes me go "no way will I merge any of
> this" is the very fact that these discussions continue and are still
> going on.

The intent of this RFC patchset is to get people to agree on the proper
way to introduce both the "cpu id" and the "rseq (restartable critical
section)" features. I have so far proposed two ways of doing it: one
system call per feature, or one system call to register all the features.

My previous patch rounds were adding a system call specific for the
cpu_id field, registering a pointer to a 32-bit per-thread integer.
(getcpu_cache system call) Based on prior email exchanges I had with
you on other topics, I was inclined to go for the specific getcpu_cache
system call route, and adding future features as separate system calls.

hpa pointed out that this will mean keeping track of one pointer
per task-struct for cpu_id, and eventually another pointer per
task-struct for rseq fields, thus degrading cache locality. In
order to address his concerns, I proposed this "thread local ABI"
system call, which registers a fixed-size 64 bytes structure that
starts with a feature mask.

The other route we could take is to just implement one "rseq" system
call, which would contain all fields needed for the rseq feature,
which happen to include the cpu_id. The main downside of this
approach is that whenever we want to port the cpu_id feature to
another architecture, it _needs_ to come with the implemented
"rseq" feature too, which is rather more complex. I don't mind
going that way either if that's preferred.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
