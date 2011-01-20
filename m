From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 18:42:40 -0800
Message-ID: <20110119184240.b0a6a016.akpm@linux-foundation.org>
References: <1295399718.1949.864.camel@sli10-conroe>
	<20110119124158.b0348c44.akpm@linux-foundation.org>
	<1295490647.1949.890.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295490647.1949.890.camel@sli10-conroe>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Jan 2011 10:30:47 +0800 Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > I don't know if this is worth addressing.  Perhaps require that the
> > filp refers to the root of the fs?
> I didn't see why this is needed, but I can limit the fip to the root of
> the fs.

I don't think it matters much either.  The only problem I can see is if
we were to later try to extend the ioctl into a per-file thing.

> > Also, is this a privileged operation?  If not, then that might be a
> > problem - could it be used by unprivileged users to work out which
> > files have been opened recently or something like that?
> it's harmless even a unprivileged user uses it. I don't think
> unprivileged user can decode the data returned from the ioctl.

um.

Well, by doing a before-and-after thing I can use this ioctl to work
out what metadata blocks are used when someone reads
/my/super/secret-directory/foo.  Then I can write a program which sits
there waiting until someone else reads /my/super/secret-directory/foo. 
Then I can use that information to start WWIII or something.

I dunno, strange things happen.  Unless there's a good *need* to make
this available to unprivileged users then we should not do so.
