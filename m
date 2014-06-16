From: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 20:55:12 -0400
Message-ID: <20140616005512.GR179@brightrain.aerifal.cx>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <90c597c5-f77d-491e-b0b8-dde2027155b5-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 12:14:04PM -0700, H. Peter Anvin wrote:
> If it doesn't, then you incur an additional indirection penalty. The
> strong __vdso symbol allows the libc wrapper to fall back to the
> vdso implementation, the weak symbol allows three to be no wrapper
> at all. This is good.

No it doesn't. The weak symbol does not implement the interface
contract of the libc function; on error it's required to set errno,
and of course the kernel/vdso cannot do this. Also, there's no way the
symbol versions the kernel provides can match up with userspace symbol
versions that consumers of the function would need. So these features
are just useless.

Rich
