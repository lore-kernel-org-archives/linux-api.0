From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: RFC: very rough draft of a bpf permission model
Date: Mon, 26 Aug 2019 15:36:00 -0700
Message-ID: <20190826223558.6torq6keplniif6w@ast-mbp>
References: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
 <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
 <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Chenbo Feng <chenbofeng.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 23, 2019 at 04:09:11PM -0700, Andy Lutomirski wrote:
> On Thu, Aug 22, 2019 at 4:26 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > You're proposing all of the above in addition to CAP_BPF, right?
> > Otherwise I don't see how it addresses the use cases I kept
> > explaining for the last few weeks.
> 
> None of my proposal is intended to exclude changes like CAP_BPF to
> make privileged bpf() operations need less privilege.  But I think
> it's very hard to evaluate CAP_BPF without both a full description of
> exactly what CAP_BPF would do and what at least one full example of a
> user would look like.

the example is previous email and systemd example was not "full" ?

> I also think that users who want CAP_BPF should look at manipulating
> their effective capability set instead.  A daemon that wants to use
> bpf() but otherwise minimize the chance of accidentally causing a
> problem can use capset() to clear its effective and inheritable masks.
> Then, each time it wants to call bpf(), it could re-add CAP_SYS_ADMIN
> or CAP_NET_ADMIN to its effective set, call bpf(), and then clear its
> effective set again.  This works in current kernels and is generally
> good practice.

Such logic means that CAP_NET_ADMIN is not necessary either.
The process could re-add CAP_SYS_ADMIN when it needs to reconfigure
network and then drop it.

> Aside from this, and depending on exactly what CAP_BPF would be, I
> have some further concerns.  Looking at your example in this email:
> 
> > Here is another example of use case that CAP_BPF is solving:
> > The daemon X is started by pid=1 and currently runs as root.
> > It loads a bunch of tracing progs and attaches them to kprobes
> > and tracepoints. It also loads cgroup-bpf progs and attaches them
> > to cgroups. All progs are collecting data about the system and
> > logging it for further analysis.
> 
> This needs more than just bpf().  Creating a perf kprobe event
> requires CAP_SYS_ADMIN, and without a perf kprobe event, you can't
> attach a bpf program.  

that is already solved sysctl_perf_event_paranoid.
CAP_BPF is about BPF part only.

> And the privilege to attach bpf programs to
> cgroups without any DAC or MAC checks (which is what the current API
> does) is an extremely broad privilege that is not that much weaker
> than CAP_SYS_ADMIN or CAP_NET_ADMIN.  Also:

I don't think there is a hierarchy of CAP_SYS_ADMIN vs CAP_NET_ADMIN
vs CAP_BPF.
CAP_BPF and CAP_NET_ADMIN carve different areas of CAP_SYS_ADMIN.
Just like all other caps.

> > This tracing bpf is looking into kernel memory
> > and using bpf_probe_read. Clearly it's not _secure_. But it's _safe_.
> > The system is not going to crash because of BPF,
> > but it can easily crash because of simple coding bugs in the user
> > space bits of that daemon.
> 
> The BPF verifier and interpreter, taken in isolation, may be extremely
> safe, but attaching BPF programs to various hooks can easily take down
> the system, deliberately or by accident.  A handler, especially if it
> can access user memory or otherwise fault, will explode if attached to
> an inappropriate kprobe, hw_breakpoint, or function entry trace event.

absolutely not true.

> (I and the other maintainers consider this to be a bug if it happens,
> and we'll fix it, but these bugs definitely exist.)  A cgroup-bpf hook
> that blocks all network traffic will effectively kill a machine,
> especially if it's a server. 

this permission is granted by CAP_NET_ADMIN. Nothing changes here.

> A bpf program that runs excessively
> slowly attached to a high-frequency hook will kill the system, too.

not true either.

> (I bet a buggy bpf program that calls bpf_probe_read() on an unmapped
> address repeatedly could be make extremely slow.  Page faults take
> thousands to tens of thousands of cycles.) 

kprobe probing and faulting on non-existent address will do
the same 'damage'. So it's not bpf related.
Also it won't make the system "extremely slow".
Nothing to do with CAP_BPF.

> A bpf firewall rule that's
> wrong can cut a machine off from the network -- I've killed machines
> using iptables more than once, and bpf isn't magically safer.

this is CAP_NET_ADMIN permission. It's a different capability.

> 
> I'm wondering if something like CAP_TRACING would make sense.
> CAP_TRACING would allow operations that can reveal kernel memory and
> other secret kernel state but that do not, by design, allow modifying
> system behavior.  So, for example, CAP_TRACING would allow privileged
> perf_event_open() operations and privileged bpf verifier usage.  But
> it would not allow cgroup-bpf unless further restrictions were added,
> and it would not allow the *_BY_ID operations, as those can modify
> other users' bpf programs' behavior.

Makes little sense to me.
I can imagine CAP_TRACING controlling kprobe/uprobe creation
and probe_read() both from bpf side and from vanilla kprobe.
That would be much nicer interface to use than existing
sysctl_perf_event_paranoid, but that is orthogonal to CAP_BPF
which is strictly about BPF.

> Something finer-grained can mitigate some of this.  CAP_BPF as I think
> you're imagining it will not.

I'm afraid this discussion goes nowhere.
We'll post CAP_BPF patches soon so we can discuss code.
