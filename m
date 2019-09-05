From: David Howells <dhowells@redhat.com>
Subject: Re: Why add the general notification queue and its sources
Date: Fri, 06 Sep 2019 00:18:28 +0100
Message-ID: <14883.1567725508@warthog.procyon.org.uk>
References: <CAHk-=wgbCXea1a9OTWgMMvcsCGGiNiPp+ty-edZrBWn63NCYdw@mail.gmail.com> <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk> <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com> <17703.1567702907@warthog.procyon.org.uk> <CAHk-=wjQ5Fpv0D7rxX0W=obx9xoOAxJ_Cr+pGCYOAi2S9FiCNg@mail.gmail.com> <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com> <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com> <5396.1567719164@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgbCXea1a9OTWgMMvcsCGGiNiPp+ty-edZrBWn63NCYdw@mail.gmail.com>
Content-ID: <14882.1567725508.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Ray Strode <rstrode@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Whitehouse <swhiteho@redhat.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Ray, Debarshi" <debarshi.ray@gmail.com>, Robbie Harwood <rharwood@redhat.com>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But I know - we *have* one of those. There's already a system call for
> it, and has been forever. One that we then extended to allow people to
> change the buffer size, and do a lot of other things with.
> 
> It's called "pipe()". And you can give the writing side to other user
> space processes too, in case you are running an older kernel that
> didn't have some "event pipe support". It comes with resource
> management, because people already use those things.

Can you write into a pipe from softirq context and/or with spinlocks held
and/or with the RCU read lock held?  That is a requirement.  Another is that
messages get inserted whole or not at all (or if they are truncated, the size
field gets updated).

Since one end would certainly be attached to an fd, it looks on the face of it
that writing into the pipe would require taking pipe->mutex.

David
