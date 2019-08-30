From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
Date: Thu, 29 Aug 2019 21:16:39 -0700
Message-ID: <CAADnVQLiD_2dTWXgaC773Uo+4LPz=vFEysXUnUcsJ9FKBk5Q7g@mail.gmail.com>
References: <20190829051253.1927291-1-ast@kernel.org> <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <536636ad-0baf-31e9-85fe-2591b65068df@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "David S. Miller" <davem@davemloft.net>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 8:47 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
> [...]
> >
> > +/*
> > + * CAP_BPF allows the following BPF operations:
> > + * - Loading all types of BPF programs
> > + * - Creating all types of BPF maps except:
> > + *    - stackmap that needs CAP_TRACING
> > + *    - devmap that needs CAP_NET_ADMIN
> > + *    - cpumap that needs CAP_SYS_ADMIN
> > + * - Advanced verifier features
> > + *   - Indirect variable access
> > + *   - Bounded loops
> > + *   - BPF to BPF function calls
> > + *   - Scalar precision tracking
> > + *   - Larger complexity limits
> > + *   - Dead code elimination
> > + *   - And potentially other features
> > + * - Use of pointer-to-integer conversions in BPF programs
> > + * - Bypassing of speculation attack hardening measures
> > + * - Loading BPF Type Format (BTF) data
> > + * - Iterate system wide loaded programs, maps, BTF objects
> > + * - Retrieve xlated and JITed code of BPF programs
> > + * - Access maps and programs via id
> > + * - Use bpf_spin_lock() helper
>
> This is still very wide.

'still very wide' ? you make it sound like it's a bad thing.
Covering all of bpf with single CAP_BPF is #1 goal of this set.

> Consider following example: app has CAP_BPF +> CAP_NET_ADMIN. Why can't we in this case *only* allow loading networking
> related [plus generic] maps and programs? If it doesn't have CAP_TRACING,
> what would be a reason to allow loading it? Same vice versa. There are
> some misc program types like the infraread stuff, but they could continue
> to live under [CAP_BPF +] CAP_SYS_ADMIN as fallback. I think categorizing
> a specific list of prog and map types might be more clear than disallowing
> some helpers like below (e.g. why choice of bpf_probe_read() but not
> bpf_probe_write_user() etc).

It kinda makes sense:
cap_bpf+cap_net_admin allows networking progs.
cap_bpf+cap_tracing allows tracing progs.
But what to do with cg_sysctl, cg_device, lirc ?
They are clearly neither.
Invent yet another cap_foo for them?
or let them under cap_bpf alone?
If cap_bpf alone is enough then why bother with bpf+net_admin for networking?
It's not making anything cleaner. Only confuses users.

Also bpf_trace_printk() is using ftrace and can print arbitrary memory.
In that sense it's no different than bpf_probe_read.
Both should be under CAP_TRACING.
But bpf_trace_printk() is available to all progs.
Even to socket filters under cap_sys_admin today.
With this patch set I'm allowing bpf_trace_printk() under CAP_TRACING.
Same goes to bpf_probe_read.

High level description:
cap_bpf alone allows loading of all progs except when
later cap_net_admin or cap_tracing will _not_ be able to
filter out the helper at attach time that shouldn't be there.

Example of how this patch set works:
- to load and attach networking progs
both cap_bpf and cap_net_admin are necessary.
- to load and attach tracing progs
both cap_bpf and cap_tracing are necessary.

when networking prog is using bpf_trace_printk
then cap_tracing is needed too.
And it's checked at load time.
If we do what you're proposing:
"lets allow load of all networking with bpf+net_admin"
then this won't work for bpf_trace_printk.
Per helper function capability check is still needed.
And since it's needed I see no reason to limit
networking progs to bpf+net_admin at load time.
Load time is still cap_bpf only.
And helpers will be filtered out at attach by net_admin.
