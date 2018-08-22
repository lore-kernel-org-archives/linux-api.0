From: Christoph Hellwig <hch@infradead.org>
Subject: Re: exporting uuid_t from uapi/linux/uuid.h
Date: Tue, 21 Aug 2018 23:05:18 -0700
Message-ID: <20180822060518.GA28873@infradead.org>
References: <ffc387b8-09f5-537a-c5a9-08ec28e088e0@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ffc387b8-09f5-537a-c5a9-08ec28e088e0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-api@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 21, 2018 at 10:25:50PM +0300, Nikolay Borisov wrote:
> Hello,
> 
> I'm doing some refactoring on btrfs and would like to convert some of
> the "naked" definition of UUID in on-disk object to uuid_t. Since those
> structs are defined in include/uapi/linux/btrfs_tree.h I naturally would
> need to expose the kernel uuid_t to the uapi header via
> include/uapi/linux/uuid.h. The uuid was originally unexported in
> 60927bc31436 ("uuid: remove uuid_be defintions from the uapi header")
>  but at that time it was called uuid_be. The thing is that btrfs-progs
> for example uses both btrfs_tree.h uapi header as well as libuuid. THe
> latter also defines uuid_t. Both the kernel one and libuuid are binary
> compatible.
> 
> So what's the correct way (if any) to expose a kernel type that might
> have also been defined by a userspace library?

Please just use an raw array of __u8 for your APIs.
