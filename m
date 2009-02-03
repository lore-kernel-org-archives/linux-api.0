From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: + preadv-pwritev-add-preadv-and-pwritev-system-calls.patch added
 to -mm tree
Date: Tue, 03 Feb 2009 11:14:28 +0100
Message-ID: <49881904.30705@redhat.com>
References: <200902022135.n12LZa1a010673@imap1.linux-foundation.org> <49876A91.4000705@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49876A91.4000705-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

H. Peter Anvin wrote:
> akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
>>
>> This prototype has one problem though: On 32bit archs is the (64bit)
>> offset argument unaligned, which the syscall ABI of several archs doesn't
>> allow to do.  At least s390 needs a wrapper in glibc to handle this.  As
>> we'll need a wrappers in glibc anyway I've decided to push problem to
>> glibc entriely and use a syscall prototype which works without
>> arch-specific wrappers inside the kernel: The offset argument is
>> explicitly splitted into two 32bit values.
> 
> That rather sucks.  It'd be cleaner to just shuffle the argument order.

That was discussed too.  Doesn't solve the problem that you need some
wrap-o-magic in glibc (this time to swap arguments instead of splitting
the offset).  And is has the drawback that it is confusing to have
different argument ordering at application and syscall level (think
strace).  Check the archives for the details.

cheers,
  Gerd

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
