From: Andy Lutomirski <luto@kernel.org>
Subject: Re: a.out coredumping: fix or delete?
Date: Wed, 6 Mar 2019 09:45:13 -0800
Message-ID: <CALCETrW=ht70o8xt4+KyudScr4-h+mxZ_PnYHn46gpAzfskE4Q@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <alpine.DEB.2.21.1903061323030.1646@nanos.tec.linutronix.de>
 <20190306141144.GD7930@mit.edu> <20190306165230.75b7d110@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306165230.75b7d110@alans-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <willy@infradead.org>, Borislav Petkov <bp@alien8.de>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, kernel list <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 6, 2019 at 8:53 AM Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>
> On Wed, 6 Mar 2019 09:11:44 -0500
> "Theodore Y. Ts'o" <tytso@mit.edu> wrote:
>
> > On Wed, Mar 06, 2019 at 01:25:17PM +0100, Thomas Gleixner wrote:
> > > > It's been 25 years since Linux added support for ELF.  Can we just
> > > > delete the a.out support entirely now?  According to the Linux-ELF HOWTO,
> > > > support was added in 1.1.52 (August 1994).  It's pretty much necromancy
> > > > at this point.
> > >
> > > The Kernel-Necrophilia cult members might disagree. :)
> > >
> > > But yes, good riddance.
> >
> > Doesn't Minix 1.0 use a.out?  It *is* cool to be able to binaries from
> > run dead operating systems.  :-)
>
> Minixemu compiled fine ELF last time I checked 8). It does need  a 32bit
> system as it still uses virtual 86 model.
>

While I consider vm86() to be a giant turd, I also consider it to be
supported and even wrote it a somewhat decent test suite :)
