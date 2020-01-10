From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over symlinks
Date: Thu, 9 Jan 2020 21:03:00 -0800
Message-ID: <CAHk-=wiF6en6WD7JdYAUxHnzeTgs3P08ysDQPv4504hQ2qUcmA@mail.gmail.com>
References: <20200101005446.GH4203@ZenIV.linux.org.uk> <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com> <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com> <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk> <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200108213444.GF8904@ZenIV.linux.org.uk> <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
 <20200110041523.GK8904@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200110041523.GK8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ian Kent <raven@themaw.net>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 9, 2020 at 8:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Hmm. If that's the case, maybe they should be marked implicitly as
> > O_PATH when opened?
>
> I thought you wanted O_PATH as starting point to have mounts traversed?
> Confused...

No, I'm confused.  I meant "non-O_PATH", just got the rules reversed in my mind.

So cwd/root would always act as it non-O_PATH, and only using an
actual fd would look at the O_PATH flag, and if it was set would walk
the mountpoints.

> <grabs Bach> Right, he simply transcribes v7 iget().
>
> So I suspect that you are right - your variant of iget was pretty much
> one-to-one implementation of Bach's description of v7 iget.

Ok, that makes sense. My copy of Bach literally had the system call
list "marked off" when I implemented them back when.

I may still have that paperbook copy somewhere. I don't _think_ I'd
have thrown it out, it has sentimental value.

> > I think that in a perfect world, the O_PATH'ness of '42' would be the
> > deciding factor. Wouldn't those be the best and most consistent
> > semantics?
> >
> > And then 'cwd'/'root' always have the O_PATH behavior.
>
> See above - unless I'm misparsing you, you wanted mount traversals in the
> starting point if it's ...at() with O_PATH fd.

.. and see above, it was just my confusion about the sense of O_PATH.

> For cwd and root the situation is opposite - we do NOT traverse mounts
> for those.  And that's really too late to change.

Oh, absolutely.

[ snip some more about your automount digging. Looks about right, but
I'm not going to make a peep after getting O_PATH reversed ;) ]

            Linus
