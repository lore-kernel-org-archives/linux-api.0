From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow
 cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Mon, 4 Jun 2018 21:38:00 +0200
Message-ID: <CAELBmZARJVUMhPC2w-RFic=6r7tcrJYGV4Yt03xxZXsKr+FR1w@mail.gmail.com>
References: <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org> <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk> <20180602034255.GV30522@ZenIV.linux.org.uk>
 <21804.1527954321@warthog.procyon.org.uk> <20180602174957.GX30522@ZenIV.linux.org.uk>
 <20180603005532.GZ30522@ZenIV.linux.org.uk> <20180604171630.GA29059@bombadil.infradead.org>
 <20180604173508.GJ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180604173508.GJ30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 4, 2018 at 7:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jun 04, 2018 at 10:16:30AM -0700, Matthew Wilcox wrote:
>> On Sun, Jun 03, 2018 at 01:55:37AM +0100, Al Viro wrote:
>> > +SYSCALL_DEFINE3(open_tree, int, dfd, const char *, filename, unsigned, flags)
>> > +{
>> > +   struct file *file;
>> > +   struct path path;
>> > +   int lookup_flags = LOOKUP_AUTOMOUNT | LOOKUP_FOLLOW;
>> > +   bool detached = flags & OPEN_TREE_CLONE;
>> > +   int error;
>> > +   int fd;
>> > +
>> > +   BUILD_BUG_ON(OPEN_TREE_CLOEXEC != O_CLOEXEC);
>>
>> Why do we need OPEN_TREE_CLOEXEC?  Wouldn't we be better off just making
>> the fd returned by open_tree implicitly close-on-exec?  I can think of
>> no good reason for these file descriptors to be inherited across exec()
>
> How are they different from any file descriptor?  It's not as if it was
> something usable only for mounting stuff - again, you can use them
> with any ...at() syscalls.

Defaulting to close on exec helps keep out clutter from the API.

Is there a disadvantage to needing an explicit fcntl(F_SETFD) call to
disable close on exec?

Thanks,
Miklos
