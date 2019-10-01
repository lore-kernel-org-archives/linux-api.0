From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Mon, 30 Sep 2019 18:22:28 -0700
Message-ID: <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201909301129.5A1129C@keescook>
Sender: netdev-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 30, 2019 at 11:31:29AM -0700, Kees Cook wrote:
> On Sat, Sep 28, 2019 at 07:37:27PM -0400, Steven Rostedt wrote:
> > On Wed, 28 Aug 2019 21:07:24 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > 
> > > > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > > > 
> > > > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > > > 
> > > > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > > > 
> > > > Does this make sense?  I’m a security person on occasion. I find
> > > > vulnerabilities and exploit them deliberately and I break things by
> > > > accident on a regular basis. In my considered opinion, CAP_TRACING
> > > > alone, even extended to cover part of BPF as I’ve described, is
> > > > decently safe. Getting root with just CAP_TRACING will be decently
> > > > challenging, especially if I don’t get to read things like sshd’s
> > > > memory, and improvements to mitigate even that could be added.  I
> > > > am quite confident that attacks starting with CAP_TRACING will have
> > > > clear audit signatures if auditing is on.  I am also confident that
> > > > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > > > will only get more likely as BPF gets more widely used. And, if
> > > > BPF-based auditing ever becomes a thing, writing to the audit
> > > > daemon’s maps will be a great way to cover one’s tracks.  
> > > 
> > > CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> > > I think Steven and Massami prefer that as well.
> > > That includes kprobe with probe_kernel_read.
> > > That also means mini-DoS by installing kprobes everywhere or running
> > > too much ftrace.
> > 
> > I was talking with Kees at Plumbers about this, and we were talking
> > about just using simple file permissions. I started playing with some
> > patches to allow the tracefs be visible but by default it would only be
> > visible by root.
> > 
> >  rwx------
> > 
> > Then a start up script (or perhaps mount options) could change the
> > group owner, and change this to:
> > 
> >  rwxrwx---
> > 
> > Where anyone in the group assigned (say "tracing") gets full access to
> > the file system.
> > 
> > The more I was playing with this, the less I see the need for
> > CAP_TRACING for ftrace and reading the format files.
> 
> Nice! Thanks for playing with this. I like it because it gives us a way
> to push policy into userspace (group membership, etc), and provides a
> clean way (hopefully) do separate "read" (kernel memory confidentiality)
> from "write" (kernel memory integrity), which wouldn't have been possible
> with a single new CAP_...

tracefs is a file system, so clearly file based acls are much better fit
for all tracefs operations.
But that is not the case for ftrace overall.
bpf_trace_printk() calls trace_printk() that dumps into trace pipe.
Technically it's ftrace operation, but it cannot be controlled by tracefs
and by file permissions. That's the motivation to guard bpf_trace_printk()
usage from bpf program with CAP_TRACING.

Both 'trace' and 'trace_pipe' have quirky side effects.
Like opening 'trace' file will make all parallel trace_printk() to be ignored.
While reading 'trace_pipe' file will clear it.
The point that traditional 'read' and 'write' ACLs don't map as-is
to tracefs, so I would be careful categorizing things into
confidentiality vs integrity only based on access type.
