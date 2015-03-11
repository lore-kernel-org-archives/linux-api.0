From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 34/45] include/uapi/asm-generic/signal.h: hide sigset_t
 definition in userspace
Date: Wed, 11 Mar 2015 02:05:16 +0200
Message-ID: <20150311000516.GA12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-35-git-send-email-mikko.rapeli@iki.fi>
 <2741317.tcRFXAy9C6@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2741317.tcRFXAy9C6@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 10:16:09AM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 00:05:37 Mikko Rapeli wrote:
> > +#ifdef __KERNEL__
> > +/* already defined in userspace via stdlib.h */
> >  typedef struct {
> >         unsigned long sig[_NSIG_WORDS];
> >  } sigset_t;
> > +#endif /* __KERNEL__ */
> 
> I'm not sure here: Is this structure always identical to the one
> we see in user space?
> 
> If not, we might want to rename the typedef to __kernel_sigset_t
> instead and use that inside of the uapi headers.

I was copying this ifdef from the struct sigaction part in the same file:

#ifndef __KERNEL__
struct sigaction {
        __sighandler_t sa_handler;
        unsigned long sa_flags;
#ifdef SA_RESTORER
        __sigrestore_t sa_restorer;
#endif
        sigset_t sa_mask;               /* mask last for extensibility */
};
#endif

I assumed it had the same problems at some point.

-Mikko
