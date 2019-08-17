From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Sat, 17 Aug 2019 08:02:47 -0700
Message-ID: <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
References: <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
 <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
 <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
 <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 16, 2019 at 10:28:29PM +0200, Thomas Gleixner wrote:
> Alexei,
> 
> On Fri, 16 Aug 2019, Alexei Starovoitov wrote:
> > It's both of the above when 'systemd' is not taken literally.
> > To earlier Thomas's point: the use case is not only about systemd.
> > There are other containers management systems.
> 
> <SNIP>
> 
> > These daemons need to drop privileges to make the system safer == less
> > prone to corruption due to bugs in themselves. Not necessary security
> > bugs.
> 
> Let's take a step back.
> 
> While real usecases are helpful to understand a design decision, the design
> needs to be usecase independent.
> 
> The kernel provides mechanisms, not policies. My impression of this whole
> discussion is that it is policy driven. That's the wrong approach.

not sure what you mean by 'policy driven'.
Proposed CAP_BPF is a policy?

My desire to do kernel.unprivileged_bpf_disabled=1 is driven by
text in Documentation/x86/mds.rst which says:
"There is one exception, which is untrusted BPF. The functionality of
untrusted BPF is limited, but it needs to be thoroughly investigated
whether it can be used to create such a construct."

commit 6a9e52927251 ("x86/speculation/mds: Add mds_clear_cpu_buffers()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>

The way I read this text:
- there is a concern that mds is exploitable via bpf
- there is a desire to investigate to address this concern

I'm committed to help with the investigation.

In the mean time I propose a path to do
kernel.unprivileged_bpf_disabled=1 which is CAP_BPF.

Can kernel.unprivileged_bpf_disabled=1 be used now?
Yes, but it will weaken overall system security because things that
use unpriv to load bpf and CAP_NET_ADMIN to attach bpf would need
to move to stronger CAP_SYS_ADMIN.

With CAP_BPF both load and attach would happen under CAP_BPF
instead of CAP_SYS_ADMIN.

> So let's look at the mechanisms which we have at hand:
> 
>  1) Capabilities
>  
>  2) SUID and dropping priviledges
> 
>  3) Seccomp and LSM
> 
> Now the real interesting questions are:
> 
>  A) What kind of restrictions does BPF allow? Is it a binary on/off or is
>     there a more finegrained control of BPF functionality?
> 
>     TBH, I can't tell.
> 
>  B) Depending on the answer to #A what is the control possibility for
>     #1/#2/#3 ?

Can any of the mechanisms 1/2/3 address the concern in mds.rst?

I believe Andy wants to expand the attack surface when
kernel.unprivileged_bpf_disabled=0
Before that happens I'd like the community to work on addressing the text above.
