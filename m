From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 14:50:43 -0800
Message-ID: <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
References: <20181121201452.77173-1-dancol@google.com>
        <20181121205428.165205-1-dancol@google.com>
        <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
        <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, ard.biesheuvel@linaro.org, Michal Hocko <mhocko@suse.com>, sfr@canb.auug.org.au, ktsanaktsidis@zendesk.com, David Howells <dhowells@redhat.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 21 Nov 2018 14:40:28 -0800 Daniel Colascione <dancol@google.com> wrote:

> On Wed, Nov 21, 2018 at 2:12 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 21 Nov 2018 12:54:20 -0800 Daniel Colascione <dancol@google.com> wrote:
> >
> > > Trace analysis code needs a coherent picture of the set of processes
> > > and threads running on a system. While it's possible to enumerate all
> > > tasks via /proc, this enumeration is not atomic. If PID numbering
> > > rolls over during snapshot collection, the resulting snapshot of the
> > > process and thread state of the system may be incoherent, confusing
> > > trace analysis tools. The fundamental problem is that if a PID is
> > > reused during a userspace scan of /proc, it's impossible to tell, in
> > > post-processing, whether a fact that the userspace /proc scanner
> > > reports regarding a given PID refers to the old or new task named by
> > > that PID, as the scan of that PID may or may not have occurred before
> > > the PID reuse, and there's no way to "stamp" a fact read from the
> > > kernel with a trace timestamp.
> > >
> > > This change adds a per-pid-namespace 64-bit generation number,
> > > incremented on PID rollover, and exposes it via a new proc file
> > > /proc/pid_gen. By examining this file before and after /proc
> > > enumeration, user code can detect the potential reuse of a PID and
> > > restart the task enumeration process, repeating until it gets a
> > > coherent snapshot.
> > >
> > > PID rollover ought to be rare, so in practice, scan repetitions will
> > > be rare.
> >
> > In general, tracing is a rather specialized thing.  Why is this very
> > occasional confusion a sufficiently serious problem to warrant addition
> > of this code?
> 
> I wouldn't call tracing a specialized thing: it's important enough to
> justify its own summit and a whole ecosystem of trace collection and
> analysis tools. We use it in every day in Android. It's tremendously
> helpful for understanding system behavior, especially in cases where
> multiple components interact in ways that we can't readily predict or
> replicate. Reliability and precision in this area are essential:
> retrospective analysis of difficult-to-reproduce problems involves
> puzzling over trace files and testing hypothesis, and when the trace
> system itself is occasionally unreliable, the set of hypothesis to
> consider grows. I've tried to keep the amount of kernel infrastructure
> needed to support this precision and reliability to a minimum, pushing
> most of the complexity to userspace. But we do need, from the kernel,
> reliable process disambiguation.
> 
> Besides: things like checkpoint and restart are also non-core
> features, but the kernel has plenty of infrastructure to support them.
> We're talking about a very lightweight feature in this thread.

I'm still not understanding the seriousness of the problem.  Presumably
you've hit problems in real-life which were serious and frequent enough
to justify getting down and writing the code.  Please share some sob stories
with us!

> > Which userspace tools will be using pid_gen?  Are the developers of
> > those tools signed up to use pid_gen?
> 
> I'll be changing Android tracing tools to capture process snapshots
> using pid_gen, using the algorithm in the commit message.

Which other tools could use this and what was the feedback from their
developers?  Those people are the intended audience and the
best-positioned reviewers so let's hear from them?

> > > +u64 read_pid_generation(struct pid_namespace *ns)
> > > +{
> > > +     u64 generation;
> > > +
> > > +
> > > +     spin_lock_irq(&pidmap_lock);
> > > +     generation = ns->generation;
> > > +     spin_unlock_irq(&pidmap_lock);
> > > +     return generation;
> > > +}
> >
> > What is the spinlocking in here for?  afaict the only purpose it serves
> > is to make the 64-bit read atomic, so it isn't needed on 32-bit?
> 
> ITYM the spinlock is necessary *only* on 32-bit, since 64-bit
> architectures have atomic 64-bit reads, and 64-bit reads on 32-bit
> architectures can tear. This function isn't a particularly hot path,
> so I thought consistency across architectures would be more valuable
> than avoiding the lock on some systems.

OK.
