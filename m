From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Thu, 5 Nov 2015 22:45:12 +0800
Message-ID: <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
	<43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov@openvz.org>, Shuichi Ihara <ihashu@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 25, 2015 at 1:12 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Sep 13, 2015, at 2:20 PM, Li Xi <pkuelelixi@gmail.com> wrote:
>>
>> The following patches propose an implementation of project quota
>> support for ext4. A project is an aggregate of unrelated inodes
>> which might scatter in different directories. Inodes that belong
>> to the same project possess an identical identification i.e.
>> 'project ID', just like every inode has its user/group
>> identification. The following patches add project quota as
>> supplement to the former uer/group quota types.
>
> We discussed this on the ext4 developer concall today and tried to
> move the landing of these patches forward.  Some notes below:
>
> - Ted: agreed to reserve EXT4_FEATURE_RO_COMPAT_PROJECT, s_prj_quota_inum,
>   EXT4_PROJINHERIT_FL, and i_projid fields for use by project quota to
>   avoid compatibility issues if patches are not landed immediately.
>    - Ted: to do final check of inode flag value
>    - ext4 project quota inode does not need to use a reserved inode, but
>      could after Jan's patch to increase reserved inodes lands
> - Li Xi: identify xfstests subtests that are exercising project quota
>    - submit patches to xfstests that will activate them for ext4
>    - keep in ext4 xfstests for testing until patches land upstream
>    - this needs to be done before landing to ensure ext4 code works
> - Li Xi: document the behaviour of project quota (if no existing
>   document exists for XFS already), some of this is already below
>    - update man pages for df(1) and statfs(2) for subdir with project ID
>      (i.e. that it returns only quota usage and limit for project ID)
>    - Ted: where should document go? linux/Documentation/fs? ext4 wiki?
>    - not a requirement for testing, can be done after landing
>
> - All: decide on a common tool for setting project ID on file/directory
>    - don't want to require xfsutils in order to use project quota
>    - start with chattr (using FS_IOC_FS{GET,SET}XATTR) in e2fsprogs
>      - allows testing project quota with e2fsprogs/ext4
>    - chproj (like chown/chgrp) would also be an option
>      - needs more discussion/development effort, goes into fileutils
>    - this doesn't need to be decided immediately, and both could be done
>
Hi,

I've pushed the patch of Ext4 as well as e2fsprogs. Shilong has added test
suits for ext4 project quota in xfstest, and will push patches soon. I
will write
necessary documentation both for manual and linux/Documentation/fs.

Hopefully, at least the kernel patches of ext4 project quota will be merged
soon.

Regards,
Li Xi
