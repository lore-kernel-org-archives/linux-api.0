From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
Date: Fri, 31 Oct 2014 11:00:01 -0700
Message-ID: <CA+55aFxB=jWGvPH3TMhB=ungOg9TBai5Ak-ma5vChBB-H2AgnQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
	<20141030233801.GF7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141030233801.GF7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 4:38 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>
> If you remove an object from some search structures, taking the lock in
> destructor is Too Fucking Late(tm).  Somebody might have already found
> that puppy and decided to pick it (all under that lock) just as we'd
> got to that point in destructor and blocked there.  Oops...

Ugh, yes. This is a much too common anti-pattern.

> Normally I'd say "just use kref_put_mutex()", but this case is even worse.
> Look:

Yeah the whole "release the structure the lock is in" is another one.

Both of these patterns have happened so many times that I'd love to
have some kind of automated tool to see them, but I suspect it is
*much* too complex to be easily checked for. The lock object debugging
we have only triggers for the case where the freeing actually happens
with the lock still held, which is too late and too hard-to-hit to be
a very useful check.

                     Linus
