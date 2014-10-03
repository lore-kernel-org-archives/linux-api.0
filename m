From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Fri, 3 Oct 2014 15:27:37 +1000
Message-ID: <20141003052737.GL24490@dastard>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <542DAEAC.8010203@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Thanos Makatos <thanos.makatos@citrix.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jlayton@poochiereds.net, bfields@fieldses.org, jack@suse.cz
List-Id: linux-api@vger.kernel.org

On Thu, Oct 02, 2014 at 01:59:40PM -0600, Jens Axboe wrote:
> On 10/02/2014 10:09 AM, Thanos Makatos wrote:
> > This patch introduces a new ioctl called BLKFLUSHBUFS2, which is pretty

What a horrible name. Whatever happened to naming ioctls interfaces
after their function? i.e. BLKFLUSHINVAL?

Cheers,

Dave?

-- 
Dave Chinner
david@fromorbit.com
