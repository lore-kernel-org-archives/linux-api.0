From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 09:32:17 -0800
Message-ID: <20110312173217.GA24981@kroah.com>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
 <20110312021001.GA16833@elie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110312021001.GA16833@elie>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>, Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2011 at 08:10:01PM -0600, Jonathan Nieder wrote:
> Indan Zupancic wrote:
> 
> > I'm not pushing for any official convention, just what seems good taste.
> 
> In cases like this, conventions (consistency and best practices) are
> very important.
> 
> > Less code added, less bloat. Architecture independent, no need to update
> > all system call tables everywhere (all archs, libc versions and strace).
> > Two files changed, instead of 7 (which only hooks up x86).
> 
> Thanks for explaining.  Those do seem like good reasons to use a ioctl
> instead of a new syscall.

No, make it a syscall, it's more obvious and will be documented much
better.

thanks,

greg k-h
