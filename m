From: Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 11:58:26 -0700
Message-ID: <CAEdQ38ESK4mz6T4=fO_1Zyg-jJfhR3A+jg2Nw0rMKq-p_1U0UA@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic> <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic> <20190305181808.GH8256@zn.tnic>
 <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
 <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com> <yw1xa7i14btw.fsf@mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yw1xa7i14btw.fsf@mansr.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 9:26 AM M=C3=A5ns Rullg=C3=A5rd <mans@mansr.com> wr=
ote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> > On Sun, Mar 10, 2019 at 2:37 PM Matt Turner <mattst88@gmail.com> wrote:
> >>
> >> I'm not aware of a reason to keep a.out support on alpha.
> >
> > Hmm. I was looking at removing a.out support entirely, but it's
> > actually fairly incestuous on alpha.
> >
> > For example, arch/alpha/boot/tools/objstrip.c very much has some a.out
> > support in it. Maybe it can just be removed entirely.
> >
> > There's also an a.out.h include in arch/alpha/kernel/binfmt_loader.c.
> >
> > Finally, note that CONFIG_OSF4_COMPAT also no longer makes sense
> > without a.out support.
>
> Anyone running an Alpha machine likely also has some old OSF/1 binaries
> they may wish to use.  It would be a shame to remove this feature, IMO.

Tru64 5.1 uses ECOFF binaries, I believe. Do you know when OSF/1 /
Digital UNIX / Tru64 switched from a.out to ECOFF?
