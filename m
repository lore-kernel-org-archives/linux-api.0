From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Wed, 28 Aug 2019 21:07:24 -0700
Message-ID: <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 28, 2019 at 05:45:47PM -0700, Andy Lutomirski wrote:
> > 
> >> It seems like you are specifically trying to add a new switch to turn
> >> as much of BPF as possible on and off.  Why?
> > 
> > Didn't I explain it several times already with multiple examples
> > from systemd, daemons, bpftrace ?
> > 
> > Let's try again.
> > Take your laptop with linux distro.
> > You're the only user there. I'm assuming you're not sharing it with
> > partner and kids. This is my definition of 'single user system'.
> > You can sudo on it at any time, but obviously prefer to run as many
> > apps as possible without cap_sys_admin.
> > Now you found some awesome open source app on the web that monitors
> > the health of the kernel and will pop a nice message on a screen if
> > something is wrong. Currently this app needs root. You hesitate,
> > but the apps is so useful and it has strong upstream code review process
> > that you keep running it 24/7.
> > This is open source app. New versions come. You upgrade.
> > You have enough trust in that app that you keep running it as root.
> > But there is always a chance that new version doing accidentaly
> > something stupid as 'kill -9 -1'. It's an open source app at the end.
> > 
> > Now I come with this CAP* proposal to make this app safer.
> > I'm not making your system more secure and not making this app
> > more secure. I can only make your laptop safer for day to day work
> > by limiting the operations this app can do.
> > This particular app monitros the kernel via bpf and tracing.
> > Hence you can give it CAP_TRACING and CAP_BPF and drop the rest.
> 
> This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> 
> 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> 
> 2. Improve it a bit do all the privileged ops are wrapped by capset().
> 
> Does this make sense?  I’m a security person on occasion. I find vulnerabilities and exploit them deliberately and I break things by accident on a regular basis. In my considered opinion, CAP_TRACING alone, even extended to cover part of BPF as I’ve described, is decently safe. Getting root with just CAP_TRACING will be decently challenging, especially if I don’t get to read things like sshd’s memory, and improvements to mitigate even that could be added.  I am quite confident that attacks starting with CAP_TRACING will have clear audit signatures if auditing is on.  I am also confident that CAP_BPF *will* allow DoS and likely privilege escalation, and this will only get more likely as BPF gets more widely used. And, if BPF-based auditing ever becomes a thing, writing to the audi
 t daemon’s maps will be a great way to cover one’s tracks.

CAP_TRACING, as I'm proposing it, will allow full tracefs access.
I think Steven and Massami prefer that as well.
That includes kprobe with probe_kernel_read.
That also means mini-DoS by installing kprobes everywhere or running too much ftrace.

CAP_TRACING will allow perf_event_open() too.
Which also means mini-DoS with too many events.

CAP_TRACING with or without CAP_BPF is safe, but it's not secure.
And that's what I need to make above 'open source kernel health app' to be safe.

In real world we have tens of such apps and they use all of the things that
I'm allowing via CAP_BPF + CAP_NET_ADMIN + CAP_TRACING.
Some apps will need only two out of three.
I don't see any further possibility to shrink the scope of the proposal.

> I’m trying to convince you that bpf’s security model can be made better
> than what you’re proposing. I’m genuinely not trying to get in your way.
> I’m trying to help you improve bpf.

If you really want to help please don't reject the real use cases
just because they don't fit into your proposal.

There is not a single feature in BPF land that we did because we simply
wanted to. For every feature we drilled into use cases to make sure
there is a real user behind it.
Same thing with CAP_BPF. I'm defining it to include GET_FD_BY_ID because
apps use it and they need to made safer.

Anyway the v2 version of the patch with CAP_TRACING and CAP_BPF is on the way.
Hopefully later tonight or tomorrow.
