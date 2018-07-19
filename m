From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 02/17] y2038: Remove newstat family from default
 syscall set
Date: Thu, 19 Jul 2018 10:53:24 +0200
Message-ID: <CAK8P3a2bSsMDxUJfrEP-ybENL0czXrNwZCb2kGA46E42xAtu=g@mail.gmail.com>
References: <20180716161103.16239-1-arnd@arndb.de> <20180716161103.16239-3-arnd@arndb.de>
 <20180717125039.GB25416@infradead.org> <CAK8P3a3a8Fyi3e24CE=SPmdEKskEjeDr9YZte7DU_jT2svF3Uw@mail.gmail.com>
 <alpine.DEB.2.20.1807182010290.7221@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1807182010290.7221@digraph.polyomino.org.uk>
Sender: netdev-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Networking <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 18, 2018 at 10:15 PM, Joseph Myers <joseph@codesourcery.com> wrote:
> On Tue, 17 Jul 2018, Arnd Bergmann wrote:
>
>> That would definitely help. See below for the stat implementation
>> I did in my musl libc prototype based on statx(). It passes the
>> LTP syscall tests, but that doesn't mean all the corner cases
>> are correct.
>
> Well, you definitely need explicit timestamp conversions on the result of
> statx to be usable in struct stat when userspace "long" is 64-bit, for BE
> because otherwise the integer nanoseconds will be in the wrong place for
> struct timespec, and for LE if the "__reserved is held in case we need a
> yet finer resolution." might start being returned as nonzero (for integer
> attoseconds, I suppose) in future.

Right. The musl implementation I sent did that by simply copying each
field we care about from the statx structure into the stat structure
individually. This is the more or less the same thing that the kernel
does to implement stat() as well.

     Arnd
