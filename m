From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 3/12] ext4: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Tue, 17 Feb 2015 12:02:20 +1100
Message-ID: <20150217010220.GH4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
 <1424101680-3301-4-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424101680-3301-4-git-send-email-linkinjeon@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:50AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_INSERT_RANGE for Ext4.
> 
> 1) Make sure that both offset and len are block size aligned.
> 2) Update the i_size of inode by len bytes.
> 3) Compute the file's logical block number against offset. If the computed
>    block number is not the starting block of the extent, split the extent
>    such that the block number is the starting block of the extent.
> 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
>    towards right by len bytes. This step will make a hole of len bytes
>    at offset.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

I'll leave this for the ext4 folk to review. If I don't get a review
by the time we're ready to merge the VFS and XFS code, then I'll
leave it out and let Ted merge it inhis own time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
