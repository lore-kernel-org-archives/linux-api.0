From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Thu, 10 Mar 2011 23:08:22 +0100
Message-ID: <201103102308.23006.arnd@arndb.de>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
Sender: linux-arch-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thursday 10 March 2011 20:31:30 Sage Weil wrote:
> It is frequently useful to sync a single file system, instead of all
> mounted file systems via sync(2):
> 
>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).
>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.
> 
> ...
> Signed-off-by: Sage Weil <sage@newdream.net>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
