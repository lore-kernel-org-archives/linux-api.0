From: Ian Lance Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 12:50:36 -0700
Message-ID: <CAKOQZ8z9r4Kw=0MNn29CMzD0-ZF=yCL2QfQp-oh==5MUcMQmuA@mail.gmail.com>
References: <cover.1402769596.git.luto@amacapital.net>
	<21405.44257.742122.786960@gargle.gargle.HOWL>
	<20140615143500.GP179@brightrain.aerifal.cx>
	<539DD26B.3060709@zytor.com>
	<CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
	<539DDE9C.3010903@zytor.com>
	<CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
	<4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com>
	<CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com>
	<90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com>
	<CAKOQZ8zD7kyEmujCtTA8pm=wrM6vDJ5Yspfn1AkSydffhBus2g@mail.gmail.com>
	<9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 12:31 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> The weak symbols are well-known names.  The __vdso symbols are strong.

I see.  But I don't understand how this is supposed to work.  When I
link a program against gettimeofday, I get a reference to gettimeofday
with version GLIBC_2.2.5.  After all, I only link against libc.so; I
don't link against the vDSO.  The VDSO provides gettimeofday with
version LINUX_2.6.  Since those versions don't match, the gettimeofday
reference in my executable will not be satisfied by the definition in
the vDSO.  So at dynamic link time my program is always going to be
linked with the gettimeofday in libc.so, which will in turn call the
gettimeofday in the vDSO.

Am I missing something that makes the definition of gettimeofday with
version LINUX_2.6 in the vDSO useful?

Ian



> On June 15, 2014 12:22:17 PM PDT, Ian Lance Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org> wrote:
>>On Sun, Jun 15, 2014 at 12:14 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> If it doesn't, then you incur an additional indirection penalty.  The
>>strong __vdso symbol allows the libc wrapper to fall back to the vdso
>>implementation, the weak symbol allows three to be no wrapper at all.
>>This is good.
>>>
>>> The reason for changing ABI would be shifting types.  This is very
>>much how glibc manages transitions.
>>
>>The purpose of symbol versioning is so that symbols with well known
>>names, like stat, can continue to use those same names while changing
>>types.  Both old and new programs can continue to use the name stat
>>and continue to work even though they use different types.
>>
>>I don't see how this applies to the kernel VDSO.  Those symbols do not
>>use well-known names; they use names like __vdso_time.  If you change
>>the types used by those symbols, you can change the name as well.
>>What is the downside?
>>
>>Ian
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.
