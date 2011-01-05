From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/5]add metadata_readahead ioctl in vfs
Date: Wed, 5 Jan 2011 10:26:15 +0100
Message-ID: <201101051026.15391.arnd@arndb.de>
References: <1294119637.1949.368.camel@sli10-conroe> <1294193496.1949.378.camel@sli10-conroe> <201101051009.20591.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101051009.20591.arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wednesday 05 January 2011 10:09:20 Arnd Bergmann wrote:
> > Thanks, fixed them.
> 
> The patch you posted still uses COMPATIBLE_IOCTL. Wrong patch?

On a second look, I noticed that you now have both the COMPATIBLE_IOCTL
and the case statement in compat_sys_ioctl. The former can be
dropped.

	Arnd
