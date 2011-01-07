From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Fri, 7 Jan 2011 15:15:13 +0100
Message-ID: <201101071515.13901.arnd@arndb.de>
References: <1294119632.1949.366.camel@sli10-conroe> <201101060838.49359.arnd@arndb.de> <1294299907.1949.582.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294299907.1949.582.camel@sli10-conroe>
Sender: linux-btrfs-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thursday 06 January 2011, Shaohua Li wrote:
> Subject: add metadata_incore ioctl in vfs
> 
> Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
> such info and uses it to do metadata readahead.
> Filesystem can hook to super_operations.metadata_incore to get metadata in
> specific approach. Next patch will give an example how to implement
> .metadata_incore in btrfs.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Looks great!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
