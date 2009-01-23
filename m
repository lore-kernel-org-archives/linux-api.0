From: Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Fri, 23 Jan 2009 11:45:30 +0100
Message-ID: <1232707530.7914.23.camel@spike.firmix.at>
References: <20090115153211.663df310@bike.lwn.net>
	 <20090122065104.2787df2d.akpm@linux-foundation.org>
	 <20090122221500.4c62aa54@tpl>
	 <20090122213105.74142908.akpm@linux-foundation.org>
	 <1232689549.5202.385.camel@calx>
	 <20090123061557.GM15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758926AbZAWKrV@vger.kernel.org>
In-Reply-To: <20090123061557.GM15750@one.firstfloor.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, oleg@redhat.com, linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
List-Id: linux-api@vger.kernel.org

On Fri, 2009-01-23 at 07:15 +0100, Andi Kleen wrote: 
> > I have to agree with Christoph. The priority here is breaking down the
> > BKL and document all the things being protected by it and we've got a
> > reasonably obvious patch in that direction. Meanwhile, there's not
> > currently a pressing demand to make fasync in particular scale that I'm
> > aware of.
> 
> The classic case is a high throughput network server that uses async
> sockets. It has to call F_SETFL on each new socket it opens.

Am I the only one missing an (additional) socket()-like sys-call with an
additional "flags" argument (somewhat similar to open())?
O_NONBLOCK is another flag that may be set quite often/regularly (at
least in my small world).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services
