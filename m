From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Mon, 16 Jun 2014 16:38:01 +0200
Message-ID: <20140616143801.GJ5714@two.firstfloor.org>
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
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> I think this issue started when some of the Go developers questioned
> why the kernel needed to provide a very complex interface--parsing an
> ELF shared shared library--for very simple functionality--looking up
> the address of a magic function.  This approach has required special
> support not just in Go, but also in the dynamic linker and gdb, and
> does not work well for statically linked binaries.  The support in gdb
> is perhaps a good idea, but elsewhere it does not make sense.
> 
> So why not provide a simple interface?

What good would it do now that everyone already supports it?

The proposal is 10+ years too late.

-andi
