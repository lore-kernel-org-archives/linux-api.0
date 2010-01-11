From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] tcp: Generalized TTL Security Mechanism
Date: Mon, 11 Jan 2010 18:10:28 +0100
Message-ID: <4B4B5B84.3090409@gmail.com>
References: <20100110220034.4d46ba8a@nehalam>	<4B4B0AA3.6010207@gmail.com> <20100111082529.3d5cdae3@nehalam> <4B4B5A0A.3090600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4B4B5A0A.3090600@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Le 11/01/2010 18:04, Eric Dumazet a =C3=A9crit :
> Given this is an IP level option, check could be done at IP level, so=
 that other protocols
> can use it too ?

Oops, this is stupid, we dont have the socket pointer at IP level :)

