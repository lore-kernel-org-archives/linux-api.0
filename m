From: Rich Felker <dalias@libc.org>
Subject: Re: Re: [PATCH] uapi: Prevent redefinition of struct iphdr
Date: Mon, 30 Dec 2019 12:12:02 -0500
Message-ID: <20191230171202.GG30412@brightrain.aerifal.cx>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
 <20191225.163411.1590483851343305623.davem@davemloft.net>
 <20191226010515.GD30412@brightrain.aerifal.cx>
 <20191225.194929.1465672299217213413.davem@davemloft.net>
 <66db73b0-c470-4708-a017-c662f4ca0d7c@www.fastmail.com>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-15092-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <66db73b0-c470-4708-a017-c662f4ca0d7c@www.fastmail.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Daniel Kolesa <daniel@octaforge.org>
Cc: David Miller <davem@davemloft.net>, musl@lists.openwall.com, AWilcox@Wilcox-Tech.com, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 26, 2019 at 12:13:37PM +0100, Daniel Kolesa wrote:
> On Thu, Dec 26, 2019, at 04:49, David Miller wrote:
> > From: Rich Felker <dalias@libc.org>
> > Date: Wed, 25 Dec 2019 20:05:15 -0500
> > 
> > > On Wed, Dec 25, 2019 at 04:34:11PM -0800, David Miller wrote:
> > >> I find it really strange that this, therefore, only happens for musl
> > >> and we haven't had thousands of reports of this conflict with glibc
> > >> over the years.
> > > 
> > > It's possible that there's software that's including just one of the
> > > headers conditional on __GLIBC__, and including both otherwise, or
> > > something like that. Arguably this should be considered unsupported
> > > usage; there are plenty of headers where that doesn't work and
> > > shouldn't be expected to.
> > 
> > I don't buy that, this is waaaaaay too common a header to use.
> 
> In case of net-tools, only <linux/ip.h> is included, and never
> <netinet/ip.h> directly. Chances are in musl the indirect include
> tree happens to be different and conflicting, while in glibc it is
> not.

musl has no indirect inclusion of netinet/ip.h from standard headers,
but does include it from netinet/ip_icmp.h. It seems glibc only does
this conditional on __USE_MISC, which doesn't make much sense to me
since this is not a standardized header with namespace rules, but
normally __USE_MISC is defined anyway on glibc so I kinda doubt this
is the difference.

Any other ideas?

Rich
