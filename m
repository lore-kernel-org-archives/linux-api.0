From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: Re: [PATCH v1 4/8] btrfs: Add mountpoint checking during
 btrfs_copy_file_range
Date: Wed, 9 Sep 2015 11:56:12 -0400
Message-ID: <55F0569C.5030904@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1441397823-1203-5-git-send-email-Anna.Schumaker@Netapp.com>
 <20150909091838.GE8891@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20150909091838.GE8891@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
To: dsterba@suse.cz, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On 09/09/2015 05:18 AM, David Sterba wrote:
> On Fri, Sep 04, 2015 at 04:16:58PM -0400, Anna Schumaker wrote:
>> We need to verify that both the source and the destination files are
>> part of the same filesystem, otherwise we can't create a reflink.
>>
>> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
>> ---
>>  fs/btrfs/ioctl.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 62ae286..9c0c955 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3856,6 +3856,10 @@ ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
>>  {
>>  	ssize_t ret;
>>  
>> +	if (inode_in->i_sb != inode_out->i_sb ||
>> +	    file_in->f_path.mnt != file_out->f_path.mnt)
>> +		return -EXDEV;
> 
> The same check exists in btrfs_clone_files (added in the previous
> patch), what's the reason to add it here again?

To be really, really sure that it's not a cross-device copy?  :)

In reality, it was an oversight and I'll drop the patch.  Thanks for letting me know!

Anna

> 
>> +
>>  	ret = btrfs_clone_files(file_out, file_in, pos_in, len, pos_out);

