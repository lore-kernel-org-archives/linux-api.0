From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support
Date: Fri, 23 Jan 2015 14:58:09 +0300
Message-ID: <54C23751.7000009@yandex-team.ru>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com> <1418102548-5469-5-git-send-email-lixi@ddn.com> <54C11733.7080801@yandex-team.ru> <20150123015307.GD24722@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150123015307.GD24722@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On 23.01.2015 04:53, Dave Chinner wrote:
> On Thu, Jan 22, 2015 at 06:28:51PM +0300, Konstantin Khlebnikov wrote:
>> On 09.12.2014 08:22, Li Xi wrote:
>>> +static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>>> +{
>>> +	struct inode *inode = file_inode(filp);
>>> +	struct super_block *sb = inode->i_sb;
>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>> +	int err;
>>> +	handle_t *handle;
>>> +	kprojid_t kprojid;
>>> +	struct ext4_iloc iloc;
>>> +	struct ext4_inode *raw_inode;
>>> +
>>> +	struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
>>> +
>>> +	/* Make sure caller can change project. */
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return -EACCES;
>>> +
>>> +	if (projid != EXT4_DEF_PROJID
>>> +	    && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
>>> +			EXT4_FEATURE_RO_COMPAT_PROJECT))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>>> +			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
>>> +		BUG_ON(__kprojid_val(EXT4_I(inode)->i_projid)
>>> +		       != EXT4_DEF_PROJID);
>>> +		if (projid != EXT4_DEF_PROJID)
>>> +			return -EOPNOTSUPP;
>>> +		else
>>> +			return 0;
>>> +	}
>>> +
>>> +	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
>>
>> Maybe current_user_ns()?
>> This code should be user-namespace aware from the beginning.
>
> No, the code is correct. Project quotas have nothing to do with
> UIDs and so should never have been included in the uid/gid
> namespace mapping infrastructure in the first place.

Right, but user-namespace provides id mapping for project-id too.
This infrastructure adds support for nested project quotas with
virtualized ids in sub-containers. I couldn't say that this is
must have feature but implementation is trivial because whole
infrastructure is already here.

>
> Point in case: directory subtree quotas can be used as a resource
> controller for limiting space usage within separate containers that
> share the same underlying (large) filesystem via mount namespaces.

That's exactly my use-case: 'sub-volumes' for containers with
quota for space usage/inodes count.
