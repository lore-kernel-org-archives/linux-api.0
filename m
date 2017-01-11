From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Wed, 11 Jan 2017 13:46:03 -0800
Message-ID: <20170111214603.GF8388@tassilo.jf.intel.com>
References: <20170105192910.q26ozg4ci4i3j2ai@black.fi.intel.com>
 <161ece66-fbf4-cb89-3da6-91b4851af69f@intel.com>
 <CALCETrUQ2+P424d9MW-Dy2yQ0+EnMfBuY80wd8NkNmc8is0AUw@mail.gmail.com>
 <978d5f1a-ec4d-f747-93fd-27ecfe10cb88@intel.com>
 <20170111142904.GD4895@node.shutemov.name>
 <CALCETrUn=KNdOnoRYd8GcnXPNDHAhGkaMaHRTAri4o92FSC1qg@mail.gmail.com>
 <20170111183750.GE4895@node.shutemov.name>
 <0a6f1ee4-e260-ae7b-3d39-c53f6bed8102@intel.com>
 <CALCETrXDbkotCZ1WEbhNeYGt0zyKT42agzsFxT2SZJ4wadEnQA@mail.gmail.com>
 <CA+55aFyhva9bw48G669z4QfJXjjJA5s+necfWmYoAB6eyzea=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyhva9bw48G669z4QfJXjjJA5s+necfWmYoAB6eyzea=A@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Dave Hansen <dave.hansen@intel.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 11, 2017 at 11:31:25AM -0800, Linus Torvalds wrote:
> On Wed, Jan 11, 2017 at 11:20 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Taking a step back, I think it would be fantastic if we could find a
> > way to make this work without any inheritable settings at all.
> > Perhaps we could have a per-mm value that is initialized to 2^47-1 on
> > execve() and can be raised by ELF note or by prctl()?
> 
> I definitely think this is the right model. No inheritable settings,
> no suid issues, no worries. Make people who want the large address
> space (and there aren't going to be a lot of them) just mark their
> binaries at compile time.

Compile time is inconvenient if you want to test some existing
random binary if it works.

I tried to write a tool which patched ELF notes into binaries
some time ago for another project, but it ran into difficulties
and didn't work everywhere.

An inheritance scheme is much nicer for such use cases.

-Andi
