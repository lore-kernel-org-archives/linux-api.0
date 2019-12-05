From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] pipe: Notification queue preparation
Date: Thu, 5 Dec 2019 09:24:51 -0800
Message-ID: <CAHk-=wi_on1EAbVi1Q01i7=0_GL=nKmz6s9677YZf74H8=Sw0g@mail.gmail.com>
References: <31452.1574721589@warthog.procyon.org.uk> <20191205125826.GK2734@twin.jikos.cz>
 <1593.1575554217@warthog.procyon.org.uk> <CAHk-=wgwwJ+ZEtycujFdNmpS8TjwCYyT+oHfV7d-GekyaX91xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgwwJ+ZEtycujFdNmpS8TjwCYyT+oHfV7d-GekyaX91xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 5, 2019 at 9:12 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It would be interesting to hear if somebody else is waiting on the
> read side too.

Looking once more at that commit, I find at least one bug, but I'm
pretty sure that's not the cause of this problem.

DavidH, watch out for things like this:

-       for (idx = 0; idx < pipe->nrbufs && rem < len; idx++)
+       for (idx = tail; idx < head && rem < len; idx++)

which is a completely buggy conversion.

You can't compare tail and head with an inequality, it gets the
wraparound case wrong.

But I found only one of those, and it's fuse-specific, plus the
overflow would take a long time to trigger, so I'm pretty sure this
isn't what DavidS is reporting.

               Linus
