From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 2/3] fs: add RWF_ENCODED for writing compressed data
Date: Tue, 24 Sep 2019 13:50:14 -0700
Message-ID: <20190924205014.GJ1855@bombadil.infradead.org>
References: <cover.1568875700.git.osandov@fb.com>
 <230a76e65372a8fb3ec62ce167d9322e5e342810.1568875700.git.osandov@fb.com>
 <CAG48ez2GKv15Uj6Wzv0sG5v2bXyrSaCtRTw5Ok_ovja_CiO_fQ@mail.gmail.com>
 <20190924171513.GA39872@vader>
 <20190924193513.GA45540@vader>
 <CAG48ez1NQBNR1XeVQYGoopEk=g_KedUr+7jxLQTaO+V8JCeweQ@mail.gmail.com>
 <20190924202229.mjvjigpnrskjtk5n@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190924202229.mjvjigpnrskjtk5n@wittgenstein>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jann Horn <jannh@google.com>, Omar Sandoval <osandov@osandov.com>, Aleksa Sarai <cyphar@cyphar.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Linux API <linux-api@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 24, 2019 at 10:22:29PM +0200, Christian Brauner wrote:
> On Tue, Sep 24, 2019 at 10:01:41PM +0200, Jann Horn wrote:
> > Mmh... but if the file descriptor has been passed through a privilege
> > boundary, it isn't really clear whether the original opener of the
> > file intended for this to be possible. For example, if (as a
> > hypothetical example) the init process opens a service's logfile with
> > root privileges, then passes the file descriptor to that logfile to
> > the service on execve(), that doesn't mean that the service should be
> > able to perform compressed writes into that file, I think.
> 
> I think we should even generalize this: for most new properties a given
> file descriptor can carry we would want it to be explicitly enabled such
> that passing the fd around amounts to passing that property around. At
> least as soon as we consider it to be associated with some privilege
> boundary. I don't think we have done this generally. But I would very
> much support moving to such a model.

I think you've got this right.  This needs to be an fcntl() flag, which
is only settable by root.  Now, should it be an O_ flag, modifiable by
F_SETFL, or should it be a new F_ flag?
