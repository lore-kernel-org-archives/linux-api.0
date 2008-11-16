From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Shared flags
Date: Sun, 16 Nov 2008 08:57:18 +0300
Message-ID: <200811160857.18558.piastry@etersoft.ru>
References: <49183DF9.9010003@etersoft.ru> <20081114033712.GL2055@shareable.org> <20081115113938.GA26576@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081115113938.GA26576-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I think that it'll be interesting for others filesystems. Also I should
say that solution with mounting options let us increase usual
possibilities to organize access policy. If you need it, you switch it
on, if don't (like in example) you simply don't use it! In conclusion,
we have increased functionality without any troubles.

Also, I should say that share flags is necessary for working with wine,
because NTCreateFile use it... 

On Saturday 15 November 2008 14:39:38 you wrote:
> On Fri, Nov 14, 2008 at 03:37:12AM +0000, Jamie Lokier wrote:
> > A generic mount option is currently used for mandatory locking - this
> > is very similar.
> >
> > The only different I see, for security, is with mandatory locking a
> > process which doesn't want to get stuck can check the permission bits
> > before opening a file.  But I'm not aware of anything actually doing
> > this.
>
> More importantly the admin can do it.  And mandatory locking doesn't
> mean you can't remove something, with would be a complete nightmare.  It
> also doesn't apply to directories, which from my reading of the patch
> this one would do.  But yeah, doing the read/write part as as a special
> case of mandlock on open might make some sense, but I'm still not too
> convinced.
>
> That more I think about these option the less I like the idea, it's just
> going to cause a lot of problems to help with some wine issues that
> hasn't even been explained yet.


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
