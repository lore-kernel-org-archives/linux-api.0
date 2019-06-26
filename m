From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Detecting the availability of VSYSCALL
Date: Wed, 26 Jun 2019 08:21:05 -0700
Message-ID: <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de> <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com> <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com> <87o92kmtp5.fsf@oldenburg2.str.redhat.com> <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net> <87r27gjss3.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16260-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <87r27gjss3.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org



> On Jun 26, 2019, at 8:00 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> * Andy Lutomirski:
>=20
>> I didn=E2=80=99t add a flag because the vsyscall page was thoroughly obso=
lete
>> when all this happened, and I wanted to encourage all new code to just
>> parse the vDSO instead of piling on the hacks.
>=20
> It turned out that the thorny cases just switched to system calls
> instead.  I think we finally completed the transition in glibc upstream
> in 2018 (for x86).
>=20
>> Anyway, you may be the right person to ask: is there some credible way
>> that the kernel could detect new binaries that don=E2=80=99t need vsyscal=
ls?
>> Maybe a new ELF note on a static binary or on the ELF interpreter? We
>> can dynamically switch it in principle.
>=20
> For this kind of change, markup similar to PT_GNU_STACK would have been
> appropriate, I think: Old kernels and loaders would have ignored the
> program header and loaded the program anyway, but the vsyscall page
> still existed, so that would have been fine. The kernel would have
> needed to check the program interpreter or the main executable (without
> a program interpreter, i.e., the statically linked case).  Due the way
> the vsyscalls are concentrated in glibc, a dynamically linked executable
> would not have needed checking (or re-linking).  I don't think we would
> have implemented the full late enablement after dlopen we did for
> executable stacks.  In theory, any code could have jumped to the
> vsyscall area, but in practice, it's just dynamically linked glibc and
> static binaries.
>=20
> But nowadays, unmarked glibcs which do not depend on vsyscall vastly
> outnumber unmarked glibcs which requrie it.  Therefore, markup of
> binaries does not seem to be reasonable to day.  I could imagine a
> personality flag you can set (if yoy have CAP_SYS_ADMIN) that re-enables
> vsyscall support for new subprocesses.  And a container runtime would do
> this based on metadata found in the image.  This way, the container host
> itself could be protected, and you could still run legacy images which
> require vsyscall.
>=20
> For the non-container case, if you know that you'll run legacy
> workloads, you'd still have the boot parameter.  But I think it could
> default to vsyscall=3Dnone in many more cases.
>=20

I=E2=80=99m wondering if we can still do it: add a note or other ELF indicat=
or that says =E2=80=9CI don=E2=80=99t need vsyscalls.=E2=80=9D  Then we can c=
hange the default mode to =E2=80=9Cno vsyscalls if the flag is there, else e=
xecute-only vsyscalls=E2=80=9D.

Would glibc go along with this?  Would enterprise distros consider backporti=
ng such a thing?

I=
