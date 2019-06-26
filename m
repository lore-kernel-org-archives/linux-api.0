From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Detecting the availability of VSYSCALL
Date: Wed, 26 Jun 2019 17:36:03 +0200
Message-ID: <87a7e4jr4s.fsf@oldenburg2.str.redhat.com>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
	<alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
	<87lfxpy614.fsf@oldenburg2.str.redhat.com>
	<CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
	<87a7e5v1d9.fsf@oldenburg2.str.redhat.com>
	<CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
	<87o92kmtp5.fsf@oldenburg2.str.redhat.com>
	<CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net>
	<87r27gjss3.fsf@oldenburg2.str.redhat.com>
	<534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16261-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net> (Andy
	Lutomirski's message of "Wed, 26 Jun 2019 08:21:05 -0700")
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> I=E2=80=99m wondering if we can still do it: add a note or other ELF indi=
cator
> that says =E2=80=9CI don=E2=80=99t need vsyscalls.=E2=80=9D  Then we can =
change the default
> mode to =E2=80=9Cno vsyscalls if the flag is there, else execute-only
> vsyscalls=E2=80=9D.
>
> Would glibc go along with this?

I think we can make it happen, at least for relatively recent glibc
linked with current binutils.  It's not trivial because it requires
coordination among multiple projects.  We have three or four widely used
link editors now, but we could make it happen.  (Although getting to
PT_GNU_PROPERTY wasn't exactly easy.)

> Would enterprise distros consider backporting such a thing?

Enterprise distros aren't the problem here because they can't remove
vsyscall support for quite a while due to existing customer binaries.
For them, it would just be an additional (and welcome) hardening
opportunity.

The challenge here are container hosting platforms which have already
disabled vsyscall, presumably to protect the container host itself.
They would need to rebuild the container host userspace with the markup
to keep it protected, and then they could switch to a kernel which has
vsyscall-unless-opt-out logic.  That seems to be a bit of a stretch
because from their perspective, there's no problem today.

My guess is that it would be easier to have a personality flag.  Then
they could keep the host largely as-is, and would =E2=80=9Conly=E2=80=9D ne=
ed a
mechanism to pass through the flag from the image metadata to the actual
container creation.  It's still a change to the container host (and the
kernel change is required as well), but it would not require relinking
every statically linked binary.

Thanks,
Florian
