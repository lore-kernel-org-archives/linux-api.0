From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Thu, 3 Oct 2019 09:20:17 -0700
Message-ID: <20191003162015.7bpyik3z5zulpqon@ast-mbp.dhcp.thefacebook.com>
References: <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
 <20191003151204.5857bb24245f9c3355f27e0d@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191003151204.5857bb24245f9c3355f27e0d@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 03, 2019 at 03:12:04PM +0900, Masami Hiramatsu wrote:
> On Mon, 30 Sep 2019 11:31:29 -0700
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Sat, Sep 28, 2019 at 07:37:27PM -0400, Steven Rostedt wrote:
> > > On Wed, 28 Aug 2019 21:07:24 -0700
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > > 
> > > > > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > > > > 
> > > > > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > > > > 
> > > > > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > > > > 
> > > > > Does this make sense?  I’m a security person on occasion. I find
> > > > > vulnerabilities and exploit them deliberately and I break things by
> > > > > accident on a regular basis. In my considered opinion, CAP_TRACING
> > > > > alone, even extended to cover part of BPF as I’ve described, is
> > > > > decently safe. Getting root with just CAP_TRACING will be decently
> > > > > challenging, especially if I don’t get to read things like sshd’s
> > > > > memory, and improvements to mitigate even that could be added.  I
> > > > > am quite confident that attacks starting with CAP_TRACING will have
> > > > > clear audit signatures if auditing is on.  I am also confident that
> > > > > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > > > > will only get more likely as BPF gets more widely used. And, if
> > > > > BPF-based auditing ever becomes a thing, writing to the audit
> > > > > daemon’s maps will be a great way to cover one’s tracks.  
> > > > 
> > > > CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> > > > I think Steven and Massami prefer that as well.
> > > > That includes kprobe with probe_kernel_read.
> > > > That also means mini-DoS by installing kprobes everywhere or running
> > > > too much ftrace.
> > > 
> > > I was talking with Kees at Plumbers about this, and we were talking
> > > about just using simple file permissions. I started playing with some
> > > patches to allow the tracefs be visible but by default it would only be
> > > visible by root.
> > > 
> > >  rwx------
> > > 
> > > Then a start up script (or perhaps mount options) could change the
> > > group owner, and change this to:
> > > 
> > >  rwxrwx---
> > > 
> > > Where anyone in the group assigned (say "tracing") gets full access to
> > > the file system.
> 
> Does it for "all" files under tracefs?
> 
> > > 
> > > The more I was playing with this, the less I see the need for
> > > CAP_TRACING for ftrace and reading the format files.
> > 
> > Nice! Thanks for playing with this. I like it because it gives us a way
> > to push policy into userspace (group membership, etc), and provides a
> > clean way (hopefully) do separate "read" (kernel memory confidentiality)
> > from "write" (kernel memory integrity), which wouldn't have been possible
> > with a single new CAP_...
> 
>  From the confidentiality point of view, if tracefs exposes traced data,
> it might include in-kernel pointer and symbols, but the user still can't
> see /proc/kallsyms. This means we still have several different confidentiality
> for each interface.
> 
> Anyway, adding a tracefs mount option for allowing a user group to access
> event format data will be a good idea. But even though, I  think we still
> need the CAP_TRACING for allowing control of intrusive tracing, like kprobes
> and bpf etc. (Or, do we keep those for CAP_SYS_ADMIN??)

No doubt. This thread is only about tracefs wanting to do its own fs based controls.
