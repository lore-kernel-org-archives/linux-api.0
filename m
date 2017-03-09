From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Wed, 8 Mar 2017 19:51:29 -0500
Message-ID: <e3d6aab4-4503-8487-d8d2-367d92f8aa97@redhat.com>
References: <20161111120820.GA435@nyan>
 <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
 <20170309001435.GJ2082@port70.net>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <musl-return-11141-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
In-Reply-To: <20170309001435.GJ2082@port70.net>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org, musl@lists.openwall.com, Rich Felker <dalias@aerifal.cx>
List-Id: linux-api@vger.kernel.org

On 03/08/2017 07:14 PM, Szabolcs Nagy wrote:
> * Carlos O'Donell <carlos@redhat.com> [2017-03-08 10:53:00 -0500]:
>> On 11/11/2016 07:08 AM, Felix Janda wrote:
>>> fixes the following compiler errors when <linux/in6.h> is included
>>> after musl <netinet/in.h>:
>>>
>>> ./linux/in6.h:32:8: error: redefinition of 'struct in6_addr'
>>> ./linux/in6.h:49:8: error: redefinition of 'struct sockaddr_in6'
>>> ./linux/in6.h:59:8: error: redefinition of 'struct ipv6_mreq'
>>
>> Do you have plans for fixing the error when the inclusion order is the other way?
> 
> the other way (linux header included first) is
> problematic because linux headers don't follow
> all the standards the libc follows, they violate
> namespace rules in their struct definitions, so
> the libc definitions are necessarily incompatible
> with them and thus different translation units can
> end up refering to the same object through
> incompatible types which is undefined.
> (even if the abi matches and thus works across
> the syscall interface, a sufficiently smart
> toolchain can break such code at link time,
> and since the libc itself uses its own definitons
> that's what user code should use too).
> 
> there should be a way to include standard conform
> libc headers and linux headers into the same tu,
> at least the case when all conflicting definitions
> come from the libc should work and i think that
> should be the scope of these libc-compat.h changes.
> (of course if glibc tries to support arbitrary
> interleavings then the changes should not break that)

You can get non-standard defines even when including the
linux headers _after_ libc headers because linux headers
should rightly continue to define things that are required
for linux-specific applications.

IMO the fact that the UAPI headers may cause problems with
standards conformance is orthogonal to the discussion of 
_how_ we fix inclusion order issues.

Some of the network headers can be used in relative safety
and need to be used for some applications. It is those cases
where I'd like to see an inclusion guard design that works
for both inclusion orders.

-- 
Cheers,
Carlos.
