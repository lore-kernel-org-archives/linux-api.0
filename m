From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Pondering per-process vsyscall disablement
Date: Fri, 30 May 2014 13:20:36 -0700
Message-ID: <5388E814.1080504@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com> <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com> <538658EE.8030809@zytor.com> <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com> <5388E499.6080101@zytor.com> <CALCETrX9s7xJRddB26ZiyjMEGbupbDj2qDHhio=80XSQ+staDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX9s7xJRddB26ZiyjMEGbupbDj2qDHhio=80XSQ+staDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Marian Marinov <mm-108MBtLGafw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/30/2014 01:11 PM, Andy Lutomirski wrote:
> On Fri, May 30, 2014 at 1:05 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> On 05/30/2014 01:00 PM, Andy Lutomirski wrote:
>>>
>>> Do the flags go in the ELF loader or in the executable we're running?
>>> Or both (and, if both, do we and them or or them)?
>>>
>>> I think the interpreter makes a little more sense in general: for the
>>> most part, use of vsyscalls is a property of the runtime environment,
>>> not of the program being run.  But maybe this is naive.
>>>
>>
>> They go into each object which becomes part of the running program, i.e.
>> executable, dynamic libraries, and dynamic linker.
> 
> Well, sure, but the kernel is not about to start reading ELF headers
> in dynamic libraries.  So we need to make a decision based on the
> interpreter and the executable.  The conservative approach is to
> require both to have the flag set *and* to offer a prctl to twiddle
> the flags.  Then userspace loaders can do whatever they want, and
> distros get to rebuild the world :)
> 

Yes, something like that.

	-hpa
