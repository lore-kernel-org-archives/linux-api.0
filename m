From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Tue, 21 Oct 2014 03:46:45 -0700
Message-ID: <20141021104645.GA11538@infradead.org>
References: <20141016124741.GA3832@kroah.com>
 <20141017094329.GB18015@infradead.org>
 <20141019220450.GB3780@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141019220450.GB3780-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arve Hj?nnev?g <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-l0cyMroinI0@public.gmane.org>, Rebecca Schultz Zavin <rebecca-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 06:04:50AM +0800, Greg Kroah-Hartman wrote:
> There is now work to resolve the interface, it requires someone who has
> the rights to push to Android userspace.  But that is going to be a
> "total rewrite", and until then, this code needs to be used, no matter
> how much we hate this.

It helps to qualify why it absolutely has to, and why this is different
from other interfaces we haven't merged.  Is this the last building
block to run upstream Linux on a common Android device out of the box
without needing any patches or out of tree drivers?  Is there any other
good reason I might have missed.

To convince other people that merging a piece like this absolutely needs
to get merged I'd suggest you start with presenting factual argument,
and then let the broader audience weight their merrits.

I think with the known problems of the code, and the fact that the
real user ABI is a library anyway the stakes are quite high here.

So as a start please prepare a list of arguments, a detailed description
of the ABI, and post a proper patch (not a move) that suggests adding
this driver to all the relevant lists (most importantly linux-fsdevel
and linux-api) so that people with the right experience can review it.
