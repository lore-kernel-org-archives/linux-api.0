From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH RESEND 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Tue, 17 Feb 2015 10:49:37 +0900
Message-ID: <001301d04a53$fcd91310$f68b3930$@samsung.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
 <1424101680-3301-2-git-send-email-linkinjeon@gmail.com>
 <20150216235346.GD4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20150216235346.GD4251@dastard>
Content-language: ko
Sender: linux-fsdevel-owner@vger.kernel.org
To: 'Dave Chinner' <david@fromorbit.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, 'Namjae Jeon' <linkinjeon@gmail.com>
List-Id: linux-api@vger.kernel.org

> On Tue, Feb 17, 2015 at 12:47:48AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > FALLOC_FL_INSERT_RANGE command is the opposite command of
> > FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> > add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> > for writing new data within a file after shifting extents to right as given
> > length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> > that is block boundary and use ftruncate(2) for crosses EOF.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> >  fs/open.c                   |    8 +++++++-
> >  include/uapi/linux/falloc.h |   17 +++++++++++++++++
> >  2 files changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/open.c b/fs/open.c
> > index 813be03..762fb45 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -232,7 +232,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >
> >  	/* Return error if mode is not supported */
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_INSERT_RANGE))
> >  		return -EOPNOTSUPP;
> 
> Can we create a FALLOC_FL_SUPPORTED_MASK define in falloc.h
> so that we only need to add new flags to the mask in rather than
> change this code every time we add a new flag?
Sure, I will do it. and share the patch with the others you gave me review points soon.

Thanks for review!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

