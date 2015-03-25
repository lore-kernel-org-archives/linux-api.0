From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v10 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Wed, 25 Mar 2015 17:05:52 +1100
Message-ID: <20150325060552.GY28621@dastard>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
 <1424533554-28024-2-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424533554-28024-2-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tytso-3s7WtUTddSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 22, 2015 at 12:45:43AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> 
> FALLOC_FL_INSERT_RANGE command is the opposite command of
> FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> for writing new data within a file after shifting extents to right as given
> length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> that is block boundary and use ftruncate(2) for crosses EOF.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Folks, I have merged this into the xfs tree for the 4.1 merge
window. It is under the stable branch "fallocate-insert-range"
in the tree here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

an dis currently included in the for-next branch that is included in
the linux-next tree. I have not included the ext4 kernel support
patch in this branch (patch 3) because I have not seen any reviews
from ext4 developers for it.

Ted, if you want to include that patch in you ext4 tree, feel free
to base it on the above branch, or if you give your  sob or
reviewed-by ok I can pull it into my tree. I'll leave it up to you
to determine how you want to deal with this.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
