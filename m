From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH v2 02/17] y2038: Remove newstat family from default
 syscall set
Date: Wed, 18 Jul 2018 20:15:06 +0000
Message-ID: <alpine.DEB.2.20.1807182010290.7221@digraph.polyomino.org.uk>
References: <20180716161103.16239-1-arnd@arndb.de> <20180716161103.16239-3-arnd@arndb.de> <20180717125039.GB25416@infradead.org> <CAK8P3a3a8Fyi3e24CE=SPmdEKskEjeDr9YZte7DU_jT2svF3Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3a8Fyi3e24CE=SPmdEKskEjeDr9YZte7DU_jT2svF3Uw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Networking <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

On Tue, 17 Jul 2018, Arnd Bergmann wrote:

> That would definitely help. See below for the stat implementation
> I did in my musl libc prototype based on statx(). It passes the
> LTP syscall tests, but that doesn't mean all the corner cases
> are correct.

Well, you definitely need explicit timestamp conversions on the result of 
statx to be usable in struct stat when userspace "long" is 64-bit, for BE 
because otherwise the integer nanoseconds will be in the wrong place for 
struct timespec, and for LE if the "__reserved is held in case we need a 
yet finer resolution." might start being returned as nonzero (for integer 
attoseconds, I suppose) in future.

-- 
Joseph S. Myers
joseph@codesourcery.com
