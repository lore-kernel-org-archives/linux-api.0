From: William Allen Simpson <william.allen.simpson@gmail.com>
Subject: Re: [PATCH] tcp: Generalized TTL Security Mechanism
Date: Thu, 14 Jan 2010 07:38:28 -0500
Message-ID: <4B4F1044.8080500@gmail.com>
References: <873a29eywq.fsf@basil.nowhere.org>	<20100114.030454.16178889.davem@davemloft.net>	<20100114112216.GK12241@basil.fritz.box> <20100114.032739.217960336.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100114.032739.217960336.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, shemminger@vyatta.com, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Miller wrote:
> The idea is that the min_ttl is set very high, so that
> you'll only accept packets from hosts that started with
> a ttl of 255 and are within a hop or two from you.  (therefore
> you'd set min_ttl to 254 or 253, something like that)
> 
That's not a particularly good idea:

http://www.iana.org/assignments/ip-parameters

IP TIME TO LIVE PARAMETER

The current recommended default time to live (TTL) for the Internet
Protocol (IP) is 64 [RFC791, RFC1122].

===

It always bugs me that things get incorrectly labeled "security", yet
cannot secure anything.

Security requires a secret.

Various folks tried all kinds of games with TTL for BGP, but the only
thing that _actually_ provided security was MD5 authentication.
