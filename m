From: Thanos Makatos <thanos.makatos@citrix.com>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Fri, 3 Oct 2014 09:00:14 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0423DEE4@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141003052737.GL24490@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141003052737.GL24490@dastard>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: 'Dave Chinner' <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "bfields@fieldses.org" <bfields@fieldses.org>, "jack@suse.cz" <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

> > > This patch introduces a new ioctl called BLKFLUSHBUFS2, which is
> > > pretty
> 
> What a horrible name. Whatever happened to naming ioctls interfaces after
> their function? i.e. BLKFLUSHINVAL?

Indeed it's not a good name, I'm open to suggestions!
