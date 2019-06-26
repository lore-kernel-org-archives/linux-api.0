From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Detecting the availability of VSYSCALL
Date: Wed, 26 Jun 2019 07:15:59 -0700
Message-ID: <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de> <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com> <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com> <87o92kmtp5.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16256-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <87o92kmtp5.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org



> On Jun 26, 2019, at 5:12 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> * Andy Lutomirski:
>=20
>>> On Tue, Jun 25, 2019 at 1:47 PM Florian Weimer <fweimer@redhat.com> wrot=
e:
>>>=20
>>> * Andy Lutomirski:
>>>=20
>>>>> We want binaries that run fast on VSYSCALL kernels, but can fall back t=
o
>>>>> full system calls on kernels that do not have them (instead of
>>>>> crashing).
>>>>=20
>>>> Define "VSYSCALL kernels."  On any remotely recent kernel (*all* new
>>>> kernels and all kernels for the last several years that haven't
>>>> specifically requested vsyscall=3Dnative), using vsyscalls is much, muc=
h
>>>> slower than just doing syscalls.  I know a way you can tell whether
>>>> vsyscalls are fast, but it's unreliable, and I'm disinclined to
>>>> suggest it.  There are also at least two pending patch series that
>>>> will interfere.
>>>=20
>>> The fast path is for the benefit of the 2.6.32-based kernel in Red Hat
>>> Enterprise Linux 6.  It doesn't have the vsyscall emulation code yet, I
>>> think.
>>>=20
>>> My hope is to produce (statically linked) binaries that run as fast on
>>> that kernel as they run today, but can gracefully fall back to something=

>>> else on kernels without vsyscall support.
>>>=20
>>>>> We could parse the vDSO and prefer the functions found there, but this=

>>>>> is for the statically linked case.  We currently do not have a (minima=
l)
>>>>> dynamic loader there in that version of the code base, so that doesn't=

>>>>> really work for us.
>>>>=20
>>>> Is anything preventing you from adding a vDSO parser?  I wrote one
>>>> just for this type of use:
>>>>=20
>>>> $ wc -l tools/testing/selftests/vDSO/parse_vdso.c
>>>> 269 tools/testing/selftests/vDSO/parse_vdso.c
>>>>=20
>>>> (289 lines includes quite a bit of comment.)
>>>=20
>>> I'm worried that if I use a custom parser and the binaries start
>>> crashing again because something changed in the kernel (within the scope=

>>> permitted by the ELF specification), the kernel won't be fixed.
>>>=20
>>> That is, we'd be in exactly the same situation as today.
>>=20
>> With my maintainer hat on, the kernel won't do that.  Obviously a
>> review of my parser would be appreciated, but I consider it to be
>> fully supported, just like glibc and musl's parsers are fully
>> supported.  Sadly, I *also* consider the version Go forked for a while
>> (now fixed) to be supported.  Sigh.
>=20
> We've been burnt once, otherwise we wouldn't be having this
> conversation.  It's not just what the kernel does by default; if it's
> configurable, it will be disabled by some, and if it's label as
> =E2=80=9Csecurity hardening=E2=80=9D, the userspace ABI promise is suddenl=
y forgotten
> and it's all userspace's fault for not supporting the new way.
>=20
> It looks like parsing the vDSO is the only way forward, and we have to
> move in that direction if we move at all.
>=20
> It's tempting to read the machine code on the vsyscall page and analyze
> that, but vsyscall=3Dnone behavior changed at one point, and you no longer=

> any mapping there at all.  So that doesn't work, either.

It=E2=80=99s worse than that. I have patches to make the vsyscall be execute=
-only. And the slowly forthcoming CET patches will change the machine code.

>=20
> I do hope the next userspace ABI break will have an option to undo it on
> a per-container basis.  Or at least a flag to detect it.
>=20

I didn=E2=80=99t add a flag because the vsyscall page was thoroughly obsolet=
e when all this happened, and I wanted to encourage all new code to just par=
se the vDSO instead of piling on the hacks.

Anyway, you may be the right person to ask: is there some credible way that t=
he kernel could detect new binaries that don=E2=80=99t need vsyscalls?  Mayb=
e a new ELF note on a static binary or on the ELF interpreter? We can dynami=
cally switch it in principle.=
