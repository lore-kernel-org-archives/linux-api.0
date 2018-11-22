From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Thu, 22 Nov 2018 10:27:20 -0500 (EST)
Message-ID: <1320611605.10033.1542900440206.JavaMail.zimbra@efficios.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org> <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com> <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org> <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com> <20181121162247.467fcab6c0aca0819a822286@linux-foundation.org> <CAKOZuet7ipw8zoXCDQUB5PKs3kdSye-zesBbEv7jVDSByhXgkw@mail.gmail.com> <CAKOZueuV=X4eqc+-8Jh3Z-2iQO+4fp2otEOs03yQoaa88C9zUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuV=X4eqc+-8Jh3Z-2iQO+4fp2otEOs03yQoaa88C9zUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux@dominikbrodowski.net, Josh Poimboeuf <jpoimboe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

----- On Nov 21, 2018, at 7:30 PM, Daniel Colascione dancol@google.com wrote:
[...]
>> > >
>> > > The problem here is the possibility of confusion, even if it's rare.
>> > > Does the naive approach of just walking /proc and ignoring the
>> > > possibility of PID reuse races work most of the time? Sure. But "most
>> > > of the time" isn't good enough. It's not that there are tons of sob
>> > > stories: it's that without completely robust reporting, we can't rule
>> > > out of the possibility that weirdness we observe in a given trace is
>> > > actually just an artifact from a kinda-sort-working best-effort trace
>> > > collection system instead of a real anomaly in behavior. Tracing,
>> > > essentially, gives us deltas for system state, and without an accurate
>> > > baseline, collected via some kind of scan on trace startup, it's
>> > > impossible to use these deltas to robustly reconstruct total system
>> > > state at a given time. And this matters, because errors in
>> > > reconstruction (e.g., assigning a thread to the wrong process because
>> > > the IDs happen to be reused) can affect processing of the whole trace.
>> > > If it's 3am and I'm analyzing the lone trace from a dogfooder
>> > > demonstrating a particularly nasty problem, I don't want to find out
>> > > that the trace I'm analyzing ended up being useless because the
>> > > kernel's trace system is merely best effort. It's very cheap to be
>> > > 100% reliable here, so let's be reliable and rule out sources of
>> > > error.
>> >

[...]

I've just been CC'd on this thread for some reason, so I'll add my 2 cents.

WHIW, I think using /proc to add stateful information to a time-based
trace is the wrong way to do things. Here, the fact that you need to
add a generation counter struct pid_namespace and expose it via /proc
just highlights its limitations when it comes to dealing with state
that changes over time. Your current issue is with PID re-use, but
you will eventually face the same issue for re-use of all other resources
you are trying to model. For instance, a file descriptor may be associated
to a path as some point in time, but that is not true anymore after a
sequence of close/open which re-uses that file descriptor. Does that
mean we will eventually end up needing per-file-descriptor generation
counters as well ?

LTTng solves this by dumping the system state as events within the
trace [1], which associates time-stamps with the state being dumped.
It is recorded while the rest of the system is being traced, so tools
can reconstruct full system state by combining this statedump with the
rest of the events recording state transitions.

So while I agree that it's important to have a way to reconstruct
system state that is aware of PID re-use, I think trying to extend
/proc for this is the wrong approach. It adds extra fields to struct
pid_namespace that seem to be only useful for tracing, whereas using
the time-stamp at which the thread/process was first seen in the trace
(either fork or statedump) as secondary key should suffice to uniquely
identify a thread/process. I would recommend extending tracing
facilities to dump the data you need rather than /proc.

Thanks,

Mathieu

[1] http://git.lttng.org/?p=lttng-modules.git;a=blob;f=lttng-statedump-impl.c;h=dc037508c055b7f61b8c758d581bd0178e26552a;hb=HEAD


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
