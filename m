From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Mon, 9 Nov 2015 08:28:30 +1100
Message-ID: <20151108212830.GL19199@dastard>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
 <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
 <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7360A48E-8576-49DB-878B-DFC2EFC83BC4-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuichi Ihara <sihara-LfVdkaOWEx8@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shuichi Ihara <ihashu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 05, 2015 at 03:13:10PM +0000, Shuichi Ihara wrote:
> Hello Ted, Andreas,
> 
> Shilong posted an email here a week ago below.
> http://lists.openwall.net/linux-ext4/2015/10/30/2
> 
> we identified 10 project quota related xfstest and ported them into ext4/xxx.
> test number are 304, 305, 299, 244, 196, 134, 108, 107, 106, 050 in xfs.
> 
> 
> We ported 9/10 tests into ext4/xxx
> ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299 ext4/400 ext4/401

Please make them generic tests - the ext4 project quota
functioanlity should work with those tests being completely
unchanged except for a "_requires_project_quota()" function...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
