From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Tue, 14 Jan 2020 13:59:42 +0800
Message-ID: <1fb8a0e4a763219f0f6cde6023ba89c1774cb854.camel@themaw.net>
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
         <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2020-01-14 at 13:01 +0800, Ian Kent wrote:
> On Tue, 2020-01-14 at 04:39 +0000, Al Viro wrote:
> > On Tue, Jan 14, 2020 at 08:25:19AM +0800, Ian Kent wrote:
> > 
> > > This isn't right.
> > > 
> > > There's actually nothing stopping a user from using a direct map
> > > entry that's a multi-mount without an actual mount at its root.
> > > So there could be directories created under these, it's just not
> > > usually done.
> > > 
> > > I'm pretty sure I don't check and disallow this.
> > 
> > IDGI...  How the hell will that work in v5?  Who will set _any_
> > traps outside the one in root in that scenario?  autofs_lookup()
> > won't (there it's conditional upon indirect mount).  Neither
> > will autofs_dir_mkdir() (conditional upon version being less
> > than 5).  Who will, then?
> > 
> > Confused...
> 
> It's easy to miss.
> 
> For autofs type direct and offset mounts the flags are set at fill
> super time.
> 
> They have to be set then because they are direct mounts and offset
> mounts behave the same as direct mounts so they need to be set then
> too. So, like direct mounts, offset mounts are each distinct autofs
> (trigger) mounts.
> 
> I could check for this construct and refuse it if that's really
> needed. I'm pretty sure this map construct isn't much used by
> people using direct mounts.

Ok, once again I'm not exactly accurate is some of what I said.

It turns out that the autofs connectathon tests, one of the tests
that I use, does test direct mounts with offsets both with and
without a real mount at the base of the mount.

Based on that, I have to say this map construct is meant to be
supported with Sun format maps of autofs (even though I think it's
probably not used much).

So not allowing it is probably the wrong thing to do.

OTOH initial testing with the #work.namei branch shows these are
functioning as required.

Ian
