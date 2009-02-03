From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: + preadv-pwritev-add-preadv-and-pwritev-system-calls.patch added
 to -mm tree
Date: Tue, 03 Feb 2009 09:29:24 -0800
Message-ID: <49887EF4.1090300@zytor.com>
References: <200902022135.n12LZa1a010673@imap1.linux-foundation.org> <49876A91.4000705@zytor.com> <49881904.30705@redhat.com> <498879B3.8030002@zytor.com> <20090203171559.GA20898@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090203171559.GA20898-f404yB8NqCZvn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch@vger.k
List-Id: linux-api@vger.kernel.org

Russell King wrote:
>>
>> All in all, I think it is WRONG to make sane architectures suffer for
>> what broken architectures have to do, and we should implement this the
>> sane way without any shuffling, splitting, or other braindamage.
> 
> Disagree.  What is better: having _one_ _common_ argument order in the
> syscall interface, or having architectures end up doing their own thing?
> 
> Think about your strace argument - you're effectively requiring strace
> to know that on architecture X, the syscall argument order is X1, but
> on architecture Y, that same syscall has argument order Y1, and maybe
> architecture Z, it's again a different order Z1.
> 
> That _adds_ complexity to strace - rather than having one ordering to
> deal with for a syscall, it now has three different random orders.
> 
> That's completely insane.  With one _common_ ordering, at least strace
> has the possibility of cleanly sorting it out.
> 

What we *SHOULD* be doing is to *HAVE ABIS RULE AND STICK TO THEM*.
Which is that on architectures that need a padding register, we add the
padding register on those architectures, and if they need stubs, then we
add stubs -- preferrably by automation (c.f. my automation scripts for
doing exactly that.)

What we *SHOULDN'T DO* is hand-craft the ABI of every system call to
avoid the rules we happen to have already set for ourselves.  If the
rules are too inflexible, they should be sanitized, not worked around.

The sheer number of system calls with weird exceptions to the ABI is a
total mess, and for absolutely no good reason.  All it means is an
exception which last forever, because no amount of automation in the
world can fix it once it is in.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
