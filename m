From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/4] uapi, vfs: Change the mount API UAPI [ver #2]
Date: Fri, 17 May 2019 09:25:21 +0200
Message-ID: <CAJfpegu0Ckc9tvuPKGtf1mrfj3mLmgw_gcJER9yyRLre4iwZiw@mail.gmail.com>
References: <155800752418.4037.9567789434648701032.stgit@warthog.procyon.org.uk>
 <20190516162259.GB17978@ZenIV.linux.org.uk> <20190516163151.urrmrueugockxtdy@brauner.io>
 <20190516165021.GD17978@ZenIV.linux.org.uk> <F67AF221-C576-4424-88D7-7C6074D0A6C6@brauner.io>
 <11455.1558077206@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11455.1558077206@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 17, 2019 at 9:13 AM David Howells <dhowells@redhat.com> wrote:
>
> Christian Brauner <christian@brauner.io> wrote:
>
> > If you still prefer to have cloexec flags
> > for the 4 new syscalls then yes,
> > if they could at least all have the same name
> > (FSMOUNT_CLOEXEC?) that would be good.
>
> They don't all have the same value (see OPEN_TREE_CLOEXEC).
>
> Note that I also don't want to blindly #define them to O_CLOEXEC because it's
> not necessarily the same value on all arches.  Currently it can be 02000000,
> 010000000 or 0x400000 for instance, which means that if it's sharing a mask
> with other flags, at least three bits have to be reserved for it or we have to
> have arch-dependent bit juggling.
>
> One thing I like about your approach of just making them O_CLOEXEC by default
> and removing the constants is that it avoids this mess entirely.

+1.

Confusion caused by inconsistency of naming is going to hurt more than
inconsistency of semantics wrt. open(2).

Thanks,
Miklos
