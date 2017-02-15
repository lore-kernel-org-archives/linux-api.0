From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Wed, 15 Feb 2017 16:20:23 +1100
Message-ID: <87bmu4kp2g.fsf@concordia.ellerman.id.au>
References: <20170128111310.GA13389@ls3530.fritz.box> <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org> <1485990732.2322.40.camel@HansenPartnership.com> <CAEdQ38FXam3sXKFc5-3WEgDDov0yayAWXK8hbuNjbSxJQ5QDVw@mail.gmail.com> <alpine.LFD.2.20.1702051300010.27997@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1702051300010.27997@eddie.linux-mips.org>
Sender: linux-parisc-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>, Matt Turner <mattst88@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, LKML <linux-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, Michael Kerrisk <mtk.manpages@googlemail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:

> On Sun, 5 Feb 2017, Matt Turner wrote:
>
>> > I don't think it is other than for PPC.  If you're not variable endian
>> > (which is only PPC to date), then you should know a priori what endian
>> > you are from the #defines in userspace.
>> 
>> MIPS as well, but it seems strange to require the kernel to tell you
>> your endianness, when you can easily determine it yourself. Unless
>> there's something about this I don't understand.
>
>  Many MIPS processors do have a reverse-endian control bit, which allows a 
> user process to execute in the endianness opposite to the endianness the 
> kernel runs in.  The feature has been around since 1991 and the R4000 CPU, 
> however support is unlikely to be ever added to the MIPS/Linux port, due 
> to the complexity required for byte-swapping all the data structures 
> passed in memory between the kernel and the userland.  Does the PPC/Linux 
> port actually implement this swapping?

No. Userspace can change endian, but it has to cope with the kernel
being in the original endian.

cheers
