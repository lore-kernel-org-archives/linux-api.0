From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Thu, 4 May 2017 18:27:10 -0700
Message-ID: <CA+55aFyOKM7DW7+0sdDFKdZFXgptb5r1id9=Wvhd8AgSP7qjwQ@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170505003030.GM29622-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 4, 2017 at 5:30 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>
> As for mountpoint crossing...  it might make sense to split those.
> O_BENEATH allowed it, and if we want AT_BENEATH to match that - let's
> do it.  Then this one would become AT_BENEATH | AT_XDEV (the latter named
> after find(1) option, obviously).

So I would still like to split that NO_JUMP flag even more.

I like the AT_BENEATH | AT_XDEV split, but I think XDEV should be
split further, and I think the symlink avoidance should be split more
too.

As mentioned last time, at least for the git usage, even relative
symlinks are a no-no - not because they'd escape, but simply because
git wants to see the *unique* name, and resolve relative symlinks to
either the symlink, or to the actual file it points to.

So I think that we'd want an additional flag that says "no symlinks at all".

And I think the "no mountpoint" traversal might be splittable too.

Yes, sometimes you'd probably want to say "stay exactly inside this
filesystem" (like find -xdev). So no arguments against AT_XDEV that
refuses any mount traversal (kind of like my "no symlink traversal"
thing).

But at other points you might want to just guarantee that the walk
stays below a certain starting point and doesn't escape.

That could still allow crossing mount-points, but only if they are
non-bind mounts and cannot let us escape.

I'm not sure if that's testable, though.

                  Linus
