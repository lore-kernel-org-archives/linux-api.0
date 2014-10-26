From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v5 4/5] Adds ioctl interface support for ext4 project
Date: Mon, 27 Oct 2014 08:57:43 +1100
Message-ID: <20141026215743.GD4317@dastard>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
 <1414300973-1118-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414300973-1118-5-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 26, 2014 at 01:22:52PM +0800, Li Xi wrote:
> This patch adds ioctl interface for setting/getting project of ext4.

If you add support for the XFS_IOC_[GS]ETXATTR ioctls, then this
patch needs to be dropped - we don't want (or need) multiple
interfaces to perform the same functionality.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
