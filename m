From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 3/3] f2fs: Support case-insensitive file
 name lookups
Date: Mon, 29 Jul 2019 22:57:00 +0800
Message-ID: <fe7066e9-f299-c675-cec3-919cdabe18ce@kernel.org>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-4-drosen@google.com>
 <9362e4ed-2be8-39f5-b4d9-9c86e37ab993@kernel.org>
 <20190729062735.GA98839@jaegeuk-macbookpro.roam.corp.google.com>
 <fa07a09d-92c9-4e0b-7c2b-e87771273dce@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fa07a09d-92c9-4e0b-7c2b-e87771273dce@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Daniel Rosenberg <drosen@google.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com
List-Id: linux-api@vger.kernel.org

On 2019-7-29 15:22, Chao Yu wrote:
> On 2019/7/29 14:27, Jaegeuk Kim wrote:
>> On 07/28, Chao Yu wrote:
>>> On 2019-7-24 7:05, Daniel Rosenberg via Linux-f2fs-devel wrote:
>>>>  /* Flags that are appropriate for regular files (all but dir-specific ones). */
>>>>  #define F2FS_REG_FLMASK		(~(F2FS_DIRSYNC_FL | F2FS_PROJINHERIT_FL))
>>>
>>> We missed to add F2FS_CASEFOLD_FL here to exclude it in F2FS_REG_FLMASK.
>>
>> Applied.
>>
>>>
>>>> @@ -1660,7 +1660,16 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
>>>>  		return -EPERM;
>>>>  
>>>>  	oldflags = fi->i_flags;
>>>> +	if ((iflags ^ oldflags) & F2FS_CASEFOLD_FL) {
>>>> +		if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
>>>> +			return -EOPNOTSUPP;
>>>> +
>>>> +		if (!S_ISDIR(inode->i_mode))
>>>> +			return -ENOTDIR;
>>>>  
>>>> +		if (!f2fs_empty_dir(inode))
>>>> +			return -ENOTEMPTY;
>>>> +	}
>>
>> Modified like this:
>> @@ -1665,6 +1665,13 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
>>         if (IS_NOQUOTA(inode))
>>                 return -EPERM;
>>
>> +       if ((iflags ^ fi->i_flags) & F2FS_CASEFOLD_FL) {
>> +               if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
>> +                       return -EOPNOTSUPP;
>> +               if (!f2fs_empty_dir(inode))
>> +                       return -ENOTEMPTY;
>> +       }
>> +
>>
>> Note that, directory is checked by above change.
>>
>> I've uploaded in f2fs.git, so could you check it out and test a bit?
> 
> I've checked it out, it looks good to me now, and later I will test this new
> version.
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>

It can pass generic/556 as well.

Thanks,

> 
> Thanks,
> 
>>
>> Thanks,
>>
>>>
>>> I applied the patches based on last Jaegeuk's dev branch, it seems we needs to
>>> adjust above code a bit. Otherwise it looks good to me.
>>>
>>> BTW, it looks the patchset works fine with generic/556 testcase.
>>>
>>> Thanks,
>> .
>>
