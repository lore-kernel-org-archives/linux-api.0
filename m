From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv8 02/34] lib/vdso: make do_hres and do_coarse as __always_inline
Date: Sun, 12 Jan 2020 21:27:31 -0800
Message-ID: <CANaxB-zrnHjmJ-7xeagiiZve69o_scPQXmZ+Y03omtk-1cqrhg@mail.gmail.com>
References: <20191112012724.250792-1-dima@arista.com> <20191112012724.250792-3-dima@arista.com>
 <ed2e65ae-75b0-ed79-0a95-90be6b82e6be@arm.com> <878smfa66i.fsf@nanos.tec.linutronix.de>
 <e74a63cb-5248-4473-81a7-d1b2f959ec7a@arm.com> <875zhja59q.fsf@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zhja59q.fsf@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>, Dmitry Safonov <dima@arista.com>, LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, crml <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.o>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 10, 2020 at 4:02 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Vincenzo Frascino <vincenzo.frascino@arm.com> writes:
> > On 1/10/20 11:42 AM, Thomas Gleixner wrote:
> >>>> +=C2=BB =C2=BB /*=C2=B7goto=C2=B7allows=C2=B7to=C2=B7avoid=C2=B7extr=
a=C2=B7inlining=C2=B7of=C2=B7do_hres.=C2=B7*/
> >>>> +=C2=BB =C2=BB goto=C2=B7out_hres;
> >>>
> >>> What is the performance impact of "goto out_hres"?
> >>
> >> On x86 it's invisible at least in my limited testing.
> >
> > On arm64 as well based on mine as well. Shall we keep the code more rea=
dable
> > here (without goto)?
>
> The delta patch below makes it readable again and also avoids the double
> inlining. Quick testing shows no difference.

My tests show no difference too and the code looks more readable. Thanks!

>
> Thanks,
>
>         tglx
