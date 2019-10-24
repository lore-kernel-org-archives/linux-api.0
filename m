From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Thu, 24 Oct 2019 17:29:51 -0400
Message-ID: <CAHk-=wiMho2AhcTWC3-3zGK7639XL9UT=AheMXY0pxGHDACn6g@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <30394.1571936252@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30394.1571936252@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 24, 2019 at 12:57 PM David Howells <dhowells@redhat.com> wrote:
>
> pipe: Add fsync() support
>
> The keyrings testsuite needs the ability to wait for all the outstanding
> notifications in the queue to have been processed so that it can then go
> through them to find out whether the notifications it expected have been
> emitted.

Can't you just do

    ioctl(fd, FIONREAD, &count);

in a loop instead? "No paperwork. Just sprinkle some msleep() crack on
him, and let's get out of here"

               Linus
