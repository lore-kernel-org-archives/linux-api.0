From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sunrpc: eliminate RPC_DEBUG
Date: Mon, 06 Apr 2015 10:13:48 -0400
Message-ID: <1428329628.2973.21.camel@deneb.redhat.com>
References: <1428327960-22213-1-git-send-email-msalter@redhat.com>
	 <20150406100452.402754a6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150406100452.402754a6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-04-06 at 10:04 -0400, Jeff Layton wrote:
> nit: title should probably be "sunrpc: eliminate NFSD_DEBUG"

*sigh*

Yes, of course. That is what I intended but not what I wrote.

> 
> On Mon,  6 Apr 2015 09:46:00 -0400
> Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Commit f895b252d4edf ("sunrpc: eliminate RPC_DEBUG") introduced
> > use of IS_ENABLED() in a uapi header which leads to a build
> > failure for userspace apps trying to use <linux/nfsd/debug.h>:
> > 
> >    linux/nfsd/debug.h:18:15: error: missing binary operator before token "("
> >   #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> >                 ^
> > 
> > Since this was only used to define NFSD_DEBUG if CONFIG_SUNRPC_DEBUG
> > is enabled, replace instances of NFSD_DEBUG with CONFIG_SUNRPC_DEBUG.
> > 
> > Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/lockd/svcsubs.c              | 2 +-
> >  fs/nfsd/nfs4state.c             | 2 +-
> >  fs/nfsd/nfsd.h                  | 2 +-
> >  include/uapi/linux/nfsd/debug.h | 8 --------
> >  4 files changed, 3 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
> > index 665ef5a..a563ddb 100644
> > --- a/fs/lockd/svcsubs.c
> > +++ b/fs/lockd/svcsubs.c
> > @@ -31,7 +31,7 @@
> >  static struct hlist_head	nlm_files[FILE_NRHASH];
> >  static DEFINE_MUTEX(nlm_file_mutex);
> >  
> > -#ifdef NFSD_DEBUG
> > +#ifdef CONFIG_SUNRPC_DEBUG
> 
> Technically, you should use #if IS_ENABLED(CONFIG_SUNRPC_DEBUG). That's
> supposed to help the compiler do checking of the code inside the block
> even when it's not defined.
> 
> In some cases though, that doesn't work correctly and you may need to
> use plain-old #ifdef if not (particularly if there are symbols that
> don't exist and are referenced inside the block when
> CONFIG_SUNRPC_DEBUG isn't defined).
> 
> The CodingStyle document has a little blurb on this, fwiw...
> 
> >  static inline void nlm_debug_print_fh(char *msg, struct nfs_fh *f)
> >  {
> >  	u32 *fhp = (u32*)f->data;
> > diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> > index 26e9baa..d42786e 100644
> > --- a/fs/nfsd/nfs4state.c
> > +++ b/fs/nfsd/nfs4state.c
> > @@ -1139,7 +1139,7 @@ hash_sessionid(struct nfs4_sessionid *sessionid)
> >  	return sid->sequence % SESSION_HASH_SIZE;
> >  }
> >  
> > -#ifdef NFSD_DEBUG
> > +#ifdef CONFIG_SUNRPC_DEBUG
> >  static inline void
> >  dump_sessionid(const char *fn, struct nfs4_sessionid *sessionid)
> >  {
> > diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
> > index 565c4da..cf98052 100644
> > --- a/fs/nfsd/nfsd.h
> > +++ b/fs/nfsd/nfsd.h
> > @@ -24,7 +24,7 @@
> >  #include "export.h"
> >  
> >  #undef ifdebug
> > -#ifdef NFSD_DEBUG
> > +#ifdef CONFIG_SUNRPC_DEBUG
> >  # define ifdebug(flag)		if (nfsd_debug & NFSDDBG_##flag)
> >  #else
> >  # define ifdebug(flag)		if (0)
> > diff --git a/include/uapi/linux/nfsd/debug.h b/include/uapi/linux/nfsd/debug.h
> > index 0bf130a..28ec6c9 100644
> > --- a/include/uapi/linux/nfsd/debug.h
> > +++ b/include/uapi/linux/nfsd/debug.h
> > @@ -12,14 +12,6 @@
> >  #include <linux/sunrpc/debug.h>
> >  
> >  /*
> > - * Enable debugging for nfsd.
> > - * Requires RPC_DEBUG.
> > - */
> > -#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> > -# define NFSD_DEBUG		1
> > -#endif
> > -
> > -/*
> >   * knfsd debug flags
> >   */
> >  #define NFSDDBG_SOCK		0x0001
> 
> Looks fine other than the two nits above...
> 
> Acked-by: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
