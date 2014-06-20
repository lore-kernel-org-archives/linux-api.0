From: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Fri, 20 Jun 2014 12:07:08 -0400
Message-ID: <20140620160708.GY179@brightrain.aerifal.cx>
References: <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <539DDE9C.3010903@zytor.com>
 <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
 <20140616023604.GI5714@two.firstfloor.org>
 <CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
 <20140616143801.GJ5714@two.firstfloor.org>
 <CAKOQZ8zk8KfkObSZg8fmhZXm9nXQSneOywvV-NBj=N-tNWjNPg@mail.gmail.com>
 <20140616154228.GB179@brightrain.aerifal.cx>
 <CALCETrWnQyCk5vhDj-yAhRdAFOtFKSU6H-E_=LBC+FbA2REhrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWnQyCk5vhDj-yAhRdAFOtFKSU6H-E_=LBC+FbA2REhrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ian Lance Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 20, 2014 at 08:55:01AM -0700, Andy Lutomirski wrote:
> On Mon, Jun 16, 2014 at 8:42 AM, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org> wrote:
> > On Mon, Jun 16, 2014 at 08:31:39AM -0700, Ian Lance Taylor wrote:
> >> On Mon, Jun 16, 2014 at 7:38 AM, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
> >> >> I think this issue started when some of the Go developers questioned
> >> >> why the kernel needed to provide a very complex interface--parsing an
> >> >> ELF shared shared library--for very simple functionality--looking up
> >> >> the address of a magic function.  This approach has required special
> >> >> support not just in Go, but also in the dynamic linker and gdb, and
> >> >> does not work well for statically linked binaries.  The support in gdb
> >> >> is perhaps a good idea, but elsewhere it does not make sense.
> >> >>
> >> >> So why not provide a simple interface?
> >> >
> >> > What good would it do now that everyone already supports it?
> >>
> >> Do statically linked binaries use the vDSO calls?
> >
> > Under glibc, I believe so (not checked). Under musl, yes, and even in
> > the dynamic-linked case we use the same code that's used for static
> > linking rather than trying to get the dynamic linker to do them
> > correctly. I still have some cruft lying around from where (in the
> > past) we tried to do it via the dynamic linker, but I'm probably going
> > to remove that and make the vdso behave as RTLD_LOCAL so that there's
> > no risk of weird symbols it exports interfering with the application
> > (applications could still make it global via an explicit dlopen). The
> > only reason for keeping it around at all in the dynamic linker is for
> > the sake of gdb.
> 
> What about backtrace_symbols, dl_addr, and the unwinder (e.g.
> siglongjmp)?  It would be nice to wean the vdso off of frame pointers
> some day.

My comments were in the context of musl, which doesn't use unwinding
internally whatsoever, but if you're asking about the usefulness of
being able to see the vdso's elf/dwarf2/etc. stuff for various
outside-of-libc purposes, then yes. My statement "for the sake of gdb"
was just a poor substitute for this concept (debugging/introspective
use in general).

Rich
