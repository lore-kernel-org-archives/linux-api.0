From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 10:05:47 -0700
Message-ID: <539DD26B.3060709@zytor.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140615143500.GP179-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/15/2014 07:35 AM, Rich Felker wrote:
> 
> Arguably, it was a mistake for the kernel to expose a virtual ELF to
> begin with, and it should just have exposed a "lookup function by
> name" operation to begin with. Yes this can be done in userspace, but
> I see it more as a matter of "fixing a broken API design".
> 

What the fsck are you smoking?  There is immense value in providing a
stable and very well-defined data structure, which also happens to be
what dynamic linkers already want to consume.  Providing a helper for
crippled libc applications has potential value.  Shaving a few hundred
bytes off static applications is a very weak argument, simply because it
is such a small fraction of the enormous cost of a static application,
and static applications are problematic in a number of other ways,
especially the lack of ability to fix bugs.

Treating the kernel as an ersatz dynamic library for "static"
applications is kind of silly -- after all, why not provide an entire
libc in the vdso?  I have actually seen people advocate for doing that.

	-hpa
