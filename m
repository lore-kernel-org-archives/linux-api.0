From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 19 Aug 2019 10:38:56 -0700
Message-ID: <CA2D2573-D90D-4904-A8B5-08C9C5FC7A56@amacapital.net>
References: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com> <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com> <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch> <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de> <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch> <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com> <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de> <20190817150245.xxzxqjpvgqsxmloe@ast-mbp> <alpine.DEB.2.21.1908191103130.1923@nanos.tec.linutronix.de> <20190819172718.jwnvvotssxwhc7m6@ast-mbp.dhcp.thefacebo
 ok.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190819172718.jwnvvotssxwhc7m6@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jordan Glover <Golden_Miller83@protonmail.ch>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 19, 2019, at 10:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
>> On Mon, Aug 19, 2019 at 11:15:11AM +0200, Thomas Gleixner wrote:
>> Alexei,
>>=20
>>> On Sat, 17 Aug 2019, Alexei Starovoitov wrote:
>>>> On Fri, Aug 16, 2019 at 10:28:29PM +0200, Thomas Gleixner wrote:
>>>> On Fri, 16 Aug 2019, Alexei Starovoitov wrote:
>>>> While real usecases are helpful to understand a design decision, the de=
sign
>>>> needs to be usecase independent.
>>>>=20
>>>> The kernel provides mechanisms, not policies. My impression of this who=
le
>>>> discussion is that it is policy driven. That's the wrong approach.
>>>=20
>>> not sure what you mean by 'policy driven'.
>>> Proposed CAP_BPF is a policy?
>>=20
>> I was referring to the discussion as a whole.
>>=20
>>> Can kernel.unprivileged_bpf_disabled=3D1 be used now?
>>> Yes, but it will weaken overall system security because things that
>>> use unpriv to load bpf and CAP_NET_ADMIN to attach bpf would need
>>> to move to stronger CAP_SYS_ADMIN.
>>>=20
>>> With CAP_BPF both load and attach would happen under CAP_BPF
>>> instead of CAP_SYS_ADMIN.
>>=20
>> I'm not arguing against that.
>>=20
>>>> So let's look at the mechanisms which we have at hand:
>>>>=20
>>>> 1) Capabilities
>>>>=20
>>>> 2) SUID and dropping priviledges
>>>>=20
>>>> 3) Seccomp and LSM
>>>>=20
>>>> Now the real interesting questions are:
>>>>=20
>>>> A) What kind of restrictions does BPF allow? Is it a binary on/off or i=
s
>>>>    there a more finegrained control of BPF functionality?
>>>>=20
>>>>    TBH, I can't tell.
>>>>=20
>>>> B) Depending on the answer to #A what is the control possibility for
>>>>    #1/#2/#3 ?
>>>=20
>>> Can any of the mechanisms 1/2/3 address the concern in mds.rst?
>>=20
>> Well, that depends. As with any other security policy which is implemente=
d
>> via these mechanisms, the policy can be strict enough to prevent it by no=
t
>> allowing certain operations. The more fine-grained the control is, it
>> allows the administrator who implements the policy to remove the
>> 'dangerous' parts from an untrusted user.
>>=20
>> So really question #A is important for this. Is BPF just providing a bina=
ry
>> ON/OFF knob or does it allow to disable/enable certain aspects of BPF
>> functionality in a more fine grained way? If the latter, then it might be=

>> possible to control functionality which might be abused for exploits of
>> some sorts (including MDS) in a way which allows other parts of BBF to be=

>> exposed to less priviledged contexts.
>=20
> I see. So the kernel.unprivileged_bpf_disabled knob is binary and I think i=
t's
> the right mechanism to expose to users.
> Having N knobs for every map/prog type won't decrease attack surface.
> In the other email Andy's quoting seccomp man page...
> Today seccomp cannot really look into bpf_attr syscall args, but even
> if it could it won't secure the system.
> Examples:
> 1.
> spectre v2 is using bpf in-kernel interpreter in speculative way.
> The mere presence of interpreter as part of kernel .text makes the exploit=

> easier to do. That was the reason to do CONFIG_BPF_JIT_ALWAYS_ON.
> For this case even kernel.unprivileged_bpf_disabled=3D1 was hopeless.
>=20
> 2.
> var4 doing store hazard. It doesn't matter which program type is used.
> load/store instructions are the same across program types.
>=20
> 3.
> prog_array was used as part of var1. I guess it was simply more
> convenient for Jann to do it this way :) All other map types
> have the same out-of-bounds speculation issue.
>=20
> In general side channels are cpu bugs that are exploited via sequences
> of cpu instructions. In that sense bpf infra provides these instructions.
> So all program types and all maps have the same level of 'side channel ris=
k'.
>=20
>>> I believe Andy wants to expand the attack surface when
>>> kernel.unprivileged_bpf_disabled=3D0
>>> Before that happens I'd like the community to work on addressing the tex=
t above.
>>=20
>> Well, that text above can be removed when the BPF wizards are entirely su=
re
>> that BPF cannot be abused to exploit stuff.=20
>=20
> Myself and Daniel looked at it in detail. I think we understood
> MDS mechanism well enough. Right now we're fairly confident that
> combination of existing mechanisms we did for var4 and
> verifier speculative analysis protect us from MDS.
> The thing is that every new cpu bug is looked at through the bpf lenses.
> Can it be exploited through bpf? Complexity of side channels
> is growing. Can the most recent swapgs be exploited ?
> What if we kprobe+bpf somewhere ?
> I don't think there is an issue, but we will never be 'entirely sure'.
> Even if myself and Daniel are sure the concern will stay.
> Unprivileged bpf as a whole is the concern due to side channels.
> The number of them are not yet disclosed. Who is going to analyze them?
> imo the only answer to that is kernel.unprivileged_bpf_disabled=3D1
> which together with CONFIG_BPF_JIT_ALWAYS_ON is secure enough.
> The other option is to sprinkle every bpf load/store with lfence
> which will make execution so slow that it will be unusable.
> Which is effectively the same as unprivileged_bpf_disabled=3D1.
>=20
> There are other things we can do. Like kasan-style shadow memory
> for bpf execution. Auto re-JITing the code after it's running.
> We can do lfences everywhere for some time then re-JIT
> when kasan-ed shadow memory shows only clean memory accesses.
> The beauty of BPF that it is analyze-able and JIT-able instruction set.
> The verifier speculative analysis is an example that the kernel
> can analyze the speculative execution path that cpu will
> take before the code starts executing.
> Unprivileged bpf can made absolutely secure. It can be
> made more secure than the rest of the kernel.
> But today we should just go with unprivileged_bpf_disabled=3D1

I=E2=80=99m still okay with this.

> and CAP_BPF.
>=20

I think this needs more design work.  I=E2=80=99m halfway through writing up=
 an actual proposal. I=E2=80=99ll send it soon.=
