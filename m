From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [v6 2/4] ext4: adds project ID support
Date: Mon, 10 Nov 2014 23:26:06 -0500
Message-ID: <20141111042606.GA17027@thunk.org>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
 <1415468619-31851-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415468619-31851-3-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Nov 09, 2014 at 01:43:37AM +0800, Li Xi wrote:
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.

What would be the downside of simply always inhereiting the project ID
from the parent directory?  I see that if the flag is not set, the
project id will be 0 instead.  I'm not sure when that would actually
be desirable.

To the extent that the project ID is designed to implement a quota
over a directory extent, the fact that the owner can clear the
EXT4_PROJINHERET_FL and then arrange to have the quota charged to
project 0 seems to me to be a bug, not a feature.

Can you explain what your intended use case for this flag might be?

Thanks,

						- Ted
