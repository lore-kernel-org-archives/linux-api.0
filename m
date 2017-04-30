From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Sat, 29 Apr 2017 21:38:22 -0700
Message-ID: <20170430043822.GE27790@bombadil.infradead.org>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CALCETrXhOhG0tRDDOROwT9ghvQvKziM2PBN=CX5Soa2m7=0cFw@mail.gmail.com>
 <20170429232504.GU29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170429232504.GU29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 30, 2017 at 12:25:04AM +0100, Al Viro wrote:
> On Sat, Apr 29, 2017 at 04:17:18PM -0700, Andy Lutomirski wrote:
> > On Sat, Apr 29, 2017 at 3:04 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> > > New AT_... flag - AT_NO_JUMPS
> > >
> > > Semantics: pathname resolution must not involve
> > >         * traversals of absolute symlinks
> > >         * traversals of procfs-style symlinks
> > >         * traversals of mountpoints (including bindings, referrals, etc.)
> > >         * traversal of .. in the starting point of pathname resolution.
> > 
> > Can you clarify this last one?  I assume that ".." will be rejected,
> > but what about "a/../.."?  How about "b" if b is a symlink to ".."?
> > How about "a/b" if a is a directory and b is a symlink to "../.."?
> 
> All of those will be rejected - in each of those cases pathname traversal
> leads back into the starting point with .. being the next component to
> handle.

It sounds more like AT_NO_ESCAPE ... or AT_BELOW, or something.  Perhaps
some example usages in the changelog?
