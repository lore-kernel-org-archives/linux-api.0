From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
Date: Tue, 19 Sep 2017 10:15:38 +0200
Message-ID: <20170919081538.mk23eue6dysv67b2@rh_laptop>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
 <1505749947-26360-5-git-send-email-lczerner@redhat.com>
 <20170918175651.GA7937@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170918175651.GA7937@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 18, 2017 at 10:56:51AM -0700, Christoph Hellwig wrote:
> This seems to miss any explanation and 6 out of 7 patches.

See linux-fsdevel for entire patch set.
https://www.spinics.net/lists/linux-fsdevel/msg115740.html

> 
> That being said, I really detest adding weird query modes to random
> syscalls.  We should expose capabilities through the interface that
> was designed for such things: (f)pathconf, as there are a lot more
> important parameters we currently fail to expose to userspace to
> start with.

(f)pathconf on it's own is useless because I need to get this
information directly from the file system. Supported fallocate modes can
differ with inode flags (encrypted files, extent/indirect based files on
ext4). I also need in-kernel interface.

That's why I though fallocate is the convenient place to put this. I
have not looked to it, but other option might be to use fstat to get
this.

-Lukas
