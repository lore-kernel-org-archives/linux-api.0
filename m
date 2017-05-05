From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 5 May 2017 05:39:02 +0100
Message-ID: <20170505043902.GP29622@ZenIV.linux.org.uk>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
 <CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com>
 <CA+55aFy1SokNNUgxBnFLdA1PRyeG13BqyYNg5xVrW-tNGqh2Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy1SokNNUgxBnFLdA1PRyeG13BqyYNg5xVrW-tNGqh2Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 04, 2017 at 08:46:49PM -0700, Linus Torvalds wrote:
> On Thu, May 4, 2017 at 7:47 PM, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Thread 1 starts an AT_BENEATH path walk using an O_PATH fd
> > pointing to /srv/www/example.org/foo; the path given to the syscall is
> > "bar/../../../../etc/passwd". The path walk enters the "bar" directory.
> > Thread 2 moves /srv/www/example.org/foo/bar to
> > /srv/www/example.org/bar.
> > Thread 1 processes the rest of the path ("../../../../etc/passwd"), never
> > hitting /srv/www/example.org/foo in the process.
> >
> > I'm not really familiar with the VFS internals, but from a coarse look
> > at the patch, it seems like it wouldn't block this?
> 
> I think you're right.
> 
> I guess it would be safe for the RCU case due to the sequence number
> check, but not the non-RCU case.

	Yes and no...  FWIW, to exclude that it would suffice to have
mount --rbind /src/www/example.org/foo /srv/www/example.org/foo done first.
Then this kind of race will end up with -ENOENT due to path_connected()
logics in follow_dotdot_rcu()/follow_dotdot().  I'm not sure about the
intended applications, though - is that thing supposed to be used along with
some horror like seccomp, or...?
