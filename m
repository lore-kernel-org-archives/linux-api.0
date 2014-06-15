From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 10:40:03 -0700
Message-ID: <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539DD26B.3060709-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 10:05 AM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 06/15/2014 07:35 AM, Rich Felker wrote:
>>
>> Arguably, it was a mistake for the kernel to expose a virtual ELF to
>> begin with, and it should just have exposed a "lookup function by
>> name" operation to begin with. Yes this can be done in userspace, but
>> I see it more as a matter of "fixing a broken API design".
>>
>
> What the fsck are you smoking?  There is immense value in providing a
> stable and very well-defined data structure, which also happens to be
> what dynamic linkers already want to consume.  Providing a helper for
> crippled libc applications has potential value.  Shaving a few hundred
> bytes off static applications is a very weak argument, simply because it
> is such a small fraction of the enormous cost of a static application,
> and static applications are problematic in a number of other ways,
> especially the lack of ability to fix bugs.
>
> Treating the kernel as an ersatz dynamic library for "static"
> applications is kind of silly -- after all, why not provide an entire
> libc in the vdso?  I have actually seen people advocate for doing that.

To be clear, I have no desire whatsoever to give the vdso an actual
ELF parser or anything else that userspace should be providing itself.
I think that a special-purpose vdso parser in the vdso makes some
sense, though, since userspace might otherwise provide one for the
sole purpose of parsing the vdso.

And there's plenty of reasons that having the vdso be an ELF image is
useful.  For one thing, gdb can take advantage of it.  For another,
CRIU is parsing it for a rather different reason, and something like
__vdso_findsym won't fill that need.

Also, given the general lack of a comprehensible specification of what
the GNU flavor of the ELF format actually is [1], there's something to
be said for reducing the proliferation of ELF parsers.  glibc and
binutils are quite unlikely to become incompatible with each other,
but I sincerely doubt that anyone from binutils land is likely to
review (and maintain!) my ELF parser, Go's, or a hypothetical future
ELF parser from any of the other glibc-less things.  If those things
use one that's in the kernel, then it's easy for the kernel to
guarantee that each vdso image can successfully parse itself.

[1] The only comprehensible description of the GNU hash extension that
I could find is on Oracle's blog (!)

--Andy
