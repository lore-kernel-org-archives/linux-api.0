From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Tue, 12 Mar 2019 19:38:24 +1300
Message-ID: <20190312063824.wx7vow22cc35co77@tower>
References: <20190305181808.GH8256@zn.tnic>
 <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
 <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
 <yw1xa7i14btw.fsf@mansr.com>
 <CAHk-=whD1SumZUBQeuMT-GcciwPxg_jW_TsPAmokYp3sGGCGhA@mail.gmail.com>
 <yw1x5zsp473a.fsf@mansr.com>
 <CAHk-=wiU7xacTqDfm-x29-meyJWNd_X95K0T8FQMcDgy-yo3Qw@mail.gmail.com>
 <yw1x1s3d42ia.fsf@mansr.com>
 <CAK8P3a031d9mSOxVmCAGcrbdaCE8N3R4e2Smtxp-Z+cautTAvg@mail.gmail.com>
 <CAEdQ38HSKy+muCwAk9w0yNCt649HVja1Pe+yY23-4zBjDvWFRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEdQ38HSKy+muCwAk9w0yNCt649HVja1Pe+yY23-4zBjDvWFRA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Turner <mattst88@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 03:11:55PM -0700, Matt Turner wrote:
> On Mon, Mar 11, 2019 at 2:34 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Mon, Mar 11, 2019 at 8:47 PM Måns Rullgård <mans@mansr.com> wrote:
> > > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > > > On Mon, Mar 11, 2019 at 11:08 AM Måns Rullgård <mans@mansr.com> wrote:
> > > > We don't have any specific support for ECOFF.
> > > >
> > > > I _think_. Again, it's been years and years.

I agree. I personally have never run any OSF/1 executables on
Linux Alpha and have no interest in doing so.

> > The main historic use case I've heard of was running Netscape
> > Navigator on Alpha Linux, before there was an open source version.
> > Doing this today to connect to the open internet is probably
> > a bit pointless, but there may be other use cases.
> 
> The best use case I know of is to run their C compiler. Måns sent
> patches in fact to make it work.
> 
> There is a Linux version of the same compiler but I have a vague
> memory that it's broken in various ways that the Tru64 version is
> not.

The last time I tried the Compaq C compiler for Alpha-Linux it still
worked, well, that is, the compiler worked, but the library header
files are broken and haven't worked with glibc for a long time.  So
it is only useful as a free-standing compiler.

In the past it also produced better code than gcc, but gcc is now
so vastly improved w.r.t. optimisation and compliance to more recent
standards, that I would be surprised if there is any real use for
the Compaq compiler.

Cheers,
Michael.
