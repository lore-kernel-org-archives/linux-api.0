From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v8 2/5] ext4: adds project ID support
Date: Thu, 8 Jan 2015 15:20:21 -0700
Message-ID: <2EE35986-B398-432E-92D4-EEF875381319@dilger.ca>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com> <1418102548-5469-3-git-send-email-lixi@ddn.com> <20150108082625.GA15339@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20150108082625.GA15339@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Li Xi <pkuelelixi@gmail.com>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, ext4 development <linux-ext4@vger.kernel.org>, linux-api@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Jan 8, 2015, at 1:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 09-12-14 13:22:25, Li Xi wrote:
>> This patch adds a new internal field of ext4 inode to save project
>> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
>> inheriting project ID from parent directory.
>  I have noticed one thing you apparently changed in v7 of the patch set.
> See below.
> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 29c43e7..8bd1da9 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -377,16 +377,18 @@ struct flex_groups {
>> #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
>> #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
>> #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
>> +#define EXT4_PROJINHERIT_FL		FS_PROJINHERIT_FL /* Create with parents projid */
>  How did FS_PROJINHERIT_FL get here? There used to be 0x20000000 in older
> version of the patch set which is correct - this definition is defining
> ext4 on-disk format. As such it is an ext4 specific flag and should be
> definined to a fixed constant independed of any other filesystem. It seems
> you are somewhat mixing what is an on-disk format flag value and what is a
> flag value passed from userspace. These two may be different things and
> you need to convert between the values when getting / setting flags...

Currently the EXT4_*_FL and FS_*_FL values are all identical, and there
is no reason to change that before it is actually needed.  Since the
FS_PROJINHERIT_FL is used via chattr/lsattr from userspace, this value
must also be kept the same in the future to avoid API breakage, so there
is no reason to worry about incompatibilities.

See also the [v8 5/5] patch, which is changing the EXT4_*_FL values to
use FS_*_FL constants, where applicable, so that it is more clear that
these values need to be the same.

Cheers, Andreas





