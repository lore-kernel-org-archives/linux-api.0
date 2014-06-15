From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 14:13:26 -0700
Message-ID: <73ed6c36-299b-4348-81e1-8a98b8baf2e5@email.android.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com> <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com> <539DDE9C.3010903@zytor.com> <CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com> <4ab91a07-c46c-485b-895d-b074d36624d6@email.android.com> <CALCETrV-ocpugRwL7rd4GDX-Y89L7So8_6BBjOUDeR4V8RSPEA@mail.gmail.com> <90c597c5-f77d-491e-b0b8-dde2027155b5@email.android.com> <CAKOQZ8zD7kyEmujCtTA8pm=wrM6vDJ5Yspfn1AkSydffhBus2g@mail.gmail.com> <9a4fb9c9-4b1c-4593-a99e-a2ef2325d55d@email.android.com> <CAKOQZ8z9r4Kw=0MNn29CMzD0-ZF=yCL2QfQp-oh==5MUcMQmuA@mail.gmail.com> <8607961d-b42a-4dba-a736-d3a8586ee42d@email.android.com> <CALCETrVoOS913rUo288c
 6PhNtrWBZa9tSA6Ec=WUw1+SAU9ALw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVoOS913rUo288c6PhNtrWBZa9tSA6Ec=WUw1+SAU9ALw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ian Lance Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Yes, but the option exists.

On June 15, 2014 1:53:17 PM PDT, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>On Sun, Jun 15, 2014 at 12:56 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> You can link against vdso.so if you want to; the kernel build
>provides an option to install that image.  Doesn't mean that any
>particular libc uses it.
>
>I'd be rather surprised if anyone does this, given the generally
>spotty state of vdso.so installation and that there's no such thing as
>an ELF import library.
>
>Also, the vdso's clock_gettime isn't actually compatible with
>glibc/POSIX -- the return value and errno handling don't match.
>
>--Andy

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
