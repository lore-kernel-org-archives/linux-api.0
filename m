From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Tue, 14 Jan 2020 08:25:19 +0800
Message-ID: <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
References: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200108031314.GE8904@ZenIV.linux.org.uk>
         <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
         <20200108213444.GF8904@ZenIV.linux.org.uk>
         <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
         <20200110041523.GK8904@ZenIV.linux.org.uk>
         <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
         <20200112213352.GP8904@ZenIV.linux.org.uk>
         <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
Sender: stable-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2020-01-13 at 10:59 +0800, Ian Kent wrote:
> 
> > 3) is _anything_ besides root directory ever created in direct
> > autofs
> > superblocks by anyone?  If not, why does autofs_lookup() even
> > bother
> > to
> > do anything there?  IOW, why not have it return ERR_PTR(-ENOENT)
> > immediately
> > for direct ones?  Or am I missing something and it is, in fact,
> > possible
> > to have the daemon create something in those?
> 
> Short answer is no, longer answer is directories "shouldn't" ever
> be created inside direct mount points.
> 
> The thing is that the multi-mount map construct can be used with
> direct mounts too, but they must always have a real mount at the
> base because they are direct mounts. So processes should not be
> able to walk into them while they are being mounted (constructed).
> 
> But I'm pretty sure it's rare (maybe not done at all) that this
> map construct is used with direct mounts.

This isn't right.

There's actually nothing stopping a user from using a direct map
entry that's a multi-mount without an actual mount at its root.
So there could be directories created under these, it's just not
usually done.

I'm pretty sure I don't check and disallow this.

Ian
