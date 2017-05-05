From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 5 May 2017 02:06:54 +0100
Message-ID: <20170505010654.GN29622@ZenIV.linux.org.uk>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
 <CALCETrXE2-841_VRgDJxRZBYAfvSe+GQN+0Jkfh3k1pL8XfDaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXE2-841_VRgDJxRZBYAfvSe+GQN+0Jkfh3k1pL8XfDaA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 04, 2017 at 05:44:19PM -0700, Andy Lutomirski wrote:
> > It's not quite O_BENEATH, and IMO it's saner that way - a/b/c/../d is
> > bloody well allowed, and so are relative symlinks that do not lead out of
> > the subtree.  If somebody has a good argument in favour of flat-out
> > ban on .. (_other_ than "other guys do it that way, and it doesn't need
> > to make sense 'cuz security!!1!!!", please), I'd be glad to hear it.
> 
> I don't have an argument for allowing '..'.  I think it would be okay
> to disallow it, but I don't think it matters all that much either way.

Relative symlinks as argument in favour of allowing .. _when_ _it_ _stays_
_in_ _subtree_.

> > For the latter I would prefer -EXDEV, for obvious reasons.  For the former...
> > not sure.  I'm not too happy about -ELOOP, but -EPERM (as with O_BENEATH)
> > is an atrocity - it's even more overloaded.
> >
> > Suggestions?
> 
> -EDOTDOT would be amusing.

For ln -s /tmp foo/bar, lookup for foo/bar/baz?  Seriously?  Hell, even
-EXDEV would make more sense...
