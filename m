From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 45/45] include/uapi/asm-generic/ucontext.h: include
 signal.h and sigcontext.h
Date: Wed, 11 Mar 2015 03:59:31 +0200
Message-ID: <20150311015931.GG12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-46-git-send-email-mikko.rapeli@iki.fi>
 <3121580.utRRJPcIC6@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3121580.utRRJPcIC6@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 10:10:42AM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 00:05:48 Mikko Rapeli wrote:
> >  #ifndef __ASM_GENERIC_UCONTEXT_H
> >  #define __ASM_GENERIC_UCONTEXT_H
> >  
> > +#include <asm-generic/signal.h>
> > +#include <asm/sigcontext.h>
> > +
> >  struct ucontext {
> > 
> 
> Including another asm-generic header here is a bad idea: it breaks
> if an architecture overrides asm/signal.h with its own version
> but wants to use the asm-generic/ucontext.h file.
> 
> It would be best to just use linux/signal.h here, which includes
> the correct architecture specific files.

Thanks, I will use asm/signal.h instead.

-Mikko
