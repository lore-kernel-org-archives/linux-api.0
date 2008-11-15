From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Shared flags
Date: Sat, 15 Nov 2008 06:39:38 -0500
Message-ID: <20081115113938.GA26576@infradead.org>
References: <49183DF9.9010003@etersoft.ru> <20081111085211.GB2323@infradead.org> <20081111100940.GA8968@shareable.org> <20081111111428.GA18228@infradead.org> <491BFCBA.80208@etersoft.ru> <20081113092554.GA3004@infradead.org> <20081114033712.GL2055@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081114033712.GL2055@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Pavel Shilovsky <piastry@etersoft.ru>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 14, 2008 at 03:37:12AM +0000, Jamie Lokier wrote:
> A generic mount option is currently used for mandatory locking - this
> is very similar.
> 
> The only different I see, for security, is with mandatory locking a
> process which doesn't want to get stuck can check the permission bits
> before opening a file.  But I'm not aware of anything actually doing this.

More importantly the admin can do it.  And mandatory locking doesn't
mean you can't remove something, with would be a complete nightmare.  It
also doesn't apply to directories, which from my reading of the patch
this one would do.  But yeah, doing the read/write part as as a special
case of mandlock on open might make some sense, but I'm still not too
convinced.

That more I think about these option the less I like the idea, it's just
going to cause a lot of problems to help with some wine issues that
hasn't even been explained yet.
