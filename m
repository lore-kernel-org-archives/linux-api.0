From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sat, 2 Nov 2019 11:53:38 -0700
Message-ID: <CAHk-=wg_X_7JSYT-a3qHrzvuWGMyffDWtQ4n7adBp_fe5w0BsA@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <30394.1571936252@warthog.procyon.org.uk> <c6e044cc-5596-90b7-4418-6ad7009d6d79@yandex-team.ru>
 <17311.1572534953@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17311.1572534953@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 31, 2019 at 8:16 AM David Howells <dhowells@redhat.com> wrote:
>
> Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:
>
> > Similar synchronization is required for reusing memory after vmsplice()?
> > I don't see other way how sender could safely change these pages.
>
> Sounds like a point - if you have multiple parallel contributors to the pipe
> via vmsplice(), then FIONREAD is of no use.  To use use FIONREAD, you have to
> let the pipe become empty before you can be sure.

Well, the rules for vmsplice is simply to not change the source pages.
It's zero-copy, after all.

If you want to change the source pages, you need to just use write() instead.

That said, even then the right model isn't fsync(). If you really want
to have something like "notify me when this buffer has been used", it
should be some kind of sequence count thing, not a "wait for empty".

Which might be useful in theory, but would be something quite
different (and honestly, I wouldn't expect it to find all that
widespread use)

             Linus
