From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Pondering per-process vsyscall disablement
Date: Wed, 28 May 2014 14:45:18 -0700
Message-ID: <538658EE.8030809@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com> <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Marian Marinov <mm-108MBtLGafw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/23/2014 09:40 AM, Andy Lutomirski wrote:
> 
> I don't think this should be something configured by the
> administrator, unless the administrator is the builder of a kiosky
> thing like Chromium OS.  In that case, the administrator can use
> vsyscall=none.
> 
> I think this should be handled by either libc or the toolchain, hence
> the suggestions of a syscall or an ELF header.
> 

We could mimic the NX stack stuff, but it would have a lot of false
negatives, simply because very few things would actually poke at the
vsyscall page.

The NX stuff uses a dummy program header in the ELF image.

On the other hand, you could make the argument that anything compiled
with a new toolchain simply should not use the vsyscall page, and just
unconditionally set the opt-out bit (header) in question.

It might be better to have some kind of flags field (which a number of
architectures use) than keep using dummy program headers, though.

	-hpa
