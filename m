From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resent] uapi libc compat: allow non-glibc to opt out of
 uapi definitions
Date: Tue, 25 Apr 2017 15:22:00 +0200
Message-ID: <1d9ab212-6c80-f7fa-4be5-87b567ada949@redhat.com>
References: <20161111120820.GA435@nyan>
 <a360ec42-33ca-5e89-3d70-3b1c9a011c7f@redhat.com>
 <20170309001435.GJ2082@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309001435.GJ2082-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/09/2017 01:14 AM, Szabolcs Nagy wrote:
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

I don't think this is relevant in this context.  LTO implementations 
have to deal with this already.  For glibc's sake alone, it must be 
supported to link together code using differing feature test macros.

Thanks,
Florian
