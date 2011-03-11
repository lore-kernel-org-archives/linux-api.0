From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Fri, 11 Mar 2011 17:56:15 -0600
Message-ID: <20110311235607.GB15853@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

Indan Zupancic wrote:

> If there still is a good reason to implement this, please don't add it
> as a new system call, but add it to sync_file_range(), as that seems
> the best place for odd file synchronisation operations.

I have no strong preference about how this is added (and in fact I'm
quite ignorant about the usual conventions), but:

 - as a sysadmin, it really _would_ be nice to be able to say
   "sync /usr" to sync /usr;

 - the existing functionality of sync_file_range is about controlling
   writeback behavior for files, not mounts.

So unless there is a shortage of syscall numbers or something, I find
the request to omit this or tack it onto sync_file_range odd.  Could
you explain the benefit?

Thanks,
Jonathan
