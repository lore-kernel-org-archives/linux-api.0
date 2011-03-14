From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 14:20:32 -0700
Message-ID: <20110314142032.b9523309.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	<edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	<201103111255.44979.arnd@arndb.de>
	<ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	<20110311235607.GB15853@elie>
	<9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	<20110312021001.GA16833@elie>
	<20110312173217.GA24981@kroah.com>
	<1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
	<20110314131042.5a7fb32f.akpm@linux-foundation.org>
	<20110314211119.GC8120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110314211119.GC8120@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: G@thunk.org, Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Mon, 14 Mar 2011 17:11:19 -0400
"Ted Ts'o" <tytso@mit.edu> wrote:

> On Mon, Mar 14, 2011 at 01:10:42PM -0700, Andrew Morton wrote:
> > 
> > There might one day be a requirement to be able to initiate a
> > resource-management-style writeback against a whole filesystem.  When
> > that happens, we'll regret not having added a "mode" argument to
> > sys_syncfs().
> 
> I'm a bit nervous about exposing WB_SYNC_NONE to userspace, because
> its semantics are *definitely* hard to describe.  For example, at the
> moment if you do a WB_SYNC_NONE writeback, the writeback code will
> clamp the amount of data written back for each inode to
> MAX_WRITEBACK_PAGES (1024) pages.

Wha?  It does?  When did that get broken?

>  Do we want to document that?
> Probably not!  But if we don't document it, what can userspace expect?
> 
> If you just issue a writeback_inodes_sb(), it's not the case that it
> will start a process that will eventually write out everything (i.e.,
> it's not the equivalent of a non-blocking data integrity sync).  It
> just means, "write out some stuff".
> 
> I could imagine userspace wanting to start a non-blocking writeout of
> all data blocking pages, and which doesn't cause queue flush / barrier
> requests.  (i.e., a non-blocking-non-barrier-issuing-but-otherwise-a-
> data-integrity writeback) But that's not something that the current
> writeback machinery can do easily, at least not today.

Well.  Current implementation shortcomings don't carry a lot of weight
when designing a permanent interface.

> It wouldn't hurt to have a "flags" field which we could expand later
> --- but that can lead to portability headaches for userspace programs
> that don't know whether a particular kernel is going to support a
> particular flag or not.  So it's certainly not a panacea.

I don't see a need to add an arg to syncfs() really.  But we should
demonstrate that we've thought about it ;)

