From: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Mon, 15 Dec 2008 16:03:11 +0000
Message-ID: <20081215160311.GA23153@linux-mips.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1229340977-24345-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 15, 2008 at 12:36:14PM +0100, Gerd Hoffmann wrote:

> Next revision of the patch series, with the alignment issue fixed by
> swapping the last two arguments as suggested by arch maintainers.
> 
> I've dropped the now-obsolete wrappers for mips.  Ralf, please
> double-check.

It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
will pass the 64-bit argument in two registers but the 64-bit kernel code
will assume it to be passed in a single registers.  It'd be ugly but passing
a pointer to a 64-bit argument would solve the issue; something like this:

sys_preadv(unsigned long fd, const struct iovec __user *vec,
                  unsigned long vlen, loff_t __user *pos);
compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
                  unsigned long vlen, loff_t __user *pos);

sys_splice uses loff_t __user * arguments as well and that's why it's
doesn't need any compat wrapper.

I'm surprised this works for x86; does x86-64 code really expect 64-bit
arguments as 2 32-bit arguments?

Patch 1/3 looks like it's a bug fix and you may want to submit this
separate from the remainder of the series for 2.6.28?

  Ralf
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
