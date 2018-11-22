From: Tim Murray <timmurray@google.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 18:35:48 -0800
Message-ID: <CAEe=SxmNVHR_1ge6hM5636CNi4BZhLvyxoKW_28L9-XDV7x6aQ@mail.gmail.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121205428.165205-1-dancol@google.com>
 <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
 <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
 <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
 <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com>
 <20181121162247.467fcab6c0aca0819a822286@linux-foundation.org>
 <CAKOZuet7ipw8zoXCDQUB5PKs3kdSye-zesBbEv7jVDSByhXgkw@mail.gmail.com>
 <20181121165741.ef089df784482632c4a66370@linux-foundation.org>
 <CAKOZuessQgmPuiReEO0caNqkss=r44o-XXnem12TOXSn=y6xkw@mail.gmail.com> <20181121172919.1b6585e17770d0be7dd8c4d9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121172919.1b6585e17770d0be7dd8c4d9@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, corbet@lwn.net, rppt@linux.vnet.ibm.com, vbabka@suse.cz, guro@fb.com, pdhamdhe@redhat.com, dennisszhou@gmail.com, ebiederm@xmission.com, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, ard.biesheuvel@linaro.org, mhocko@suse.com, sfr@canb.auug.org.au, ktsanaktsidis@zendesk.com, dhowells@redhat.com, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 5:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 21 Nov 2018 17:08:08 -0800 Daniel Colascione <dancol@google.com> wrote:
>
> > Have you done much
> > retrospective long trace analysis?
>
> No.  Have you?
>
> Of course you have, which is why I and others are dependent upon you to
> explain why this change is worth adding to Linux.  If this thing solves
> a problem which we expect will not occur for anyone between now and the
> heat death of the universe then this impacts our decisions.

I use ftrace the most on Android, so let me take a shot.

In addition to the normal "debug a slow thing" use cases for ftrace,
Android has started exploring two other ways of using ftrace:

1. "Flight recorder" mode: trigger ftrace for some amount of time when
a particular anomaly is detected to make debugging those cases easier.

2. Long traces: let a trace stream to disk for hours or days, then
postprocess it to get some deeper insights about system behavior.
We've used this very successfully to debug and optimize power
consumption.

Knowing the initial state of the system is a pain for both of these
cases. For example, one of the things I'd like to know in some of my
current use cases for long traces is the current oom_score_adj of
every process in the system, but similar to PID reuse, that can change
very quickly due to userspace behavior. There's also a race between
reading that value in userspace and writing it to trace_marker:

1. Userspace daemon X reads oom_score_adj for a process Y.
2. Process Y gets a new oom_score_adj value, triggering the
oom/oom_score_adj_update tracepoint.
3. Daemon X writes the old oom_score_adj value to trace_marker.

As I was writing this, though, I realized that the race doesn't matter
so long as our tools follow the same basic practice (for PID reuse,
oom_score_adj, or anything else we need):

1. Daemon enables all requested tracepoints and resets the trace clock.
2. Daemon enables tracing.
3. Daemon dumps initial state for any tracepoint we care about.
4. When postprocessing, a tool must consider the initial state of a
value (eg, oom_score_adj of pid X) to be either the initial state as
reported by the daemon or the first ftrace event reporting that value.
If there is an ftrace event in the trace before the report from the
daemon, the report from the daemon should be ignored.

The key here is that initial state as reported by userspace needs to
provable from ftrace events. For example, if we stream ps -AT to
trace_marker from userspace, we should be able to prove that pid 5000
in that ps -AT is actually the same process that shows up as pid 5000
later on in the trace and that it has not been replaced by some other
pid 5000. That requires that any event that could break that
assumption be available from the trace itself. Accordingly, I think a
PID reuse tracepoint would work better than an atomic dump of all PIDs
because I'd rather have tracepoints for anything where the initial
state of the system matters than relying on different atomic dumps to
be sure of the initial state. (in this case, we'd have to combine a
PID reuse tracepoint with sched_process_fork and task_rename or
something like that to know what's actually running, but that's a
tractable problem)

The PID reuse tracepoint requires more intelligence in postprocessing
and it still has a race where the state of these values can be
indeterminate at the beginning of a trace if those values change
quickly, but I don't think we can get to a point where we can generate
a full snapshot of every tracepoint we care about in the system at the
start of a trace. For Android's use cases, that short race at the
beginning of a trace isn't a big deal (or at least I can't think of a
case where it would be).
