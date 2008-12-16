From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Tue, 16 Dec 2008 17:48:58 +0100
Message-ID: <4947DBFA.9050108@redhat.com>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com> <20081216160502.GA15331@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081216160502.GA15331-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Ralf Baechle wrote:
> On Mon, Dec 15, 2008 at 09:57:24PM +0100, Gerd Hoffmann wrote:
> 
>>> It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
>>> will pass the 64-bit argument in two registers but the 64-bit kernel code
>>> will assume it to be passed in a single registers.  It'd be ugly but passing
>>> a pointer to a 64-bit argument would solve the issue; something like this:
>>>
>>> sys_preadv(unsigned long fd, const struct iovec __user *vec,
>>>                   unsigned long vlen, loff_t __user *pos);
>>> compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
>>>                   unsigned long vlen, loff_t __user *pos);
>> Suggestion from the s390 front was to explicitly pass high and low part
>> of pos as two arguments.  A bit ugly too, but should work fine as well
>> and it avoids the user pointer dereference.  What do you think about this?
> 
> That's what the wrapper which you deleted, was doing ;-)  So yes, I like
> it.

Yep, but I'm trying to find a way to have it work without per-arch
wrappers ...

> It just raises one new problem, endianess - are arguments being passed
> as low/high or high/low?  On MIPS we've been solving the issue with the
> merge_64() macro which is defined depending on the byte order:
> 
> #ifdef __MIPSEB__
> #define merge_64(r1, r2) ((((r1) & 0xffffffffUL) << 32) + ((r2) & 0xffffffffUL))
> #endif
> #ifdef __MIPSEL__
> #define merge_64(r1, r2) ((((r2) & 0xffffffffUL) << 32) + ((r1) & 0xffffffffUL))
> #endif
> 
> The actual syscall wrapper could use it like:
> 
> asmlinkage int compat_sys_pwritev(unsigned long fd,
>        const struct compat_iovec __user *vec,
>        unsigned a3, unsigned a4, unsigned long vlen)
> {
> 	loff_t offset = merge_64(a3, a4);
> ...

i.e. the ordering of the splitted argument depends on the os endianness?
What is the reason for this?

I'd prefer to have the ordering coded explicitly instead, like this:

asmlinkage int compat_sys_pwritev(unsigned long fd,
       const struct compat_iovec __user *vec, unsigned long vlen,
       unsigned pos_low, unsigned pos_high)
{
	loff_t pos = pos_low | (loff_t)pos_high << 32;
        [ ... ]

cheers,
  Gerd


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
