From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 03 Apr 2009 21:57:22 +0200
Message-ID: <49D66A22.7090909@redhat.com>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain> <49D5CA58.20908@redhat.com> <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
Sender: linux-arch-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, arnd@arndb.de, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, ralf@linux-mips.org, tglx@linutronix.de, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote:
>  - I changed the order to "low first". Why? Because when we have it like 
>    this, the 64-bit system calls now don't use the "pos_high" argument at 
>    all, and it makes more sense for the native system call to simply match 
>    the user-mode prototype.

Good idea.

> problems if we ever do 128-bit loff_t). So the user call wrapper isn't 
> really any more complicated - the HALF_BITS thing may look more 
> complicated than just doing a hard-coded '16' there twice, but if you 
> understand what it's doing it's actually more logical.

The whole point of the HALF_BITS thing is just to kill the gcc "hey your
shift is greater than bitsize of $type" warning, right?

> I think.
> 
> Comments?

I really like it.  Except for the low/high ordering it is basically
identical to the patch I've mailed.

While hashing out all the issues I've learned alot about arch specific
ABIs.  I can't see possible trouble spots and don't expect vetos from
arch maintainers.

cheers,
  Gerd
