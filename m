From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5] Documentation/arch: Add Documentation/arch-TODO
Date: Thu, 14 May 2015 00:21:01 -0700
Message-ID: <55544CDD.108@zytor.com>
References: <20150511192918.GA11361@jtriplet-mobl1>	<20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>	<20150512213843.GV21418@twins.programming.kicks-ass.net>	<20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>	<20150513083441.GA17336@gmail.com>	<20150513085636.GA11030@gmail.com>	<20150513092421.GB11030@gmail.com>	<20150513094622.GC11030@gmail.com>	<20150513094756.GD11030@gmail.com>	<20150513140945.GA8376@dellaz> <CAMuHMdXV68nie93Rb=Z+vYtn2aNex=s5E4+Z=QGojF+8EbPbKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXV68nie93Rb=Z+vYtn2aNex=s5E4+Z=QGojF+8EbPbKA@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Michele Curti <michele.curti@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux-Arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org

On 05/13/2015 07:42 AM, Geert Uytterhoeven wrote:
> On Wed, May 13, 2015 at 4:09 PM, Michele Curti <michele.curti@gmail.com> wrote:
>> Tried to transpose rows with columns, to avoid architecture name duplication
>> and to get only one table while keeping 80 char width, but result seems less
>> readable :p
>>
>>
>>                                                 m
>>                                                 i                         u
>>                               b                 c       o                 n
>>                               l       h         r   m   p   p             i
>>                               a       e         o   n   e p o             c   x
>>                     a     a a c       x       m b   1 n n a w   s   s     o   t
>>                     l     r v k   c   a i m m e l m 0 i r r e s c   p t   r   e
>>                     p a a m r f c r f g a 3 6 t a i 3 o i i r 3 o   a i   e x n
>>                     h r r 6 3 i 6 i r o 6 2 8 a z p 0 s s s p 9 r s r l u 3 8 s
>>                     a c m 4 2 n x s v n 4 r k g e s 0 2 c c c 0 e h c e m 2 6 a
>> -------------------------------------------------------------------------------
>>             lockdep T K K K K K T T T K T T T K K K T T T T K K K K K K K K K K
>>      stackprotector T T K K T T T T T T T T T T T K T T T T T T T K T T T T K T
>>         jump-labels T T K K T T T T T T T T T T T K T T T T K K T T K T T T K T
>>      seccomp-filter T T K K T T T T T T T T T T T K T T T T T K T T T T T T K T
> 
> I thought about that, too, as there are more (not fully implemented) features
> than architectures. But I expect more merge conflicts with the transposed
> version.
> 

There is another reason for the transposed version, which is that it
makes adding features to the list much easier.  At the same time, plain
ASCII is horrific for maintaining tables...

	-hpa
