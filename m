From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 20:08:32 +0100
Message-ID: <CAJfpegvkC=jinq6_XW_88vMfsNOHDNOzTsKw1YJ2HBmqffX5JQ@mail.gmail.com>
References: <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk> <20190206005638.GU2217@ZenIV.linux.org.uk>
 <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk> <20190207040058.GW2217@ZenIV.linux.org.uk>
 <20190207092253.GD19821@veci.piliscsaba.redhat.com> <20190207133135.GZ2217@ZenIV.linux.org.uk>
 <CAJfpegutRaXZ8EC_Am_PomxwdmSoH7eQkxAewaLfUrMALjym-w@mail.gmail.com>
 <20190207152002.GC2217@ZenIV.linux.org.uk> <CAJfpegvayM_ZmuVetfYzpK+qqZJPkVzfQVRQ7OO98f1=reqiYA@mail.gmail.com>
 <20190207162605.GD2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190207162605.GD2217@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, linux-aio <linux-aio@kvack.org>, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 7, 2019 at 5:26 PM Al Viro <viro@zeniv.linux.org.uk> wrote:

> I'm trying to put together some formal description of what's going on in there.
> Another question, BTW: updates of user->unix_inflight would seem to be movable
> into the callers of unix_{not,}inflight().  Any objections against lifting
> it into unix_{attach,detach}_fds()?  We do, after all, have fp->count right
> there, so what's the point incrementing/decrementing the sucker one-by-one?
> _And_ we are checking it right there (in too_many_unix_fds() called from
> unix_attach_fds())...

I see no issues with that.

Also shouldn't the rlimit check be made against user->unix_inflight +
fp->count?  Althought I'm not quite following if fp->user can end up
different from current_user() and what should happen in that case...

Thanks,
Miklos

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
