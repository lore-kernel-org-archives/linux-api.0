From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Fri, 2 Aug 2019 07:21:33 +0000
Message-ID: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
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
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
Content-Language: en-US
Content-ID: <4D40F33B94638543A6BA3E1D1275382F@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,

> On Jul 31, 2019, at 12:09 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Wed, Jul 31, 2019 at 1:10 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 1:24 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>> Hi Andy,
>>>>=20
>>>>> On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
>>>>>=20
>>>>> Hi Andy,
>>>>>=20
>>>>>=20
>>=20
>> [...]
>>=20
>>>>>=20
>>>>=20
>>>> I would like more comments on this.
>>>>=20
>>>> Currently, bpf permission is more or less "root or nothing", which we
>>>> would like to change.
>>>>=20
>>>> The short term goal is to separate bpf from root, in other words, it i=
s
>>>> "all or nothing". Special user space utilities, such as systemd, would
>>>> benefit from this. Once this is implemented, systemd can call sys_bpf(=
)
>>>> when it is not running as root.
>>>=20
>>> As generally nasty as Linux capabilities are, this sounds like a good
>>> use for CAP_BPF_ADMIN.
>>=20
>> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
>> existing tools (setcap, getcap, etc.) and libraries aware of the new CAP=
.
>=20
> It's been done before -- it's not that hard.  IMO the main tricky bit
> would be try be somewhat careful about defining exactly what
> CAP_BPF_ADMIN does.

Agreed. I think defining CAP_BPF_ADMIN could be a good topic for the=20
Plumbers conference.=20

OTOH, I don't think we have to wait for CAP_BPF_ADMIN to allow daemons=20
like systemd to do sys_bpf() without root.=20

>=20
>>> I don't see why you need to invent a whole new mechanism for this.
>>> The entire cgroup ecosystem outside bpf() does just fine using the
>>> write permission on files in cgroupfs to control access.  Why can't
>>> bpf() do the same thing?
>>=20
>> It is easier to use write permission for BPF_PROG_ATTACH. But it is
>> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
>> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
>> we should have target concept for all these commands. But that is a
>> much bigger project. OTOH, "all or nothing" model allows all these
>> commands at once.
>=20
> For BPF_PROG_LOAD, I admit I've never understood why permission is
> required at all.  I think that CAP_SYS_ADMIN or similar should be
> needed to get is_priv in the verifier, but I think that should mainly
> be useful for tracing, and that requires lots of privilege anyway.
> BPF_MAP_* is probably the trickiest part.  One solution would be some
> kind of bpffs, but I'm sure other solutions are possible.

Improving permission management of cgroup_bpf is another good topic to
discuss. However, it is also an overkill for current use case.=20

Let me get more details about the use case, so that we have a clear=20
picture about short term and long term goals.=20

Thanks again for your suggestions.=20
Song
