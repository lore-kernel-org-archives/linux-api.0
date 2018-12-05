From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [PATCH] Y2038: provide kernel support indication
Date: Wed, 5 Dec 2018 15:26:49 +0000
Message-ID: <alpine.DEB.2.21.1812051519390.25136@digraph.polyomino.org.uk>
References: <20180919071303.26636-1-albert.aribaud@3adev.fr> <alpine.DEB.2.21.1809191300420.14910@digraph.polyomino.org.uk> <20180924235639.716a4cb4@athena> <alpine.DEB.2.21.1809251656190.14070@digraph.polyomino.org.uk> <20180925213635.70084f61@athena>
 <CAK8P3a17ZpOKx=p1Y2FgruM3GMcdOtiwaQqPvmg5xZQpFP2fCQ@mail.gmail.com> <20181205124926.7d433994@athena> <CAK8P3a0vZhfW_o3OhYBhwRmKCXA0jAAuODxmzHt+rwJkKO45ZA@mail.gmail.com> <alpine.DEB.2.21.1812051337210.13925@digraph.polyomino.org.uk>
 <CAK8P3a25W8NXY9e=DMzL-jd4+69ecZMyrWGxYDPP4MuH-Ng-9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <libc-alpha-return-97979-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAK8P3a25W8NXY9e=DMzL-jd4+69ecZMyrWGxYDPP4MuH-Ng-9Q@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 5 Dec 2018, Arnd Bergmann wrote:

> That would make it very hard to deploy a glibc based system
> with strict y2038 requirements. If we can no longer guarantee the
> basic assumption that old applications keep using the old system
> calls, then I think we instead need a way to build glibc itself without
> support for the 32-bit time_t interfaces, e.g. using a --disable-time32
> configuration switch to force a link-time error for any application
> or library that has not been built against the 64-bit time_t interfaces.

(There's never been a guarantee of keeping using the same system calls.  
Cf. people trying to restrict the system calls some code can use and 
running into issues with moves to use e.g. *at syscalls unconditionally on 
all architectures to implement the non-*at functions.)

The set of interfaces that involve 32-bit time_t or other structures 
including it is well-defined; an external checker can examine the dynamic 
symbol table of any dynamically linked 32-bit application or shared 
library to see if it has references to any of the symbols in question, 
without needing to run the code at all (and so detect issues in code that 
might not be frequently executed, not just in whatever code runs when 
you're testing for 32-bit time uses).  (Or if you control the build of the 
whole system, do a local change to make a glibc header use #error if 
_TIME_BITS is not defined to 64.)

I'd expect it to be a long time before we might consider making 32-bit 
time_t (and thus 32-bit off_t) subject to something like 
--enable-obsolete-rpc / --enable-obsolete-nsl being needed to make the 
32-bit interfaces available at (static) link time at all.

-- 
Joseph S. Myers
joseph@codesourcery.com
