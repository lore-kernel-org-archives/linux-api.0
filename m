From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Mon, 9 Sep 2019 08:49:32 -0700
Message-ID: <D3D3F165-F562-4090-831D-D8E39F9C5246@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net> <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr> <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org> <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr> <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org> <D1212E06-773B-42B9-B7C3-C4C1C2A6111D@amacapital.net> <9e43ca3f-04c0-adba-1ab4-bbc8ed487934@ssi.gouv.fr>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9e43ca3f-04c0-adba-1ab4-bbc8ed487934@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>
Cc: Jeff Layton <jlayton@kernel.org>, Florian Weimer <fweimer@redhat.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?utf-8?Q?Philippe_Tr=C3=A9buchet?=
List-Id: linux-api@vger.kernel.org


> On Sep 9, 2019, at 2:18 AM, Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.g=
ouv.fr> wrote:
>=20
>=20
>> On 06/09/2019 20:41, Andy Lutomirski wrote:
>>=20
>>=20
>>>> On Sep 6, 2019, at 11:38 AM, Jeff Layton <jlayton@kernel.org> wrote:
>>>>=20
>>>>> On Fri, 2019-09-06 at 19:14 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>>> On 06/09/2019 18:48, Jeff Layton wrote:
>>>>>>> On Fri, 2019-09-06 at 18:06 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>>>> On 06/09/2019 17:56, Florian Weimer wrote:
>>>>>>> Let's assume I want to add support for this to the glibc dynamic loa=
der,
>>>>>>> while still being able to run on older kernels.
>>>>>>>=20
>>>>>>> Is it safe to try the open call first, with O_MAYEXEC, and if that f=
ails
>>>>>>> with EINVAL, try again without O_MAYEXEC?
>>>>>>=20
>>>>>> The kernel ignore unknown open(2) flags, so yes, it is safe even for
>>>>>> older kernel to use O_MAYEXEC.
>>>>>>=20
>>>>>=20
>>>>> Well...maybe. What about existing programs that are sending down bogus=

>>>>> open flags? Once you turn this on, they may break...or provide a way t=
o
>>>>> circumvent the protections this gives.
>>>>=20
>>>> Well, I don't think we should nor could care about bogus programs that
>>>> do not conform to the Linux ABI.
>>>>=20
>>>=20
>>> But they do conform. The ABI is just undefined here. Unknown flags are
>>> ignored so we never really know if $random_program may be setting them.
>>>=20
>>>>> Maybe this should be a new flag that is only usable in the new openat2=
()
>>>>> syscall that's still under discussion? That syscall will enforce that
>>>>> all flags are recognized. You presumably wouldn't need the sysctl if y=
ou
>>>>> went that route too.
>>>>=20
>>>> Here is a thread about a new syscall:
>>>> https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
>>>>=20
>>>> I don't think it fit well with auditing nor integrity. Moreover using
>>>> the current open(2) behavior of ignoring unknown flags fit well with th=
e
>>>> usage of O_MAYEXEC (because it is only a hint to the kernel about the
>>>> use of the *opened* file).
>>>>=20
>>>=20
>>> The fact that open and openat didn't vet unknown flags is really a bug.
>>>=20
>>> Too late to fix it now, of course, and as Aleksa points out, we've
>>> worked around that in the past. Now though, we have a new openat2
>>> syscall on the horizon. There's little need to continue these sorts of
>>> hacks.
>>>=20
>>> New open flags really have no place in the old syscalls, IMO.
>>>=20
>>>>> Anyone that wants to use this will have to recompile anyway. If the
>>>>> kernel doesn't support openat2 or if the flag is rejected then you kno=
w
>>>>> that you have no O_MAYEXEC support and can decide what to do.
>>>>=20
>>>> If we want to enforce a security policy, we need to either be the syste=
m
>>>> administrator or the distro developer. If a distro ship interpreters
>>>> using this flag, we don't need to recompile anything, but we need to be=

>>>> able to control the enforcement according to the mount point
>>>> configuration (or an advanced MAC, or an IMA config). I don't see why a=
n
>>>> userspace process should check if this flag is supported or not, it
>>>> should simply use it, and the sysadmin will enable an enforcement if it=

>>>> makes sense for the whole system.
>>>>=20
>>>=20
>>> A userland program may need to do other risk mitigation if it sets
>>> O_MAYEXEC and the kernel doesn't recognize it.
>>>=20
>>> Personally, here's what I'd suggest:
>>>=20
>>> - Base this on top of the openat2 set
>>> - Change it that so that openat2() files are non-executable by default. A=
nyone wanting to do that needs to set O_MAYEXEC or upgrade the fd somehow.
>>> - Only have the openat2 syscall pay attention to O_MAYEXEC. Let open and=
 openat continue ignoring the new flag.
>>>=20
>>> That works around a whole pile of potential ABI headaches. Note that
>>> we'd need to make that decision before the openat2 patches are merged.
>>>=20
>>> Even better would be to declare the new flag in some openat2-only flag
>>> space, so there's no confusion about it being supported by legacy open
>>> calls.
>>>=20
>>> If glibc wants to implement an open -> openat2 wrapper in userland
>>> later, it can set that flag in the wrapper implicitly to emulate the old=

>>> behavior.
>>>=20
>>> Given that you're going to have to recompile software to take advantage
>>> of this anyway, what's the benefit to changing legacy syscalls?
>>>=20
>>>>>>> Or do I risk disabling this security feature if I do that?
>>>>>>=20
>>>>>> It is only a security feature if the kernel support it, otherwise it i=
s
>>>>>> a no-op.
>>>>>>=20
>>>>>=20
>>>>> With a security feature, I think we really want userland to aware of
>>>>> whether it works.
>>>>=20
>>>> If userland would like to enforce something, it can already do it
>>>> without any kernel modification. The goal of the O_MAYEXEC flag is to
>>>> enable the kernel, hence sysadmins or system designers, to enforce a
>>>> global security policy that makes sense.
>>>>=20
>>>=20
>>> I don't see how this helps anything if you can't tell whether the kernel=

>>> recognizes the damned thing. Also, our track record with global sysctl
>>> switches like this is pretty poor. They're an administrative headache as=

>>> well as a potential attack vector.
>>=20
>> I tend to agree. The sysctl seems like it=E2=80=99s asking for trouble. I=
 can see an ld.so.conf option to turn this thing off making sense.
>=20
> The sysctl is required to enable the adoption of this flag without
> breaking existing systems. Current systems may have "noexec" on mount
> points containing scripts. Without giving the ability to the sysadmin to
> control that behavior, updating to a newer version of an interpreter
> using O_MAYEXEC may break such systems.
>=20
> How would you do this with ld.so.conf ?
>=20

By telling user code not to use O_MAYEXEC?

Alternatively, you could allow O_MAYEXEC even on a noexec mount and have a s=
trong_noexec option that blocks it.=
