From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Detecting the availability of VSYSCALL
Date: Wed, 26 Jun 2019 09:52:15 -0700
Message-ID: <CALCETrUG9yHf4D_fDEj054Bgo4zXpmK5UzME9mKNqD70U7vy5Q@mail.gmail.com>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
 <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
 <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
 <87o92kmtp5.fsf@oldenburg2.str.redhat.com> <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net>
 <87r27gjss3.fsf@oldenburg2.str.redhat.com> <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
 <87a7e4jr4s.fsf@oldenburg2.str.redhat.com> <6CECE9DE-51AB-4A21-A257-8B85C4C94EB0@amacapital.net>
 <87sgrw1ejv.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-16265-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <87sgrw1ejv.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Carlos O'Donell <carlos@redhat.com>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 9:45 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Andy Lutomirski:
>
> > Can=E2=80=99t an ELF note be done with some more or less ordinary asm s=
uch
> > that any link editor will insert it correctly?
>
> We've just been over this for the CET enablement.  ELF PT_NOTE parsing
> was rejected there.

No one told me this.  Unless I missed something, the latest kernel
patches still had PT_NOTE parsing.  Can you point me at an
enlightening thread or explain what happened?

> > The problem with a personality flag is that it needs to have some kind
> > of sensible behavior for setuid programs, and getting that right in a
> > way that doesn=E2=80=99t scream =E2=80=9Cexploit me=E2=80=9D while pres=
erving useful
> > compatibility may be tricky.
>
> Are restrictive personality flags still a problem with user namespaces?
> I think it would be fine to restrict this one to CAP_SYS_ADMIN.

We could possibly get away with this, but now we're introducing a
whole new mechanism.  I'd rather just add proper per-namespace
sysctls, but this is a pretty big hammer.
