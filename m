From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 4/12] xfsprog: xfsio: update xfs_io manpage for
 FALLOC_FL_INSERT_RANGE
Date: Tue, 17 Feb 2015 11:56:00 +1100
Message-ID: <20150217005600.GF4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
 <1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:51AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks good. That'll fix up the complaining fstest ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave
-- 
Dave Chinner
david@fromorbit.com
