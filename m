From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Tue, 23 Jul 2019 22:56:23 +0000
Message-ID: <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
Content-Language: en-US
Content-ID: <5EC7F3F996308B4AB86FDA88D0984145@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Jul 23, 2019, at 8:11 AM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Jul 22, 2019 at 1:54 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Andy, Lorenz, and all,
>>=20
>>> On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
>>>>=20
>>>> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
>>>>> I think I'm understanding your motivation.  You're not trying to make
>>>>> bpf() generically usable without privilege -- you're trying to create
>>>>> a way to allow certain users to access dangerous bpf functionality
>>>>> within some limits.
>>>>>=20
>>>>> That's a perfectly fine goal, but I think you're reinventing the
>>>>> wheel, and the wheel you're reinventing is quite complicated and
>>>>> already exists.  I think you should teach bpftool to be secure when
>>>>> installed setuid root or with fscaps enabled and put your policy in
>>>>> bpftool.  If you want to harden this a little bit, it would seem
>>>>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
>>>>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of th=
e
>>>>> capabilities that they currently check.
>>>>=20
>>>> If finer grained controls are wanted, it does seem like the /dev/bpf
>>>> path makes the most sense. open, request abilities, use fd. The open c=
an
>>>> be mediated by DAC and LSM. The request can be mediated by LSM. This
>>>> provides a way to add policy at the LSM level and at the tool level.
>>>> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owne=
d
>>>> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
>>>> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>>>>=20
>>>> With only a new CAP, you don't get the fine-grained controls. (The
>>>> "request abilities" part is the key there.)
>>>=20
>>> Sure you do: the effective set.  It has somewhat bizarre defaults, but
>>> I don't think that's a real problem.  Also, this wouldn't be like
>>> CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
>>>=20
>>> I think that a /dev capability-like object isn't totally nuts, but I
>>> think we should do it well, and this patch doesn't really achieve
>>> that.  But I don't think bpf wants fine-grained controls like this at
>>> all -- as I pointed upthread, a fine-grained solution really wants
>>> different treatment for the different capable() checks, and a bunch of
>>> them won't resemble capabilities or /dev/bpf at all.
>>=20
>> With 5.3-rc1 out, I am back on this. :)
>>=20
>> How about we modify the set as:
>>  1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.
>=20
> I'm fine with this in principle, but:
>=20
>>  2. Better handling of capable() calls through bpf code. I guess the
>>     biggest problem here is is_priv in verifier.c:bpf_check().
>=20
> I think it would be good to understand exactly what /dev/bpf will
> enable one to do.  Without some care, it would just become the next
> CAP_SYS_ADMIN: if you can open it, sure, you're not root, but you can
> intercept network traffic, modify cgroup behavior, and do plenty of
> other things, any of which can probably be used to completely take
> over the system.

Well, yes. sys_bpf() is pretty powerful.=20

The goal of /dev/bpf is to enable special users to call sys_bpf(). In=20
the meanwhile, such users should not take down the whole system easily
by accident, e.g., with rm -rf /.

It is similar to CAP_BPF_ADMIN, without really adding the CAP_. =20

I think adding new CAP_ requires much more effort.=20

>=20
> It would also be nice to understand why you can't do what you need to
> do entirely in user code using setuid or fscaps.

It is not very easy to achieve the same control: only certain users can
run certain tools (bpftool, etc.).=20

The closest approach I can find is:
  1. use libcap (pam_cap) to give CAP_SETUID to certain users;
  2. add setuid(0) to bpftool.

The difference between this approach and /dev/bpf is that certain users
would be able to run other tools that call setuid(). Though I am not=20
sure how many tools call setuid(), and how risky they are.=20

>=20
> Finally, at risk of rehashing some old arguments, I'll point out that
> the bpf() syscall is an unusual design to begin with.  As an example,
> consider bpf_prog_attach().  Outside of bpf(), if I want to change the
> behavior of a cgroup, I would write to a file in
> /sys/kernel/cgroup/unified/whatever/, and normal DAC and MAC rules
> apply.  With bpf(), however, I just call bpf() to attach a program to
> the cgroup.  bpf() says "oh, you are capable(CAP_NET_ADMIN) -- go for
> it!".  Unless I missed something major, and I just re-read the code,
> there is no check that the caller has write or LSM permission to
> anything at all in cgroupfs, and the existing API would make it very
> awkward to impose any kind of DAC rules here.
>=20
> So I think it might actually be time to repay some techincal debt and
> come up with a real fix.  As a less intrusive approach, you could see
> about requiring ownership of the cgroup directory instead of
> CAP_NET_ADMIN.  As a more intrusive but perhaps better approach, you
> could invert the logic to to make it work like everything outside of
> cgroup: add pseudo-files like bpf.inet_ingress to the cgroup
> directories, and require a writable fd to *that* to a new improved
> attach API.  If a user could do:
>=20
> int fd =3D open("/sys/fs/cgroup/.../bpf.inet_attach", O_RDWR);  /* usual
> DAC and MAC policy applies */
> int bpf_fd =3D setup the bpf stuff;  /* no privilege required, unless
> the program is huge or needs is_priv */
> bpf(BPF_IMPROVED_ATTACH, target =3D fd, program =3D bpf_fd);
>=20
> there would be no capabilities or global privilege at all required for
> this.  It would just work with cgroup delegation, containers, etc.
>=20
> I think you could even pull off this type of API change with only
> libbpf changes.  In particular, there's this code:
>=20
> int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type=
,
>                    unsigned int flags)
> {
>        union bpf_attr attr;
>=20
>        memset(&attr, 0, sizeof(attr));
>        attr.target_fd     =3D target_fd;
>        attr.attach_bpf_fd =3D prog_fd;
>        attr.attach_type   =3D type;
>        attr.attach_flags  =3D flags;
>=20
>        return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
> }
>=20
> This would instead do something like:
>=20
> int specific_target_fd =3D openat(target_fd, bpf_type_to_target[type], O_=
RDWR);
> attr.target_fd =3D specific_target_fd;
> ...
>=20
> return sys_bpf(BPF_PROG_IMPROVED_ATTACH, &attr, sizeof(attr));
>=20
> Would this solve your problem without needing /dev/bpf at all?

This gives fine grain access control. I think it solves the problem.=20
But it also requires a lot of rework to sys_bpf(). And it may also=20
break backward/forward compatibility?

Personally, I think it is an overkill for the original motivation:=20
call sys_bpf() with special user instead of root.=20

Alexei, Daniel: what do you think about this?=20

Thanks,
Song=
