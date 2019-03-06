From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: a.out coredumping: fix or delete?
Date: Wed, 6 Mar 2019 13:25:17 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1903061323030.1646@nanos.tec.linutronix.de>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com> <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305122218.GD13380@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 5 Mar 2019, Matthew Wilcox wrote:
> On Tue, Mar 05, 2019 at 10:19:04AM +0100, Borislav Petkov wrote:
> > On Sat, Mar 02, 2019 at 12:57:30AM +0100, Jann Horn wrote:
> > > In theory, Linux can dump cores for a.out binaries. In practice, that
> > > code is pretty bitrotten and buggy. Does anyone want that code so much
> > > that they'd like to fix it, or can we just delete it?
> > 
> > I was asking myself the same question while doing
> > 
> >   10970e1b4be9 ("x86/a.out: Clear the dump structure initially")
> > 
> > especially since it is kinda hard to get the toolchain to even create an
> > a.out executable - your script to create one case-in-point.
> 
> It's been 25 years since Linux added support for ELF.  Can we just
> delete the a.out support entirely now?  According to the Linux-ELF HOWTO,
> support was added in 1.1.52 (August 1994).  It's pretty much necromancy
> at this point.

The Kernel-Necrophilia cult members might disagree. :)

But yes, good riddance.

Thanks,

	tglx
