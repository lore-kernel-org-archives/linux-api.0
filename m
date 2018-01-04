From: David Miller <davem@davemloft.net>
Subject: Re: uapi/if_ether.h: prevent redefinition of struct ethhdr
Date: Thu, 04 Jan 2018 14:31:03 -0500 (EST)
Message-ID: <20180104.143103.1685045831952935199.davem@davemloft.net>
References: <20180103221421.8273-1-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180103221421.8273-1-hauke@hauke-m.de>
Sender: netdev-owner@vger.kernel.org
To: hauke@hauke-m.de
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com, felix.janda@posteo.de, f.fainelli@gmail.com
List-Id: linux-api@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed,  3 Jan 2018 23:14:21 +0100

> Musl provides its own ethhdr struct definition. Add a guard to prevent
> its definition of the appropriate musl header has already been included.
> 
> glibc does not implement this header, but when glibc will implement this
> they can just define __UAPI_DEF_ETHHDR 0 to make it work with the
> kernel.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied, thank you.
