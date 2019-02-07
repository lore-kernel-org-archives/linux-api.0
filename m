From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 15:20:02 +0000
Message-ID: <20190207152002.GC2217@ZenIV.linux.org.uk>
References: <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <20190206005638.GU2217@ZenIV.linux.org.uk>
 <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
 <20190207040058.GW2217@ZenIV.linux.org.uk>
 <20190207092253.GD19821@veci.piliscsaba.redhat.com>
 <20190207133135.GZ2217@ZenIV.linux.org.uk>
 <CAJfpegutRaXZ8EC_Am_PomxwdmSoH7eQkxAewaLfUrMALjym-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegutRaXZ8EC_Am_PomxwdmSoH7eQkxAewaLfUrMALjym-w@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, linux-aio <linux-aio@kvack.org>, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 07, 2019 at 03:20:06PM +0100, Miklos Szeredi wrote:

> > Am I right assuming that this queue-modifying operation is accept(), removing
> > an embryo unix_sock from the queue of listener and thus hiding SCM_RIGHTS in
> > _its_ queue from scan_children()?
> 
> Hmm... How about just receiving an SCM_RIGHTS socket (which was a
> candidate) from the queue of the peeked socket?

Right, skb unlinked before unix_detach_fds().  I was actually thinking of a stream
case, where unlink is done after that...

*grumble*

The entire thing is far too brittle for my taste ;-/

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
