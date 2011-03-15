From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Tue, 15 Mar 2011 13:18:46 -0700
Message-ID: <20110315131846.4d41af3c.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	<edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	<201103111255.44979.arnd@arndb.de>
	<ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	<20110311235607.GB15853@elie>
	<9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	<20110312021001.GA16833@elie>
	<20110312173217.GA24981@kroah.com>
	<1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
	<Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
	<20110315101155.GO15097@dastard>
	<C79DDACF-9320-424D-84F5-3DB9C5325B1D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C79DDACF-9320-424D-84F5-3DB9C5325B1D@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, Sage Weil <sage@newdream.net>, Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@lst.de" <hch@lst.de>, "l@jasper.es" <l@jasper.es>
List-Id: linux-api@vger.kernel.org

On Tue, 15 Mar 2011 09:56:08 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> Should there be a "wait" argument or flag that allows an app to start the syncfs(), do something, and then call again to wait for completion?

I don't think so.  If userspace wants to do that then fork().

> > Perhaps we should consider propagating errors out to the user
> > application rather than discarding them in kernel and pretending we
> > can't ever have a write error?

That would be nice, but is probably a pretty complex thing to
implement.  The manpage should include words indicating that syncfs()
can return an errno.  That way, userspace will hopefully have the
appropriate checks, whcih will become more useful if/when the kernel
implementation gets fixed up.
