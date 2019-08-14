From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Tue, 13 Aug 2019 17:57:39 -0700
Message-ID: <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
References: <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 04:06:00PM -0700, Andy Lutomirski wrote:
> On Tue, Aug 13, 2019 at 2:58 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 06, 2019 at 10:24:25PM -0700, Andy Lutomirski wrote:
> > > >
> > > > Inside containers and inside nested containers we need to start processes
> > > > that will use bpf. All of the processes are trusted.
> > >
> > > Trusted by whom?  In a non-nested container, the container manager
> > > *might* be trusted by the outside world.  In a *nested* container,
> > > unless the inner container management is controlled from outside the
> > > outer container, it's not trusted.  I don't know much about how
> > > Facebook's containers work, but the LXC/LXD/Podman world is moving
> > > very strongly toward user namespaces and maximally-untrusted
> > > containers, and I think bpf() should work in that context.
> >
> > agree that containers (namespaces) reduce amount of trust necessary
> > for apps to run, but the end goal is not security though.
> > Linux has become a single user system.
> > If user can ssh into the host they can become root.
> > If arbitrary code can run on the host it will be break out of any sandbox.
> 
> I would argue that this is a reasonable assumption to make if you're
> designing a system using Linux, but it's not a valid assumption to
> make as kernel developers.  Otherwise we should just give everyone
> CAP_SYS_ADMIN and call it a day.  There really is a difference between
> root and non-root.

hmm. No. Kernel developers should not make any assumptions.
They should guide their design by real use cases instead. That includes studing
what people do now and hacks they use to workaround lack of interfaces.
Effecitvely bpf is root only. There are no unpriv users.
This root applications go out of their way to reduce privileges
while they still want to use bpf. That is the need that /dev/bpf is solving.

> 
> > Containers are not providing the level of security that is enough
> > to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
> > Containers are used to make production systems safer.
> > Some people call it more 'secure', but it's clearly not secure for
> > arbitrary code and that is what kernel.unprivileged_bpf_disabled allows.
> > When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> > It's been a constant source of pain. The constant blinding, randomization,
> > verifier speculative analysis, all spectre v1, v2, v4 mitigations
> > are simply not worth it. It's a lot of complex kernel code without users.
> 
> Seccomp really will want eBPF some day, and it should work without
> privilege.  Maybe it should be a restricted subset of eBPF, and
> Spectre will always be an issue until dramatically better hardware
> shows up, but I think people will want the ability for regular
> programs to load eBPF seccomp programs.

I'm absolutely against using eBPF in seccomp.
Precisely due to discussions like the current one.

> 
> > Hence I prefer this /dev/bpf mechanism to be as simple a possible.
> > The applications that will use it are going to be just as trusted as systemd.
> 
> I still don't understand your systemd example.  systemd --users is not
> trusted systemwide in any respect.  The main PID 1 systemd is root.
> No matter how you dice it, granting a user systemd instance extra bpf
> access is tantamount to granting the user extra bpf access in general.

People use systemd --user while their kernel have 'undef CONFIG_USER_NS'.

> It sounds to me like you're thinking of eBPF as a feature a bit like
> unprivileged user namespaces: *in principle*, it's supposed to be safe
> to give any unprivileged process the ability to use it, and you
> consider security flaws in it to be bugs worth fixing. But you think
> it's a large attack surface and that most unprivileged programs
> shouldn't be allowed to use it.  Is that reasonable?

I think there should be no unprivileged bpf at all,
because over all these years we've seen zero use cases.
Hence all new features are root only.
LPM map is a prime example. There was not a single security bug in there.
There were few functional bugs, but not security issues.
These bugs didn't crash the kernel and didn't expose any data.
Yet we still keep LPM as root only.
Can we flip the switch and make it non-root? It's trivial single line patch ?
and security risk is very low?
Nope, since it will not address the underlying issue.
