From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Sun, 27 Oct 2019 10:03:35 -0400
Message-ID: <CAHk-=wh7cf3ANq-G9MmwSQiUK2d-=083C0HV_8hTGe2Mb4X7JA@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This still has signs of that earlier series:

On Wed, Oct 23, 2019 at 4:17 PM David Howells <dhowells@redhat.com> wrote:
>
>                 if (rem >= ibuf->len) {
>                         *obuf = *ibuf;
>                         ibuf->ops = NULL;
> -                       pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
> -                       pipe->nrbufs--;
> +                       tail++;
> +                       pipe_commit_read(pipe, tail);
>                 } else {
>                         if (!pipe_buf_get(pipe, ibuf))
>                                 goto out_free;

with those odd "pipe_commit_read/write()" helpers.

They make no sense, and they don't make things more legible.

It's shorter and more obvious to just write

   pipe->head = head;

than it is to write

   pipe_commit_write(pipe, head);

Even when the addition of the notifications,  it's all under the
pipe->wait.lock, so it's all just regular assignments.

Now, if at some point it starts doing fancy lockless things, at _that_
point the updates might become more complex, but that's a potential
future thing that wouldn't be relevant for a while, and isn't a reason
to make the code more obscure now.

Hmm?

             Linus
