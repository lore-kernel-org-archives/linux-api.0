From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 21:30:20 -0800
Message-ID: <CAKOZues6ZwrJ3Y-iLGC5HVgg6snLsMeHuPjDsK9=pooUmQswhQ@mail.gmail.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121205428.165205-1-dancol@google.com>
 <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
 <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
 <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
 <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com>
 <20181121162247.467fcab6c0aca0819a822286@linux-foundation.org>
 <CAKOZuet7ipw8zoXCDQUB5PKs3kdSye-zesBbEv7jVDSByhXgkw@mail.gmail.com>
 <20181121165741.ef089df784482632c4a66370@linux-foundation.org>
 <CAKOZuessQgmPuiReEO0caNqkss=r44o-XXnem12TOXSn=y6xkw@mail.gmail.com>
 <20181121172919.1b6585e17770d0be7dd8c4d9@linux-foundation.org> <CAEe=SxmNVHR_1ge6hM5636CNi4BZhLvyxoKW_28L9-XDV7x6aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEe=SxmNVHR_1ge6hM5636CNi4BZhLvyxoKW_28L9-XDV7x6aQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Murray <timmurray@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, ktsanaktsidis@zendesk.com, David Howells <dhowells@redhat.com>o
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 6:36 PM Tim Murray <timmurray@google.com> wrote:
>
> On Wed, Nov 21, 2018 at 5:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 21 Nov 2018 17:08:08 -0800 Daniel Colascione <dancol@google.com> wrote:
> >
> > > Have you done much
> > > retrospective long trace analysis?
> >
> > No.  Have you?
> >
> > Of course you have, which is why I and others are dependent upon you to
> > explain why this change is worth adding to Linux.  If this thing solves
> > a problem which we expect will not occur for anyone between now and the
> > heat death of the universe then this impacts our decisions.
>
> I use ftrace the most on Android, so let me take a shot.
>
> In addition to the normal "debug a slow thing" use cases for ftrace,
> Android has started exploring two other ways of using ftrace:
>
> 1. "Flight recorder" mode: trigger ftrace for some amount of time when
> a particular anomaly is detected to make debugging those cases easier.
>
> 2. Long traces: let a trace stream to disk for hours or days, then
> postprocess it to get some deeper insights about system behavior.
> We've used this very successfully to debug and optimize power
> consumption.
>
> Knowing the initial state of the system is a pain for both of these
> cases. For example, one of the things I'd like to know in some of my
> current use cases for long traces is the current oom_score_adj of
> every process in the system, but similar to PID reuse, that can change
> very quickly due to userspace behavior. There's also a race between
> reading that value in userspace and writing it to trace_marker:
>
> 1. Userspace daemon X reads oom_score_adj for a process Y.
> 2. Process Y gets a new oom_score_adj value, triggering the
> oom/oom_score_adj_update tracepoint.
> 3. Daemon X writes the old oom_score_adj value to trace_marker.
>
> As I was writing this, though, I realized that the race doesn't matter
> so long as our tools follow the same basic practice (for PID reuse,
> oom_score_adj, or anything else we need):
>
> 1. Daemon enables all requested tracepoints and resets the trace clock.
> 2. Daemon enables tracing
> 3. Daemon dumps initial state for any tracepoint we care about.
> 4. When postprocessing, a tool must consider the initial state of a
> value (eg, oom_score_adj of pid X) to be either the initial state as
> reported by the daemon or the first ftrace event reporting that value.
> If there is an ftrace event in the trace before the report from the
> daemon, the report from the daemon should be ignored.

I was imagining periodic scans being the moral equivalent of I-frames
in an MPEG stream: known-good synchronization points that bound the
propagation of errors. To prevent loss of events in the *middle* of
one of these samples affecting the validity of the sample, I wanted
each one to be atomic and self-contained. I was initially imagining a
single proc file containing a mapping from thread ID list and a TGID
mapping for each one (as well as assorted other information),
generated atomically under task_list_lock and stamped with the trace
timestamp. The /proc/pid_gen thing was an effort to do most of that in
userspace. But maybe that's not really that important.

Another thing to consider: there are some properties which we can
enumerate *only* through /proc and that we can't yet receive in a
streaming, event-driven fashion. We read those by periodic sampling,
but the sampling isn't atomic. And as Tim notes, even properties that
we ordinarily receive in streaming form via trace event must be
sampled at trace start. But trace start isn't the only case where it
matters.

Suppose at T+50 we have a TID 601 (which we'll call TID 601_1) with
steady-state resource-consumption $COUNTER 100MB. Now suppose we start
sampling at T+50. At T+55, TID 601_1 dies. At T+60, due to unlikely be
possible TID reuse, we see a new task with TID 601, which we'll call
TID 601_2. At T+65, the sample reads TID 601_2's $COUNTER as 1GB. At
T+70, we finish the sample. From the perspective of trace analysis,
all the sample tells us is "at some point between T+50 and T+70, TID
601's $COUNTER was 1GB". We also know when TID 601_1 died and when TID
601_2 started. We don't know whether the sample's "TID 601" refers to
TID 601_1 or TID 601_2. So what do we do?

1) We could attribute the 1GB value of $COUNTER to TID 601_1, which is
what would happen by default if we deemed the sample to be a virtual
event with timestamp T+50, the time we started the sampling process.
But that would be incorrect here. In analysis, we'd see this
attribution as a mysterious spike in TID 601_1's resource consumption
immediately before its death. (The spike would be to a level
suspiciously similar to TID 601_2's next sample.) Imagine spending
hours trying to track down a mystery death-rattle resource spike
(something that could plausibly happen in the real world) that ended
up being a tracing artifact.

2) We could attribute the 1GB read of $COUNTER to TID 601_2. In the
timeline I gave above, this attribution would be correct. But what if
TID 601_1's $COUNTER really _had_ spiked to 1GB immediately before its
death? (What if its death had been caused by that spike?) Then, under
the "tag last" approach, we'd falsely tag TID 601_2 with TID 601_1's
excessive resource use, and this false attribution would last until
the next sample of TID 601_2, which might be quite far in the future.
And we might find ourselves wondering why TID 601_1 died, since (if we
blame 601_2 for the new $COUNTER value) TID 601_1 would have done
nothing wrong. And in the meantime, we'd see 1GB of $COUNTER
consumption that would appear to come out of nowhere.

3) We could discard the ambiguous sample. But in this case, we'd leave
TID 601_2's $COUNTER value completely unknown until the next sample,
which could be quite far in the future. And, if TID 601_2's $COUNTER
value really were 1GB, we might leave significant resource consumption
unaccounted-for until that next sample.

With my pid_gen patch, we could have used strategy #3 without having
to wait for the system to get around to sampling TID 601_2 again on
its own, because we'd have been able to detect the ambiguity and
collect a new, hopefully-unambiguous sample on the spot. Yes, we do
wait a sampling period between samples anyway, and it's possible for a
process to start, run, and die without having ever been sampled with
or without pid_gen, but at least we wouldn't have missed a perfectly
good sampling opportunity due to PID ambiguity.

You might say, "dancol@, you sound excessively fussy here. That's
never going to really matter under any realistic workload." And maybe
that'd be right. But like I said above, I think it's important to be
able to have deterministic bounds on uncertainty even in the case of
pathological behavior, and I'd rather guarantee correctness
structurally than wonder whether unlikely events are one-in-a-trace
unlikely or heat-death-of-the-universe unlikely.

To improve on the sampling model, we could have the kernel stamp
$COUNTER reads with the current trace timestamp. Then, the sample
would tell us, instead of "TID 601's $COUNTER was 1GB between T+50 and
T+70", it'd tell us "TID 601's $COUNTER was 1GB at exactly T+65". (The
sampling program itself might get around to logging this bit of
information at T+70 or T+700, but the embedded timestamp would be
accurate.) We could then look up the inferred process table at T+65
and attribute that 1GB to TID 601_2.

Ideally, we wouldn't bother with this sort of sampling at all, instead
relying on streaming $COUNTER updates as events. But we're not quite
there yet. I have a larger proposal in the works for that one. Under
that proposal, we wouldn't log every change to $COUNTER, but we would
log $COUNTER at process death (as well as at other times ---
basically, after large changes and after a maximum time after any
change), so trace analysis would still be able to correctly determine
TID 601_1's time-of-death resource use.

In another approach, the trace system *itself* would generate the
"I-frames" by automatically generating synthetic trace events at trace
startup in order to reflect pre-trace system state. (For example, if
you enabled sched_switch and started tracing, the ftrace ring buffer
would begin life with one synthetic sched_switch per CPU describing
each CPU's running task at the instant of trace startup, maybe
collected with on_all_cpus.)

But anyway, I didn't expect the pid_gen change to be controversial.
Given that we can eventually do something different altogether and
that it probably *is* excessively fussy, consider the patch withdrawn.
