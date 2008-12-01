From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Date: Mon, 1 Dec 2008 10:12:45 -0800
Message-ID: <20081201101245.0a2f3123.randy.dunlap@oracle.com>
References: <1227980689.6354.24.camel@localhost.localdomain>
	<20081129214207.GA6747@x200.localdomain>
	<20081129234907.GA2340@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753677AbYLASNv@vger.kernel.org>
In-Reply-To: <20081129234907.GA2340@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Remi Colinet <remi.colinet@gmail.com>, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 29 Nov 2008 15:49:07 -0800 Greg KH wrote:

> On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> > On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > > This patch add a new /proc/mempool file in order to display mempool usage.
> > > 
> > > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > > configuration.
> > 
> > We're NOT adding config option per proc file.
> > 
> > And can we, please, freeze /proc for not per-process stuff and open debugfs
> > for random stuff, please?
> 
> debugfs has been open for random stuff since the day it was added to the
> tree :)
> 
> Feel free to put this kind of thing there instead of proc.

Do distros ship with debugfs enabled?
The problem with using debugfs is that it is very optional IMO.

---
~Randy
