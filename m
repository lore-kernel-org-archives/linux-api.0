From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/3] Add preadv and pwritev system calls.
Date: Thu, 18 Dec 2008 14:37:57 +0100
Message-ID: <494A5235.6090502@redhat.com>
References: <1229600542-11585-1-git-send-email-kraxel@redhat.com> <1229600542-11585-3-git-send-email-kraxel@redhat.com> <200812181334.33719.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200812181334.33719.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

  Hi,

> Please remember to add the function prototypes to
> include/linux/syscalls.h.

Done.

>> +asmlinkage ssize_t
>> +compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
>> +                  unsigned long vlen, u32 pos_high, u32 pos_low)
>> +{.
>> +        loff_t pos = ((loff_t)pos_high << 32) | pos_low;
> 
> This is whitespace damaged, as are the other four functions in the
> same place.

Fixed.

>> +	struct file *file;
>> +	ssize_t ret = -EBADF;
>> +
>> +	if (pos < 0)
>> +		return -EINVAL;
>> +
>> +	file = fget(fd);
>> +	if (!file)
>> +		return -EBADF;
> 
> Any reason for using fget() here, but fget_light() in sys_preadv?

Due to the new syscalls being derived from the readv()/preadv()
versions, which have the same inconsistency.  Dunno why.  I'd suspect
the reason is that the compat syscalls tend to be overlooked when the
code is updated.  Proof: patch #1 in this series ...

I'll switch them all over in a separate followup patch.

>> +	if (!(file->f_mode & FMODE_READ))
>> +		goto out;
>> +
>> +	ret = -EINVAL;
>> +	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
>> +		goto out;
> 
> Maybe this logic could get moved into a compat_readv() function,
> similar to vfs_readv().

Yes, makes sense.

cheers,
  Gerd


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
