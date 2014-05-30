From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Pondering per-process vsyscall disablement
Date: Fri, 30 May 2014 13:05:45 -0700
Message-ID: <5388E499.6080101@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com> <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com> <538658EE.8030809@zytor.com> <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marian Marinov <mm@1h.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 05/30/2014 01:00 PM, Andy Lutomirski wrote:
> 
> Do the flags go in the ELF loader or in the executable we're running?
> Or both (and, if both, do we and them or or them)?
> 
> I think the interpreter makes a little more sense in general: for the
> most part, use of vsyscalls is a property of the runtime environment,
> not of the program being run.  But maybe this is naive.
> 

They go into each object which becomes part of the running program, i.e.
executable, dynamic libraries, and dynamic linker.

	-hpa
