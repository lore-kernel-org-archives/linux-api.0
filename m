From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 17:08:08 -0800
Message-ID: <CAKOZuessQgmPuiReEO0caNqkss=r44o-XXnem12TOXSn=y6xkw@mail.gmail.com>
References: <20181121201452.77173-1-dancol@google.com> <20181121205428.165205-1-dancol@google.com>
 <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
 <CAKOZuetW6WMNFdL5_2=UbrEf8mjxYTdz1+4BiRLSgdoKh8FsqQ@mail.gmail.com>
 <20181121145043.fa029f4f91afddc2a10bb81e@linux-foundation.org>
 <CAKOZuesF5zi9mpEE6No7oq0hDnM8KFhQFU=NM7qUF635s0r3-A@mail.gmail.com>
 <20181121162247.467fcab6c0aca0819a822286@linux-foundation.org>
 <CAKOZuet7ipw8zoXCDQUB5PKs3kdSye-zesBbEv7jVDSByhXgkw@mail.gmail.com> <20181121165741.ef089df784482632c4a66370@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121165741.ef089df784482632c4a66370@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Primiano Tucci <primiano@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, rostedt@goodmis.org, tglx@linutronix.de, mingo@kernel.org, linux@dominikbrodowski.net, jpoimboe@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, ktsanaktsidis@zendesk.com, David Howells <dhowells@redhat.com>, open list
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 4:57 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 21 Nov 2018 16:28:56 -0800 Daniel Colascione <dancol@google.com> wrote:
>
> > > > The problem here is the possibility of confusion, even if it's rare.
> > > > Does the naive approach of just walking /proc and ignoring the
> > > > possibility of PID reuse races work most of the time? Sure. But "most
> > > > of the time" isn't good enough. It's not that there are tons of sob
> > > > stories: it's that without completely robust reporting, we can't rule
> > > > out of the possibility that weirdness we observe in a given trace is
> > > > actually just an artifact from a kinda-sort-working best-effort trace
> > > > collection system instead of a real anomaly in behavior. Tracing,
> > > > essentially, gives us deltas for system state, and without an accurate
> > > > baseline, collected via some kind of scan on trace startup, it's
> > > > impossible to use these deltas to robustly reconstruct total system
> > > > state at a given time. And this matters, because errors in
> > > > reconstruction (e.g., assigning a thread to the wrong process because
> > > > the IDs happen to be reused) can affect processing of the whole trace.
> > > > If it's 3am and I'm analyzing the lone trace from a dogfooder
> > > > demonstrating a particularly nasty problem, I don't want to find out
> > > > that the trace I'm analyzing ended up being useless because the
> > > > kernel's trace system is merely best effort. It's very cheap to be
> > > > 100% reliable here, so let's be reliable and rule out sources of
> > > > error.
> > >
> > > So we're solving a problem which isn't known to occur, but solving it
> > > provides some peace-of-mind?  Sounds thin!
> >
> > So you want to reject a cheap fix for a problem that you know occurs
> > at some non-zero frequency? There's a big difference between "may or
> > may not occur" and "will occur eventually, given enough time, and so
> > must be taken into account in analysis". Would you fix a refcount race
> > that you knew was possible, but didn't observe? What, exactly, is your
> > threshold for accepting a fix that makes tracing more reliable?
>
> Well for a start I'm looking for a complete patch changelog.  One which
> permits readers to fully understand the user-visible impact of the
> problem.

The patch already describes the problem, the solution, and the way in
which this solution is provided. What more information do you want?

> If it is revealed that is a theoretical problem which has negligible
> end-user impact then sure, it is rational to leave things as they are.
> That's what "negligible" means!

I don't think the problem is negligible. There's a huge difference
between 99% and 100% reliability! The possibility of a theoretical
problem is a real problem when, in retrospective analysis, the
possibility of theoretical problems must be taken into account when
trying to figure out how the system got into whatever state it was
observed to be in.

Look, if I were proposing some expensive new bit of infrastructure,
that would be one thing. But this is trivial. What form of patch
*would* you take here? Would you take a tracepoint, as I discussed in
your other message? Is there *any* snapshot approach here that you
would take? Is your position that providing an atomic process tree
hierarchy snapshot is just not a capable the kernel should provide?

I'm writing trace analysis tools, and I'm saying that in order to be
confident in the results of the analysis, we need a way to be certain
about baseline system state, and without added robustness, there's
always going to be some doubt as to whether any particular observation
is real or an artifact. I'm open to various technical options for
providing this information, but I think it's reasonable to ask the
system "what is your state?" and somehow get back an answer that's
guaranteed not to be self-contradictory. Have you done much
retrospective long trace analysis?
