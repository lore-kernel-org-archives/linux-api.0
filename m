From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 09:53:05 -0800
Message-ID: <20181112175305.GB15484@kroah.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
 <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
 <20181111111143.GB4189@1wt.eu>
 <87zhufvntw.fsf@oldenburg.str.redhat.com>
 <20181111120910.GA4425@1wt.eu>
 <alpine.DEB.2.21.1811121723210.6607@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1811121723210.6607@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Willy Tarreau <w@1wt.eu>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 12, 2018 at 05:36:11PM +0000, Joseph Myers wrote:
> What *is*, in my view, a bug in the uapi headers is that some of them 
> don't work when included on their own.  I'd expect #include 
> <linux/whatever.h> or #include <asm/whatever.h>, for any such header 
> installed by make headers_install, to compile on its own in userspace 
> without needing any other headers to be included first, unless some header 
> is specifically defined as being an internal part of another header which 
> is the one that should be included.

Yes, that is a bug, and people have been working on fixing that.  We now
have a new build target:
	make headers_check
to keep this all working properly.

Right now on Linus's latest tree I only see one failure when running
this:
	./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type without #include <linux/types.h>
so we are getting better.

If there are still problems with this, please let us know and we will be
glad to resolve them.

thanks,

greg k-h
