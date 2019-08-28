From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Wed, 28 Aug 2019 15:55:15 -0700
Message-ID: <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 27, 2019 at 11:12:29PM -0700, Andy Lutomirski wrote:
> >
> > >
> > > From the previous discussion, you want to make progress toward solving
> > > a lot of problems with CAP_BPF.  One of them was making BPF
> > > firewalling more generally useful. By making CAP_BPF grant the ability
> > > to read kernel memory, you will make administrators much more nervous
> > > to grant CAP_BPF.
> >
> > Andy, were your email hacked?
> > I explained several times that in this proposal
> > CAP_BPF _and_ CAP_TRACING _both_ are necessary to read kernel memory.
> > CAP_BPF alone is _not enough_.
> 
> You have indeed said this many times.  You've stated it as a matter of
> fact as though it cannot possibly discussed.  I'm asking you to
> justify it.

That's not how I see it.
I kept stating that both CAP_BPF and CAP_TRACING are necessary to read
kernel memory whereas you kept distorting my statement by dropping second
part and then making claims that "CAP_BPF grant the ability to read
kernel memory, you will make administrators much more nervous".

Just s/CAP_BPF/CAP_BPF and CAP_TRACING/ in this above sentence.
See that meaning suddenly changes?
Now administrators would be worried about tasks that have both at once.
They also would be worried about tasks that have CAP_TRACING alone,
because that's what allows probe_kernel_read().

> It seems like you are specifically trying to add a new switch to turn
> as much of BPF as possible on and off.  Why?

Didn't I explain it several times already with multiple examples
from systemd, daemons, bpftrace ?

Let's try again.
Take your laptop with linux distro.
You're the only user there. I'm assuming you're not sharing it with
partner and kids. This is my definition of 'single user system'.
You can sudo on it at any time, but obviously prefer to run as many
apps as possible without cap_sys_admin.
Now you found some awesome open source app on the web that monitors
the health of the kernel and will pop a nice message on a screen if
something is wrong. Currently this app needs root. You hesitate,
but the apps is so useful and it has strong upstream code review process
that you keep running it 24/7.
This is open source app. New versions come. You upgrade.
You have enough trust in that app that you keep running it as root.
But there is always a chance that new version doing accidentaly
something stupid as 'kill -9 -1'. It's an open source app at the end.

Now I come with this CAP* proposal to make this app safer.
I'm not making your system more secure and not making this app
more secure. I can only make your laptop safer for day to day work
by limiting the operations this app can do.
This particular app monitros the kernel via bpf and tracing.
Hence you can give it CAP_TRACING and CAP_BPF and drop the rest.

> > speaking of MDS... I already asked you to help investigate its
> > applicability with existing bpf exposure. Are you going to do that?
> 
> I am blissfully uninvolved in MDS, and I don't know all that much more
> about the overall mechanism than a random reader of tech news :)  ISTM
> there are two meaningful ways that BPF could be involved: a BPF
> program could leak info into the state exposed by MDS, or a BPF
> program could try to read that state.  From what little I understand,
> it's essentially inevitable that BPF leaks information into MDS state,
> and this is probably even controllable by an attacker that understands
> MDS in enough detail.    So the interesting questions are: can BPF be
> used to read MDS state and can BPF be used to leak information in a
> more useful way than the rest of the kernel to an attacker.

agree. that's exactly the question to ask.

> Keeping in mind that the kernel will flush MDS state on every exit to
> usermode, I think the most likely attack is to try to read MDS state
> with BPF.  This could happen, I suppose -- BPF programs can easily
> contain the usual speculation gadgets of "do something and read an
> address that depends on the outcome".  Fortunately, outside of
> bpf_probe_read(), AFAIK BPF programs can't directly touch user memory,
> and an attacker that is allowed to use bpf_probe_read() doesn't need
> MDS to read things.

true as well.
So what do we do with that sentence in Documentation/x86/mds.rst?
Nothing?
New hw bugs will keep coming.
All of them should get similar wording?
Your understanding of MDS and BPF is way above the average.
What other users suppose to do when they read such sentence?
I think they have no choice but to do kernel.unprivileged_bpf_disabled=1.
We, as a kernel community, are forcing the users into it.
Hence I really do not see a value in any proposal today that expands
unprivileged bpf usage.
Since kernel.unprivileged_bpf_disabled=1 all bpf is under cap_sys_admin.
It's not great from security and safety pov. Hence this CAP* proposal.

> > Please take a look at Jann's var1 exploit. Was it hard to run bpf prog
> > in controlled environment without test_run command ?
> >
> 
> Can you send me a link?

https://bugs.chromium.org/p/project-zero/issues/detail?id=1272
writeup_files.tar:kernel_leak_exploit_amd_pro_a8_9600_r7/bpf_stuff.c
Execution is as trivial as write(sockfd, "X", 1) line 405.
