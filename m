From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/9] vfs: add copy_file_range syscall and vfs helper
Date: Tue, 22 Sep 2015 14:27:51 -0400
Message-ID: <56019DA7.90409@Netapp.com>
References: <1442003423-6884-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1442003423-6884-2-git-send-email-Anna.Schumaker@Netapp.com>
 <20150922114404.GF8891@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150922114404.GF8891-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dsterba-AlSwsSmVLrQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/22/2015 07:44 AM, David Sterba wrote:
> On Fri, Sep 11, 2015 at 04:30:14PM -0400, Anna Schumaker wrote:
>> From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> +/*
>> + * copy_file_range() differs from regular file read and write in that it
>> + * specifically allows return partial success.  When it does so is up to
>> + * the copy_file_range method.
>> + */
>> +ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>> +			    struct file *file_out, loff_t pos_out,
>> +			    size_t len, int flags)
> 
> Is the signed type for flags correct? I had the impression that it's
> usually good to have unsigned int/long for flags, this can be seen
> frequently in the vfs/fs code. Mainly for consistency.

I'm all for consistency!  I'll change the function to take an unsigned int.

Thanks,
Anna

> 
>> +	ret = file_in->f_op->copy_file_range(file_in, pos_in, file_out, pos_out,
>> +					     len, flags);
> 
> int -> unsigned int
> 
>> +}
>> +EXPORT_SYMBOL(vfs_copy_file_range);
>> +
>> +SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>> +		int, fd_out, loff_t __user *, off_out,
>> +		size_t, len, unsigned int, flags)
> 
> the syscal takes unsigned int
> 
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1642,6 +1642,7 @@ struct file_operations {
>>  #ifndef CONFIG_MMU
>>  	unsigned (*mmap_capabilities)(struct file *);
>>  #endif
>> +	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, int);
> 
> switch to unsigned
> 
>> +extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
>> +				   loff_t, size_t, int);
> 
> and here
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
