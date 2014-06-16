From: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Mon, 16 Jun 2014 10:56:19 -0400
Message-ID: <20140616145618.GZ179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ian Lance Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 16, 2014 at 07:08:50AM -0700, Ian Lance Taylor wrote:
> On Sun, Jun 15, 2014 at 7:36 PM, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
> >
> > I haven't looked into this in detail, but my initial assumption would
> > be that it wouldn't be useful to add new vdso interfaces just for Go.
> > After all would you really want to force ever Go user to upgrade their
> > kernel just to get fast fime? So it has to work with whatever is already
> > there anyways.
> 
> Go works fine with the current interface.  There was, arguably, a bug
> in Go's old implementation in that it assumed that the vDSO would have
> a normal symbol table.  That bug has already been fixed.
> 
> I think this issue started when some of the Go developers questioned
> why the kernel needed to provide a very complex interface--parsing an
> ELF shared shared library--for very simple functionality--looking up
> the address of a magic function.  This approach has required special
> support not just in Go, but also in the dynamic linker and gdb, and
> does not work well for statically linked binaries.  The support in gdb
> is perhaps a good idea, but elsewhere it does not make sense.
> 
> So why not provide a simple interface?

This is my sentiment as well, but I think you've stated it better than
I have.

Also note that, if the vdso is providing a "lookup the address of a
magic function by name" function, it need not be a full ELF parser,
i.e. it doesn't need to be able to deal with any ELF files except the
vdso provided by the current kernel. This probably allows the parser
to be considerably smaller; for example, all the version stuff can be
omitted unless the actual kernel in use provides multiple symbol
versions.

Rich
