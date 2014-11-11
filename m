From: Jan Kara <jack@suse.cz>
Subject: Re: [v6 2/4] ext4: adds project ID support
Date: Tue, 11 Nov 2014 21:23:02 +0100
Message-ID: <20141111202302.GA32298@quack.suse.cz>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
 <1415468619-31851-3-git-send-email-lixi@ddn.com>
 <20141111042606.GA17027@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141111042606.GA17027@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Mon 10-11-14 23:26:06, Ted Tso wrote:
> On Sun, Nov 09, 2014 at 01:43:37AM +0800, Li Xi wrote:
> > This patch adds a new internal field of ext4 inode to save project
> > identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> > inheriting project ID from parent directory.
> 
> What would be the downside of simply always inhereiting the project ID
> from the parent directory?  I see that if the flag is not set, the
> project id will be 0 instead.  I'm not sure when that would actually
> be desirable.
  Well, 0 is a fallback project ID effectively meaning "not accounted in
project quota".

> To the extent that the project ID is designed to implement a quota
> over a directory extent, the fact that the owner can clear the
> EXT4_PROJINHERET_FL and then arrange to have the quota charged to
> project 0 seems to me to be a bug, not a feature.
> 
> Can you explain what your intended use case for this flag might be?
  So I agree that for directory quotas there's no reason not to inherit the
project ID. But there might be other use cases and I strongly prefer to
stay compatible with XFS as far as reasonably possible to make life for
userspace simpler.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
