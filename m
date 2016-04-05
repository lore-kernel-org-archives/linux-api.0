From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 06/10] sysctl: drop away useless label
Date: Tue, 5 Apr 2016 15:17:52 -0700
Message-ID: <20160405151752.de82f221f1c70ff901b2b958@linux-foundation.org>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1459864579-55988-7-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459864579-55988-7-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue,  5 Apr 2016 16:56:15 +0300 Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> We have no locking in bin_uuid(). Thus, we may remove the out label and use
> return statements directly.
> 
> ...
>
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -1123,15 +1123,14 @@ static ssize_t bin_uuid(struct file *file,
>  
>  		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
>  		if (result < 0)
> -			goto out;
> +			return result;
>  
>  		buf[result] = '\0';
>  
>  		/* Convert the uuid to from a string to binary */
>  		for (i = 0; i < 16; i++) {
> -			result = -EIO;
>  			if (!isxdigit(str[0]) || !isxdigit(str[1]))
> -				goto out;
> +				return -EIO;
>  
>  			uuid[i] = (hex_to_bin(str[0]) << 4) |
>  					hex_to_bin(str[1]);
> @@ -1143,15 +1142,12 @@ static ssize_t bin_uuid(struct file *file,
>  		if (oldlen > 16)
>  			oldlen = 16;
>  
> -		result = -EFAULT;
>  		if (copy_to_user(oldval, uuid, oldlen))
> -			goto out;
> +			return -EFAULT;
>  
>  		copied = oldlen;
>  	}
> -	result = copied;
> -out:
> -	return result;
> +	return copied;
>  }

Sure, but we may add locking or resource allocation in the future, in
which case this change will need to be undone.  I think it's better to
leave the code as-is.  It's presently quite typical kernel code.
