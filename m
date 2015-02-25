From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH v10 10/12] xfstests: fsstress: Add fallocate insert range
 operation
Date: Wed, 25 Feb 2015 13:15:49 +0900
Message-ID: <003201d050b1$bcae7e10$360b7a30$@samsung.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
 <1424533554-28024-11-git-send-email-linkinjeon@gmail.com>
 <20150225030451.GG4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20150225030451.GG4251@dastard>
Content-language: ko
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Dave Chinner' <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: tytso-3s7WtUTddSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Namjae Jeon' <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> On Sun, Feb 22, 2015 at 12:45:52AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> >
> > This commit adds insert operation support for fsstress, which is
> > meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.
> 
> This causes xfs/068 to fail because it changes the file creation
> pattern that results from a specific fsstress random seed. As such,
> I added this to xfs/068:
> 
> FSSTRESS_AVOID="-f insert=0 $FSSTRESS_AVOID"
> 
> To turn off the insert operation for that test and hence produce the
> expected tree of files.
Thanks for your notice :) I will check other TCs as well as insert range
TC next time.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
