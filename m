From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] selftest/net: fix protocol family to work for IPv4.
Date: Thu, 02 Aug 2018 10:30:46 -0700 (PDT)
Message-ID: <20180802.103046.887546792433574184.davem@davemloft.net>
References: <CGME20180802100201epcas5p390bb362ccabaa99087eff88af37bffb2@epcas5p3.samsung.com>
        <20180802100201epcas5p390bb362ccabaa99087eff88af37bffb2~HCQZjTEZd0101301013epcas5p3C@epcas5p3.samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802100201epcas5p390bb362ccabaa99087eff88af37bffb2~HCQZjTEZd0101301013epcas5p3C@epcas5p3.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: maninder1.s@samsung.com
Cc: shuahkh@osg.samsung.com, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com, pankaj.m@samsung.com, a.sahrawat@samsung.com, v.narang@samsung.com
List-Id: linux-api@vger.kernel.org

From: Maninder Singh <maninder1.s@samsung.com>
Date: Thu,  2 Aug 2018 15:27:27 +0530

> use actual protocol family passed by user rather than hardcoded
> AF_INTE6 to cerate sockets.
> current code is not working for IPv4.
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Signed-off-by: Vaneet Narang <v.narang@samsung.com>

Applied.
