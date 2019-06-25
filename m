From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v5 16/16] f2fs: add fs-verity support
Date: Tue, 25 Jun 2019 15:55:57 +0800
Message-ID: <90495fb1-72eb-ca42-8457-ef8e969eda51@huawei.com>
References: <20190620205043.64350-1-ebiggers@kernel.org>
 <20190620205043.64350-17-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190620205043.64350-17-ebiggers@kernel.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 2019/6/21 4:50, Eric Biggers wrote:
> +static int f2fs_begin_enable_verity(struct file *filp)
> +{
> +	struct inode *inode = file_inode(filp);
> +	int err;
> +

I think we'd better add condition here (under inode lock) to disallow enabling
verity on atomic/volatile inode, as we may fail to write merkle tree data due to
atomic/volatile inode's special writeback method.

> +	err = f2fs_convert_inline_inode(inode);
> +	if (err)
> +		return err;
> +
> +	err = dquot_initialize(inode);
> +	if (err)
> +		return err;

We can get rid of dquot_initialize() here, since f2fs_file_open() ->
dquot_file_open() should has initialized quota entry previously, right?

Thanks,

> +
> +	set_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> +	return 0;
> +}
> +
