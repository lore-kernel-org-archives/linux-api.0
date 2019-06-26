From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v5 16/16] f2fs: add fs-verity support
Date: Wed, 26 Jun 2019 15:34:35 +0800
Message-ID: <68c5a15f-f6a8-75e2-b485-0f1b51471995@huawei.com>
References: <20190620205043.64350-1-ebiggers@kernel.org>
 <20190620205043.64350-17-ebiggers@kernel.org>
 <90495fb1-72eb-ca42-8457-ef8e969eda51@huawei.com>
 <20190625175225.GC81914@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190625175225.GC81914@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 2019/6/26 1:52, Eric Biggers wrote:
> Hi Chao, thanks for the review.
> 
> On Tue, Jun 25, 2019 at 03:55:57PM +0800, Chao Yu wrote:
>> Hi Eric,
>>
>> On 2019/6/21 4:50, Eric Biggers wrote:
>>> +static int f2fs_begin_enable_verity(struct file *filp)
>>> +{
>>> +	struct inode *inode = file_inode(filp);
>>> +	int err;
>>> +
>>
>> I think we'd better add condition here (under inode lock) to disallow enabling
>> verity on atomic/volatile inode, as we may fail to write merkle tree data due to
>> atomic/volatile inode's special writeback method.
>>
> 
> Yes, I'll add the following:
> 
> 	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
> 		return -EOPNOTSUPP;
> 
>>> +	err = f2fs_convert_inline_inode(inode);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	err = dquot_initialize(inode);
>>> +	if (err)
>>> +		return err;
>>
>> We can get rid of dquot_initialize() here, since f2fs_file_open() ->
>> dquot_file_open() should has initialized quota entry previously, right?
> 
> We still need it because dquot_file_open() only calls dquot_initialize() if the
> file is being opened for writing.  But here the file descriptor is readonly.
> I'll add a comment explaining this here and in the ext4 equivalent.

Ah, you're right.

f2fs_convert_inline_inode() may grab one more block during conversion, so we
need to call dquot_initialize() before inline conversion?

Thanks,

> 
> - Eric
> .
> 
