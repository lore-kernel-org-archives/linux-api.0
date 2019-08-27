From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: RFC: very rough draft of a bpf permission model
Date: Mon, 26 Aug 2019 17:34:29 -0700
Message-ID: <20190827003427.hcvrobr23uhqwmq5@ast-mbp>
References: <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
 <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
 <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
 <20190826223558.6torq6keplniif6w@ast-mbp>
 <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Chenbo Feng <chenbofeng.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 26, 2019 at 05:05:58PM -0700, Andy Lutomirski wrote:
> >>
> >> The BPF verifier and interpreter, taken in isolation, may be extremely
> >> safe, but attaching BPF programs to various hooks can easily take down
> >> the system, deliberately or by accident.  A handler, especially if it
> >> can access user memory or otherwise fault, will explode if attached to
> >> an inappropriate kprobe, hw_breakpoint, or function entry trace event.
> >
> > absolutely not true.
> 
> This is not a constructive way to have a conversation.  When you get
> an email that contains a statement you disagree with, perhaps you
> could try to give some argument as to why you disagree rather than
> just saying "absolutely not true".  Especially when you are talking to
> one of the maintainers of the affected system who has a
> not-yet-finished branch that addresses some of the bugs that you claim
> absolutely don't exist.  If it's really truly necessary, I can go and
> write an example that will crash an x86 kernel, but I feel like it
> would be a waste of everyone's time.

Please do write an example and prove your earlier sensational statement
that "can _easily_ take down the system" by attaching bpf to kprobe.

Most of the functions where kprobes are not allowed are already
marked by 'nokprobe'. All of them marked? Probably not.
There could be places where kprobe will blow the system, but
1. it's not easy to do. unlike your claim
2. that issue has nothing to do with bpf safety guarantees.

> How confident are you that the BPF program that calls bpf_probe_read()
> on an MMIO address has well-defined semantics?  How confident are you
> that the system will still work if such a program runs?

bpf_probe_read is a wrapper of probe_read. Nothing more.
I'm confident that probe_read maintainers are doing good job.

All of the bpf tracing is relying on existing kernel mechanisms
like kprobe, uprobe, perf, probe_read, etc.
bpf verifier cannot make them safer.
If reading mmio via bpf_probe_read will trigger undesired
hw behavior there is nothing bpf verifier can do about it.
