From: Szabolcs Nagy <nsz@port70.net>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Thu, 9 Mar 2017 01:14:35 +0100
Message-ID: <20170309001435.GJ2082@port70.net>
References: <20161111120820.GA435@nyan>
 <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-11140-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
To: Carlos O'Donell <carlos@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com, Rich Felker <dalias@aerifal.cx>
List-Id: linux-api@vger.kernel.org

* Carlos O'Donell <carlos@redhat.com> [2017-03-08 10:53:00 -0500]:
> On 11/11/2016 07:08 AM, Felix Janda wrote:
> > fixes the following compiler errors when <linux/in6.h> is included
> > after musl <netinet/in.h>:
> > 
> > ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
> > ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
> > ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'
> 
> Do you have plans for fixing the error when the inclusion order is the other way?

the other way (linux header included first) is
problematic because linux headers don't follow
all the standards the libc follows, they violate
namespace rules in their struct definitions, so
the libc definitions are necessarily incompatible
with them and thus different translation units can
end up refering to the same object through
incompatible types which is undefined.
(even if the abi matches and thus works across
the syscall interface, a sufficiently smart
toolchain can break such code at link time,
and since the libc itself uses its own definitons
that's what user code should use too).

there should be a way to include standard conform
libc headers and linux headers into the same tu,
at least the case when all conflicting definitions
come from the libc should work and i think that
should be the scope of these libc-compat.h changes.
(of course if glibc tries to support arbitrary
interleavings then the changes should not break that)
