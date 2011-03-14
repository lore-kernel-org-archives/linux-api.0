From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 06:22:44 -0400
Message-ID: <BA67B1FD-F3B2-463E-9E09-FAAB01BFE479@mit.edu>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <20110311235607.GB15853@elie> <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl> <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com> <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl> <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net> <0b7ab4190f781632fdb9a247f458edc2.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0b7ab4190f781632fdb9a247f458edc2.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: Sage Weil <sage@newdream.net>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org


On Mar 14, 2011, at 5:27 AM, Indan Zupancic wrote:

> 
> Your new syncfs also operates on files, it's only the name of sync_file_range
> which is not very fitting. Other than that, syncing files in weird, nonstandard
> ways is what it does and in that sense it's a good place for syncfs functionality.

It operates on a file system.  It takes a file descriptor as an argument.  (Much
like the statfs(2) system call.)  There's a difference. 

- Ted
