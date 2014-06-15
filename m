From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 11:20:41 -0700
Message-ID: <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com>
 <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com> <539DDE9C.3010903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <539DDE9C.3010903@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Rich Felker <dalias@libc.org>, Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>, Ian Taylor <iant@golang.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

cc: Andi Kleen, who designed the vdso

On Sun, Jun 15, 2014 at 10:57 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/15/2014 10:40 AM, Andy Lutomirski wrote:
>>
>> To be clear, I have no desire whatsoever to give the vdso an actual
>> ELF parser or anything else that userspace should be providing itself.
>> I think that a special-purpose vdso parser in the vdso makes some
>> sense, though, since userspace might otherwise provide one for the
>> sole purpose of parsing the vdso.
>>
>> And there's plenty of reasons that having the vdso be an ELF image is
>> useful.  For one thing, gdb can take advantage of it.  For another,
>> CRIU is parsing it for a rather different reason, and something like
>> __vdso_findsym won't fill that need.
>>
>> Also, given the general lack of a comprehensible specification of what
>> the GNU flavor of the ELF format actually is [1], there's something to
>> be said for reducing the proliferation of ELF parsers.  glibc and
>> binutils are quite unlikely to become incompatible with each other,
>> but I sincerely doubt that anyone from binutils land is likely to
>> review (and maintain!) my ELF parser, Go's, or a hypothetical future
>> ELF parser from any of the other glibc-less things.  If those things
>> use one that's in the kernel, then it's easy for the kernel to
>> guarantee that each vdso image can successfully parse itself.
>>
>> [1] The only comprehensible description of the GNU hash extension that
>> I could find is on Oracle's blog (!)
>>
>
> Yes, but that is why we provide the standard SysV hash.  The GNU hash is
> not too bad, but you're absolutely right the documentation stinks.
>
> Providing a simple symbol lookup is an opportunistic thing, and might be
> useful that way, and only because (as you say) the version in the vdso
> would only need to be guaranteed to parse a single data structure --
> that same vdso.
>
> On the other hand, it better work, correctly, in every version of the
> kernel, so I believe it will need to be done such that it is either
> correct by construction or gets self-tested during the build process so
> it errors out on failure.

I was thinking of adding something to selftests that would check that
__vdso_findsym can find every exported symbol, check that it can't
find the ones it shouldn't find, and call it on a bunch of garbage
strings to make sure it rejects them.


> One simple way to do correct by construction
> would be to do the "vdso entry point by index" -- a new kind of system
> call numbers, in effect, as much as it has shades of Windows DLL with
> their "ordinal numbers".

It's certainly easy.  It's a little gross, and I sort of feel bad
about having two parallel ways of referring to a vdso function -- one
used by ELF parsers and one used by the new thing.  Using an array
also wins on speed and code size.  *sigh* -- I'm torn on this one.

Do you know why the vdso uses symbol versioning and weak symbols in
the first place?  This seems to date back all the way to the beginning
(2aae950b21e4bc789d1fc6668faf67e8748300b7).  If we're going to add a
new way to find vdso symbols, I would like to at least drop support
for versions.

--Andy
