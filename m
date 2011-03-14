From: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 19:17:53 -0400
Message-ID: <20110314231753.GF8120@thunk.org>
References: <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
 <20110312021001.GA16833@elie>
 <20110312173217.GA24981@kroah.com>
 <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
 <20110314131042.5a7fb32f.akpm@linux-foundation.org>
 <20110314211119.GC8120@thunk.org>
 <20110314142032.b9523309.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110314142032.b9523309.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: G@thunk.org, Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Mon, Mar 14, 2011 at 02:20:32PM -0700, Andrew Morton wrote:
> > I'm a bit nervous about exposing WB_SYNC_NONE to userspace, because
> > its semantics are *definitely* hard to describe.  For example, at the
> > moment if you do a WB_SYNC_NONE writeback, the writeback code will
> > clamp the amount of data written back for each inode to
> > MAX_WRITEBACK_PAGES (1024) pages.
> 
> Wha?  It does?  When did that get broken?

Oops, sorry, I misread the code in wb_writeback().  My bad!  I
misinterpreted what write_chunk does in that function.
MAX_WRITEBACK_PAGES now really is the minimum amount of pages that
wb_writeback() will request the file system to write back.  I'm not
sure why we bother with write_chunk any more, but it shouldn't be
doing any harm any more.

					- Ted
