From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
Date: Tue, 11 Nov 2014 11:03:40 +0100
Message-ID: <1415700220.2163.3.camel@sipsolutions.net>
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
	 <1415698161.2163.0.camel@sipsolutions.net> <5461DCC9.5050702@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5461DCC9.5050702@broadcom.com>
Sender: netdev-owner@vger.kernel.org
To: Arend van Spriel <arend@broadcom.com>
Cc: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>, "linville@tuxdriver.com" <linville@tuxdriver.com>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-11 at 10:54 +0100, Arend van Spriel wrote:

> > Also, there's a competing approach from QCA that's far more suited.
> 
> I probably was not paying attention to it, but would you have a
> reference to this.

... digs around in email ...

http://mid.gmane.org/1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com

Anyway, looking back at that, it wasn't really all that different, just
a bit more complete maybe.

johannes
