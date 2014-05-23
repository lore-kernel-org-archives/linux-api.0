From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Pondering per-process vsyscall disablement
Date: Fri, 23 May 2014 09:40:44 -0700
Message-ID: <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
 <537EB60E.40204@1h.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537EB60E.40204-108MBtLGafw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marian Marinov <mm-108MBtLGafw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 22, 2014 at 7:44 PM, Marian Marinov <mm-108MBtLGafw@public.gmane.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/23/2014 02:04 AM, Andy Lutomirski wrote:
>> It would be nice to have a way for new programs to declare that they don't need vsyscalls.  What's the right way to
>> do this?  An ELF header entry in the loader?  An ELF header entry in the program?  A new arch_prctl?
>>
>> As background, there's an old part of the x86_64 ABI that allows programs to do gettimeofday, clock_gettime, and
>> getcpu by calling to fixed addresses of the form 0xffffffffff600n00 where n indicates which of those three syscalls
>> is being invoked.  This is a security issue.
>>
>> Since Linux 3.1, vsyscalls are emulated using NX and page faults.  As a result, vsyscalls no longer offer any
>> performance advantage over normal syscalls; in fact, they're much slower.  As far as I know, nothing newer than
>> 2012 will attempt to use vsyscalls if a vdso is present.  (Sadly, a lot of things will still fall back to the
>> vsyscall page if there is no vdso, but that shouldn't matter, since there is always a vdso.)
>>
>> Despite the emulation, they could still be used as a weird form of ROP gadget that lives at a fixed address.  I'd
>> like to offer a way for new runtimes to indicate that they don't use vsyscalls so that the kernel can selectively
>> disable emulation and remove the fixed-address executable code issue.
>>
>>
> Wouldn't it be more useful if the check is against a bitmask added as extended attribute for that executable?
> This way the administrators and will have the flexibility to simply add the new attribute to the executable.

I don't think this should be something configured by the
administrator, unless the administrator is the builder of a kiosky
thing like Chromium OS.  In that case, the administrator can use
vsyscall=none.

I think this should be handled by either libc or the toolchain, hence
the suggestions of a syscall or an ELF header.

--Andy
