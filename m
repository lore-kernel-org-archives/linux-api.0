From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] sunrpc: eliminate RPC_DEBUG
Date: Mon, 06 Apr 2015 16:38:09 +0200
Message-ID: <4110847.o7VvYRDU5Z@wuerfel>
References: <1428327960-22213-1-git-send-email-msalter@redhat.com> <20150406100452.402754a6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150406100452.402754a6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Monday 06 April 2015 10:04:52 Jeff Layton wrote:
> > diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
> > index 665ef5a..a563ddb 100644
> > --- a/fs/lockd/svcsubs.c
> > +++ b/fs/lockd/svcsubs.c
> > @@ -31,7 +31,7 @@
> >  static struct hlist_head     nlm_files[FILE_NRHASH];
> >  static DEFINE_MUTEX(nlm_file_mutex);
> >  
> > -#ifdef NFSD_DEBUG
> > +#ifdef CONFIG_SUNRPC_DEBUG
> 
> Technically, you should use #if IS_ENABLED(CONFIG_SUNRPC_DEBUG). That's
> supposed to help the compiler do checking of the code inside the block
> even when it's not defined.

You probably meant the right thing and wrote something else: you should use
'if (IS_ENABLED(CONFIG_SUNRPC_DEBUG)) { ... }' to get that effect, but that
only works within a function. '#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)' is just
a nicer way to write '#if defined(CONFIG_SUNRPC_DEBUG) || 
defined(CONFIG_SUNRPC_DEBUG_MODULE)', which is harmless but pointless here
as the symbol would never be set to 'm'.

	Arnd
