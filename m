From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2 00/23] netoops support
Date: Tue, 9 Nov 2010 12:25:35 +0800
Message-ID: <20101109042535.GB5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <87k4knqo91.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k4knqo91.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Waychison <mikew@google.com>, simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>, adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 09, 2010 at 02:28:26AM +0100, Andi Kleen wrote:
>Mike Waychison <mikew@google.com> writes:
>
>I'm still not fully convinced this needs to be a fully separate
>mechanism from netconsole.  It seems a lot of work to implement
>basically log level.
>
>Maybe netconsole could be patched to support only dumping KERN_EMERG?
>

I tend to agree, IMHO, we can introduce another parameter like "oops_only"
to netconsole.


>But I guess the structured logging has some advantages, although
>there have been certainly oops parsers (e.g. kerneloops.org) without it.
>

+1
