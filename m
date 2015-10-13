From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Tue, 13 Oct 2015 15:45:28 -0400
Message-ID: <561D5F58.8030105@Netapp.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <87vbai6sud.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87vbai6sud.fsf-wvvUuzkyo1HefUI2i7LXDhCRmIWqnp/j@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Brown <nfbrown-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/07/2015 09:40 PM, Neil Brown wrote:
> Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> writes:
> 
>> @@ -1338,34 +1362,26 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>>  			    struct file *file_out, loff_t pos_out,
>>  			    size_t len, unsigned int flags)
>>  {
>> -	struct inode *inode_in;
>> -	struct inode *inode_out;
>>  	ssize_t ret;
>>  
>> -	if (flags)
>> +	/* Flags should only be used exclusively. */
>> +	if ((flags & COPY_FR_COPY) && (flags & ~COPY_FR_COPY))
>> +		return -EINVAL;
>> +	if ((flags & COPY_FR_REFLINK) && (flags & ~COPY_FR_REFLINK))
>> +		return -EINVAL;
>> +	if ((flags & COPY_FR_DEDUP) && (flags & ~COPY_FR_DEDUP))
>>  		return -EINVAL;
>>  
> 
> Do you also need:
> 
>    if (flags & ~(COPY_FR_COPY | COPY_FR_REFLINK | COPY_FR_DEDUP))
>    	return -EINVAL;
> 
> so that future user-space can test if the kernel supports new flags?

Probably.  I'll add that in!

Thanks,
Anna

> 
> NeilBrown
> 
