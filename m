From: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 21:06:07 -0400
Message-ID: <20140616010606.GS179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx>
 <539DD26B.3060709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <539DD26B.3060709-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 10:05:47AM -0700, H. Peter Anvin wrote:
> On 06/15/2014 07:35 AM, Rich Felker wrote:
> > 
> > Arguably, it was a mistake for the kernel to expose a virtual ELF to
> > begin with, and it should just have exposed a "lookup function by
> > name" operation to begin with. Yes this can be done in userspace, but
> > I see it more as a matter of "fixing a broken API design".
> > 
> 
> What the fsck are you smoking?  There is immense value in providing a
> stable and very well-defined data structure,

I believe the widespread consensus is that there's more value in
providing a well-defined interface and keeping your data structures
opaque. Even if it's useful for the data structure to be there for the
debugger's sake (debuggers have to know about binary formats, etc.)
that's not an excuse for components of the system which have nothing
to do with ELF to have to know about it.

> which also happens to be
> what dynamic linkers already want to consume.  Providing a helper for
> crippled libc applications has potential value.  Shaving a few hundred
> bytes off static applications is a very weak argument, simply because it
> is such a small fraction of the enormous cost of a static application,

No, it's not. It could very easily be 5% of the binary size for plenty
of utilities that are useful to make static. Anyway it's not that a
single ~450 byte function is such a cost for static binaries in
itself; it's that if one is not vigilant against this kind of creep,
it ends up not being one ~450 byte function but quickly 5, 10, 20,
etc. of them, and eventually you get to the point (see: glibc) where
static linking is useless.

> and static applications are problematic in a number of other ways,
> especially the lack of ability to fix bugs.

This is a standard fallacy I won't address here because it's
off-topic.

> Treating the kernel as an ersatz dynamic library for "static"
> applications is kind of silly -- after all, why not provide an entire
> libc in the vdso?  I have actually seen people advocate for doing that.

I consider that a very bad idea. What I think vdso should provide is
just fast versions of syscalls that can be performed without entering
kernelspace, but for which it's impossible to write such an
implementation in userspace because it (a) has to interact with
kernel-provided data structures that should not be public APIs, and
(b) requires hardware-specific versions of the function. However, I
think there's a value in providing access to these syscall
replacements in an easy-to-use manner that doesn't require that
components which have nothing to do with ELF (i.e. the time functions)
be aware of ELF data structures. And this is why I support the
proposal.

Rich
