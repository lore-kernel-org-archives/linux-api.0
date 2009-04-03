From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 3 Apr 2009 13:08:59 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904031303200.4015@localhost.localdomain>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain> <49D5CA58.20908@redhat.com> <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain> <49D66A22.7090909@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49D66A22.7090909-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Fri, 3 Apr 2009, Gerd Hoffmann wrote:
> 
> The whole point of the HALF_BITS thing is just to kill the gcc "hey your
> shift is greater than bitsize of $type" warning, right?

No, it's literally a corectness issue.

If you do

	offset = ((loff_t) high) << BITS_IN_LONG;

then that is literally undefined behavior in C (if "loff_t" and "long" are 
the same size), and a lot of C compilers will end up just optimizing it 
away entirely.

Even if they don't optimize it away, and if they actually generate the 
instruction for it, architectures will not actually do what you think they 
do. At least on x86, shift counts are fundamentally limited to the low 
bits, so if you do 

	movl $64,%ecx
	shlq %ecx,reg

then an x86 will literally shift 'reg' by _zero_, because the count is 
masked by 6 bits (or 5, in the 32-bit case).

So literally, if gcc were to generate the obvious (stupid) code, it would 
give the wrong value.

With the double shift, we have well-defined behavior.

> I really like it.  Except for the low/high ordering it is basically
> identical to the patch I've mailed.
> 
> While hashing out all the issues I've learned alot about arch specific
> ABIs.  I can't see possible trouble spots and don't expect vetos from
> arch maintainers.

Ok, a few more ack's, and I can commit it. Anybody disagree?

			Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
