From: Felix Janda <felix.janda@posteo.de>
Subject: Re: Re: [PATCH resent] uapi libc compat: allow non-glibc to
 opt out of uapi definitions
Date: Sat, 8 Jul 2017 16:27:28 -0400
Message-ID: <20170708202728.GA1625@nyan>
References: <20161111120820.GA435@nyan>
 <1488977188.4347.134.camel@infradead.org>
 <9373f78c-ff15-fbb5-724a-27152d6f994b@hauke-m.de>
 <d7624df0-0ea4-aba1-f862-9bac540c972f@redhat.com>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-11709-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <d7624df0-0ea4-aba1-f862-9bac540c972f@redhat.com>
To: Carlos O'Donell <carlos@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, musl@lists.openwall.com, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Carlos O'Donell wrote:
> On 04/25/2017 02:37 AM, Hauke Mehrtens wrote:
> > 
> > 
> > On 03/08/2017 01:46 PM, David Woodhouse wrote:
> >> On Fri, 2016-11-11 at 07:08 -0500, Felix Janda wrote:
> >>> Currently, libc-compat.h detects inclusion of specific glibc headers,
> >>> and defines corresponding _UAPI_DEF_* macros, which in turn are used in
> >>> uapi headers to prevent definition of conflicting structures/constants.
> >>> There is no such detection for other c libraries, for them the
> >>> _UAPI_DEF_* macros are always defined as 1, and so none of the possibly
> >>> conflicting definitions are suppressed.
> >>>
> >>> This patch enables non-glibc c libraries to request the suppression of
> >>> any specific interface by defining the corresponding _UAPI_DEF_* macro
> >>> as 0.
> >>
> >> Ick. It's fairly horrid for kernel headers to be reacting to __GLIBC__
> >> in any way. That's just wrong.
> >>
> >> It makes more sense for C libraries to define the __UAPI_DEF_xxx for
> >> themselves as and when they add their own support for certain things,
> >> and for the kernel not to have incestuous knowledge of them.
> >>
> >> The part you add here in the #else /* !__GLIBC__ */ part is what we
> >> should do at *all* times.
> >>
> >> I understand that we'll want to grandfather in the glibc horridness,
> >> but let's make it clear that that's what it is, by letting it set the
> >> appropriate __UAPI_DEF_xxx macros to zero, and then continue through to
> >> your new part. Something like this (incremental to yours):
> > 
> > Felix's and this change and are looking better than my patches here:
> > https://lkml.org/lkml/2017/3/12/235
> > 
> > Is someone working on brining this into the mainline kernel?
> > 
> > Is it correct that only the comments should be improved?
> > musl only supports including the musl header files before the kernel
> > anyway, I assume that it is not needed to make the kernel uapi code
> > support also the other order.
> 
> Please repost to linux-api so other relevant C library authors can review
> the changes and comment on how they might be harmonized.

>From the beginning, this patch was CCed to linux-api. Let me repost
anyway with a new (hopefully clearer) commit message.

> Whether or not you  support both inclusion orders, kernel first, or libc first,
> is a property of your libc implementation.
> 
> Today glibc aims to support both inclusion orders since we see applications
> with either order, and the ordering should not matter in this case. You either
> get one or the other without needing to know any special rules about header
> ordering.

This patch does not change anything for glibc (or uclibc), it just, in
a not very intrusive way, improves the situation for any other libc.

Felix
