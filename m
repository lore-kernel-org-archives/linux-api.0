From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Wed, 24 Sep 2014 09:26:34 -0700
Message-ID: <20140924162634.GA16886@infradead.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-5-git-send-email-lixi@ddn.com>
 <20140924162507.GC27000@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140924162507.GC27000@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org, xfs@oss.sgi.com
List-Id: linux-api@vger.kernel.org

On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
> On Wed 24-09-14 22:04:30, Li Xi wrote:
> > This patch adds ioctl interface for setting/getting project of ext4.
>   The patch looks good to me. I was just wondering whether it won't be
> useful to add an ioctl() which isn't ext4 specific. We could just extend
> ->setattr() to allow setting of project ID (most filesystems would just
> return -EOPNOTSUPP but ext4 and xfs could do the right thing) and then call
> ->setattr from the generic ioctl. That way userspace won't have to care
> about filesystem type when setting project ID... What do others think?

Absolutely.  In general I also wonder why this patch doesn't implement
the full XFS API.  Maybe there is a reason it was considered and
rejected, but it would be helpful to document why.

