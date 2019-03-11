From: Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 15:11:55 -0700
Message-ID: <CAEdQ38HSKy+muCwAk9w0yNCt649HVja1Pe+yY23-4zBjDvWFRA@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic> <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic> <20190305181808.GH8256@zn.tnic>
 <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
 <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
 <yw1xa7i14btw.fsf@mansr.com> <CAHk-=whD1SumZUBQeuMT-GcciwPxg_jW_TsPAmokYp3sGGCGhA@mail.gmail.com>
 <yw1x5zsp473a.fsf@mansr.com> <CAHk-=wiU7xacTqDfm-x29-meyJWNd_X95K0T8FQMcDgy-yo3Qw@mail.gmail.com>
 <yw1x1s3d42ia.fsf@mansr.com> <CAK8P3a031d9mSOxVmCAGcrbdaCE8N3R4e2Smtxp-Z+cautTAvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a031d9mSOxVmCAGcrbdaCE8N3R4e2Smtxp-Z+cautTAvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 2:34 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Mar 11, 2019 at 8:47 PM M=C3=A5ns Rullg=C3=A5rd <mans@mansr.com> =
wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > > On Mon, Mar 11, 2019 at 11:08 AM M=C3=A5ns Rullg=C3=A5rd <mans@mansr.=
com> wrote:
> > >>
> > >> The latest version I have is 5.1, and that uses ECOFF.
> > >
> > > ECOFF _is_ a.out as far as Linux is concerned.
> > >
> > > So Linux basically treats ECOFF as "regular a.out with just some
> > > header extensions".
> > >
> > > We don't have any specific support for ECOFF.
> > >
> > > I _think_. Again, it's been years and years.
> >
> > Right, which is why killing a.out entirely would have the unfortunate
> > effect of also removing the OSF/1 compatibility on Alpha.
> >
> > If we are to support Alpha as an architecture at all, it makes sense to
> > support the things people actually use it for.
> >
> > Now, personally I can live without it.  I just don't like to see
> > features removed without due consideration.
>
> The main historic use case I've heard of was running Netscape
> Navigator on Alpha Linux, before there was an open source version.
> Doing this today to connect to the open internet is probably
> a bit pointless, but there may be other use cases.

The best use case I know of is to run their C compiler. M=C3=A5ns sent
patches in fact to make it work.

There is a Linux version of the same compiler but I have a vague
memory that it's broken in various ways that the Tru64 version is not.
