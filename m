From: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Mon, 16 Jun 2014 02:39:08 -0400
Message-ID: <20140616063907.GX179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
 <f420daee-9a06-414b-911f-5db7b7b37abe@email.android.com>
 <CALCETrXxG3_wxRAPF9CNk+2yv7t2Hw5Z4R-UdNKSZtU+pSe9og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXxG3_wxRAPF9CNk+2yv7t2Hw5Z4R-UdNKSZtU+pSe9og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 11:22:48AM -0700, Andy Lutomirski wrote:
> >>[1] The only comprehensible description of the GNU hash extension that
> >>I could find is on Oracle's blog (!)
> >>
> >
> > Curious about this blog.  We do have a GNU hash implementation in Syslinux, too, for another reference.
> >
> 
> https://blogs.oracle.com/ali/entry/gnu_hash_elf_sections
> 
> FWIW, I bet that __vdso_findsym could be smaller if it used the GNU
> hash.  Maybe it would save about the same amount of space that turning
> on the GNU hash would take up.

How so? My implementation of gnu hash lookup in musl's dynamic linker
is somewhat larger than the sysv hash lookup, and that's even with
skipping the bloom filter (which did not seem to yield any benefit,
though we may revisit this issue later). The actual hash function is
_slightly_ smaller for gnu, but the lookup function has a lot more
work to do.

Of course for the size of vdso's symbol table, a pure linear search
with no hash table would suffice...

Rich
