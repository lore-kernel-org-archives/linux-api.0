From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Wed, 14 Aug 2019 16:59:18 -0700
Message-ID: <317422C3-ACE3-42A7-A287-7B8FEE12E33A@amacapital.net>
References: <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com> <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com> <20190813215823.3sfbakzzjjykyng2@ast-mbp> <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com> <20190814005737.4qg6wh4a53vmso2v@ast-mbp> <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com> <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com> <AD211133-EA60-4B91-AB1B-201713F50AB2@amacapital.net> <20190814233335.37t4zfsiswrpd4d6@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190814233335.37t4zfsiswrpd4d6@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 14, 2019, at 4:33 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
>> On Wed, Aug 14, 2019 at 03:30:51PM -0700, Andy Lutomirski wrote:
>>=20
>>=20
>>>> On Aug 14, 2019, at 3:05 PM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>>=20
>>>> On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
>>>>=20
>>>> If eBPF is genuinely not usable by programs that are not fully trusted
>>>> by the admin, then no kernel changes at all are needed.  Programs that
>>>> want to reduce their own privileges can easily fork() a privileged
>>>> subprocess or run a little helper to which they delegate BPF
>>>> operations.  This is far more flexible than anything that will ever be
>>>> in the kernel because it allows the helper to verify that the rest of
>>>> the program is doing exactly what it's supposed to and restrict eBPF
>>>> operations to exactly the subset that is needed.  So a container
>>>> manager or network manager that drops some provilege could have a
>>>> little bpf-helper that manages its BPF XDP, firewalling, etc
>>>> configuration.  The two processes would talk over a socketpair.
>>>=20
>>> there were three projects that tried to delegate bpf operations.
>>> All of them failed.
>>> bpf operational workflow is much more complex than you're imagining.
>>> fork() also doesn't work for all cases.
>>> I gave this example before: consider multiple systemd-like deamons
>>> that need to do bpf operations that want to pass this 'bpf capability'
>>> to other deamons written by other teams. Some of them will start
>>> non-root, but still need to do bpf. They will be rpm installed
>>> and live upgraded while running.
>>> We considered to make systemd such centralized bpf delegation
>>> authority too. It didn't work. bpf in kernel grows quickly.
>>> libbpf part grows independently. llvm keeps evolving.
>>> All of them are being changed while system overall has to stay
>>> operational. Centralized approach breaks apart.
>>>=20
>>>> The interesting cases you're talking about really *do* involved
>>>> unprivileged or less privileged eBPF, though.  Let's see:
>>>>=20
>>>> systemd --user: systemd --user *is not privileged at all*.  There's no
>>>> issue of reducing privilege, since systemd --user doesn't have any
>>>> privilege to begin with.  But systemd supports some eBPF features, and
>>>> presumably it would like to support them in the systemd --user case.
>>>> This is unprivileged eBPF.
>>>=20
>>> Let's disambiguate the terminology.
>>> This /dev/bpf patch set started as describing the feature as 'unprivileg=
ed bpf'.
>>> I think that was a mistake.
>>> Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
>>> This is not unprivileged.
>>> 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled contr=
ols.
>>>=20
>>> There is a huge difference between the two.
>>> I'm against extending 'unprivileged bpf' even a bit more than what it is=

>>> today for many reasons mentioned earlier.
>>> The /dev/bpf is about 'less privileged'.
>>> Less privileged than root. We need to split part of full root capability=

>>> into bpf capability. So that most of the root can be dropped.
>>> This is very similar to what cap_net_admin does.
>>> cap_net_amdin can bring down eth0 which is just as bad as crashing the b=
ox.
>>> cap_net_admin is very much privileged. Just 'less privileged' than root.=

>>> Same thing for cap_bpf.
>>=20
>> The new pseudo-capability in this patch set is absurdly broad. I=E2=80=99=
ve proposed some finer-grained divisions in this thread. Do you have comment=
s on them?
>=20
> Initially I agreed that it's probably too broad, but then realized
> that they're perfect as-is. There is no need to partition further.
>=20
>>> May be we should do both cap_bpf and /dev/bpf to make it clear that
>>> this is the same thing. Two interfaces to achieve the same result.
>>=20
>> What for?  If there=E2=80=99s a CAP_BPF, then why do you want /dev/bpf? E=
specially if you define it to do the same thing.
>=20
> Indeed, ambient capabilities should work for all cases.
>=20
>> No, I=E2=80=99m not.  I have no objection at all if you try to come up wi=
th a clear definition of what the capability checks do and what it means to g=
rant a new permission to a task.  Changing *all* of the capable checks is ne=
edlessly broad.
>=20
> There are not that many bits left. I prefer to consume single CAP_BPF bit.=

> All capable(CAP_SYS_ADMIN) checks in kernel/bpf/ will become CAP_BPF.
> This is no-brainer.
>=20
> The only question is whether few cases of CAP_NET_ADMIN in kernel/bpf/
> should be extended to CAP_BPF or not.
> imo devmap and xskmap can stay CAP_NET_ADMIN,
> but cgroup bpf attach/detach should be either CAP_NET_ADMIN or CAP_BPF.
> Initially cgroup-bpf hooks were limited to networking.
> It's no longer the case. Requiring NET_ADMIN there make little sense now.
>=20

Cgroup bpf attach/detach, with the current API, gives very strong control ov=
er the whole system, and it will just get stronger as bpf gains features. Ma=
king it CAP_BPF means that you will never have the ability to make CAP_BPF s=
afe to give to anything other than an extremely highly trusted process.  Uns=
afe pointers are similar.  The rest could plausibly be hardened in the futur=
e, although the by_id stuff may be tricky too.

Do new programs really need the by_id calls?  It could make sense to leave t=
hose unchanged and to have new programs use persistent maps instead.=
