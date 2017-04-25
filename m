From: Rich Felker <dalias@libc.org>
Subject: Re: Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Tue, 25 Apr 2017 13:00:04 -0400
Message-ID: <20170425170004.GX17319@brightrain.aerifal.cx>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
 <459a8faf-4585-5063-3d94-3a1fecfa8289@redhat.com>
 <21e624b9-7ab1-dcf9-fb1e-c31dd564a283@hauke-m.de>
 <9f591383-6e4c-c231-1e5b-68e4b8c16d94@redhat.com>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-11310-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <9f591383-6e4c-c231-1e5b-68e4b8c16d94@redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Carlos O'Donell <carlos@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, musl@lists.openwall.com, David Woodhouse <dwmw2@infradead.org>, Felix Janda <felix.janda@posteo.de>, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 25, 2017 at 08:29:00AM -0400, Carlos O'Donell wrote:
> On 04/25/2017 02:45 AM, Hauke Mehrtens wrote:
> > On 03/08/2017 05:39 PM, Carlos O'Donell wrote:
> >> Any header needing compat with a libc includes libc-compat.h (per the 
> >> documented way the model works). With this patch any included linux kernel
> >> header that also includes libc-compat.h would immediately define all 
> >> the __UAPI_DEF_* constants to 1 as-if it had defined those structures, 
> >> but it has not.
> >>
> >> For example, with these two patches applied, the inclusion of linux/if.h
> >> would define __UAPI_DEF_XATTR to 1, but linux/if.h has not defined
> >> XATTR_CREATE or other constants, so a subsequent inclusion sys/xattrs.h
> >> from userspace would _not_ define XATTR_CREATE because __UAPI_DEF_XATTR set
> >> to 1 indicates the kernel has.
> >>
> >> I don't want to read into the model you are proposing and would rather you
> >> document the semantics clearly so we can all see what you mean.
> > 
> > What about moving the code from libc-comapt.h into the specific header
> > files? This way including linux/if.h would not have an impact on
> > __UAPI_DEF_XATTR, because this is defined in linux/xattr.h. We would
> > still have a problem when the specific Linux header file gets included
> > before the libc header file, but at least musl does not support this anyway.
> 
> The point of libc-compat.h is to contain the libc-related logic to a single header
> where it can be reviewed easily as a whole for each libc.
> 
> Headers that include libc-compat.h need not have any libc-related logic, they need
> only guard their structures with the appropriate __UAPI_DEF* macros per the rules
> described in libc-compat.h.
> 
> This way we minimize any changes to the header files and keep the complex
> logic in one place where the libc authors can discuss it.
> 
> In glibc right now we support including linux or glibc header files first,
> and this has always been a requirement from the start. This requirement dictates
> that the kernel know which libc it's being used with so it can tailor coordination.
> 
> If musl only needs header coordination in one direction, then support only that
> direction, but please do not presume to simplify the code by deleting a bunch of
> things that were worked into the kernel to ensure header inclusion ordering works
> in both ways.

Agreed.

On the musl side, we really don't want to be playing cat-and-mouse
having to follow every kernel change and rework things when subtle
differences from kernel-provided definitions might conflict. Saying
(with a macro) "we've got this, please don't try to redefine it" is
easy and maitenance-free; trying to make do with a definition that may
or may not be entirely compatible with libc types or namespace
constraints is nontrivial, and I'd rather it (including kernel defs
first) just not work from the outset than break somewhere down the
line and turn into an argument over whether it needs to be fixed and
if so how.

But none of this justifies breaking stuff that's working for glibc or
preventing them from cleanly supporting both orders.

Rich
