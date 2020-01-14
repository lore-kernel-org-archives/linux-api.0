From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Tue, 14 Jan 2020 13:01:28 +0800
Message-ID: <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel@themaw.net>
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
         <20200114043924.GV8904@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200114043924.GV8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, stable <stable@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2020-01-14 at 04:39 +0000, Al Viro wrote:
> On Tue, Jan 14, 2020 at 08:25:19AM +0800, Ian Kent wrote:
> 
> > This isn't right.
> > 
> > There's actually nothing stopping a user from using a direct map
> > entry that's a multi-mount without an actual mount at its root.
> > So there could be directories created under these, it's just not
> > usually done.
> > 
> > I'm pretty sure I don't check and disallow this.
> 
> IDGI...  How the hell will that work in v5?  Who will set _any_
> traps outside the one in root in that scenario?  autofs_lookup()
> won't (there it's conditional upon indirect mount).  Neither
> will autofs_dir_mkdir() (conditional upon version being less
> than 5).  Who will, then?
> 
> Confused...

It's easy to miss.

For autofs type direct and offset mounts the flags are set at fill
super time.

They have to be set then because they are direct mounts and offset
mounts behave the same as direct mounts so they need to be set then
too. So, like direct mounts, offset mounts are each distinct autofs
(trigger) mounts.

I could check for this construct and refuse it if that's really
needed. I'm pretty sure this map construct isn't much used by
people using direct mounts.

Ian
