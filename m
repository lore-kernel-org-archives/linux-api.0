From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH RESEND 11/12] xfstests: fsx: Add fallocate insert range
 operation
Date: Tue, 17 Feb 2015 10:43:52 +0900
Message-ID: <001101d04a53$2ed730a0$8c8591e0$@samsung.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
 <1424101680-3301-12-git-send-email-linkinjeon@gmail.com>
 <20150217010033.GG4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150217010033.GG4251@dastard>
Content-language: ko
Sender: linux-kernel-owner@vger.kernel.org
To: 'Dave Chinner' <david@fromorbit.com>, 'Namjae Jeon' <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> 
> On Tue, Feb 17, 2015 at 12:47:58AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  ltp/fsx.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 114 insertions(+), 10 deletions(-)
> .....
> > @@ -339,6 +341,14 @@ logdump(void)
> >  						     lp->args[0] + lp->args[1])
> >  				prt("\t******CCCC");
> >  			break;
> > +		case OP_INSERT_RANGE:
> > +			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
> > +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> > +			    lp->args[1]);
> > +			if (badoff >= lp->args[0] && badoff <
> > +						     lp->args[0] + lp->args[1])
> > +				prt("\t******CCCC");
> 
Hi Dave,
> Probably should output "*****IIII" so we can distinguish it from
> collapse operations easily.
Right. I will change it.
> 
> > @@ -1307,6 +1403,9 @@ usage(void)
> >  #ifdef FALLOC_FL_COLLAPSE_RANGE
> >  "	-C: Do not use collapse range calls\n"
> >  #endif
> > +#ifdef FALLOC_FL_INSERT_RANGE
> > +"	-i: Do not use insert range calls\n"
> > +#endif
> 
> I'd make that "-I" rather than "-i" so it matches with the "-C" of
> collapse range.
Okay.

Thanks for your review!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
