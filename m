From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Tue, 14 Jan 2020 04:39:24 +0000
Message-ID: <20200114043924.GV8904@ZenIV.linux.org.uk>
References: <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200108213444.GF8904@ZenIV.linux.org.uk>
 <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
 <20200110041523.GK8904@ZenIV.linux.org.uk>
 <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
 <20200112213352.GP8904@ZenIV.linux.org.uk>
 <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
 <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 14, 2020 at 08:25:19AM +0800, Ian Kent wrote:

> This isn't right.
> 
> There's actually nothing stopping a user from using a direct map
> entry that's a multi-mount without an actual mount at its root.
> So there could be directories created under these, it's just not
> usually done.
> 
> I'm pretty sure I don't check and disallow this.

IDGI...  How the hell will that work in v5?  Who will set _any_
traps outside the one in root in that scenario?  autofs_lookup()
won't (there it's conditional upon indirect mount).  Neither
will autofs_dir_mkdir() (conditional upon version being less
than 5).  Who will, then?

Confused...
