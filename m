From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Wed, 31 Jul 2019 08:10:16 +0000
Message-ID: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
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
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
Content-Language: en-US
Content-ID: <5E5B76352B389D4A87E904B6B19E7BF7@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Jul 30, 2019, at 1:24 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Andy,
>>=20
>>> On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
>>>=20
>>> Hi Andy,
>>>=20
>>>=20

[...]

>>>=20
>>=20
>> I would like more comments on this.
>>=20
>> Currently, bpf permission is more or less "root or nothing", which we
>> would like to change.
>>=20
>> The short term goal is to separate bpf from root, in other words, it is
>> "all or nothing". Special user space utilities, such as systemd, would
>> benefit from this. Once this is implemented, systemd can call sys_bpf()
>> when it is not running as root.
>=20
> As generally nasty as Linux capabilities are, this sounds like a good
> use for CAP_BPF_ADMIN.

I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make=20
existing tools (setcap, getcap, etc.) and libraries aware of the new CAP.

>=20
> But what do you have in mind?  Isn't non-root systemd mostly just the
> user systemd session?  That should *not* have bpf() privileges until
> bpf() is improved such that you can't use it to compromise the system.

cgroup bpf is the major use case here. A less important use case is to=20
run bpf selftests without being root.=20

>=20
>>=20
>> In longer term, it may be useful to provide finer grain permission of
>> sys_bpf(). For example, sys_bpf() should be aware of containers; and
>> user may only have access to certain bpf maps. Let's call this
>> "fine grain" capability.
>>=20
>>=20
>> Since we are seeing new use cases every year, we will need many
>> iterations to implement the fine grain permission. I think we need an
>> API that is flexible enough to cover different types of permission
>> control.
>>=20
>> For example, bpf_with_cap() can be flexible:
>>=20
>>        bpf_with_cap(cmd, attr, size, perm_fd);
>>=20
>> We can get different types of permission via different combinations of
>> arguments:
>>=20
>>    A perm_fd to /dev/bpf gives access to all sys_bpf() commands, so
>>    this is "all or nothing" permission.
>>=20
>>    A perm_fd to /sys/fs/cgroup/.../bpf.xxx would only allow some
>>    commands to this specific cgroup.
>>=20
>=20
> I don't see why you need to invent a whole new mechanism for this.
> The entire cgroup ecosystem outside bpf() does just fine using the
> write permission on files in cgroupfs to control access.  Why can't
> bpf() do the same thing?

It is easier to use write permission for BPF_PROG_ATTACH. But it is=20
not easy to do the same for other bpf commands: BPF_PROG_LOAD and=20
BPF_MAP_*. A lot of these commands don't have target concept. Maybe=20
we should have target concept for all these commands. But that is a=20
much bigger project. OTOH, "all or nothing" model allows all these=20
commands at once.

Well, that being said, I will look more into using write permission=20
in cgroupfs.=20

Thanks again for all these comments and suggestions. Please let us=20
know your future thoughts and insights.=20

Song
