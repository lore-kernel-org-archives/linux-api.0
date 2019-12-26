From: David Miller <davem@davemloft.net>
Subject: Re: [musl] Re: [PATCH] uapi: Prevent redefinition of struct iphdr
Date: Wed, 25 Dec 2019 19:49:29 -0800 (PST)
Message-ID: <20191225.194929.1465672299217213413.davem@davemloft.net>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
        <20191225.163411.1590483851343305623.davem@davemloft.net>
        <20191226010515.GD30412@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191226010515.GD30412@brightrain.aerifal.cx>
Sender: netdev-owner@vger.kernel.org
To: dalias@libc.org
Cc: AWilcox@Wilcox-Tech.com, netdev@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

From: Rich Felker <dalias@libc.org>
Date: Wed, 25 Dec 2019 20:05:15 -0500

> On Wed, Dec 25, 2019 at 04:34:11PM -0800, David Miller wrote:
>> I find it really strange that this, therefore, only happens for musl
>> and we haven't had thousands of reports of this conflict with glibc
>> over the years.
> 
> It's possible that there's software that's including just one of the
> headers conditional on __GLIBC__, and including both otherwise, or
> something like that. Arguably this should be considered unsupported
> usage; there are plenty of headers where that doesn't work and
> shouldn't be expected to.

I don't buy that, this is waaaaaay too common a header to use.

Please investigate.
