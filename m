From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Why add the general notification queue and its sources
Date: Thu, 5 Sep 2019 13:39:00 -0700
Message-ID: <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com>
References: <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
 <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com>
 <17703.1567702907@warthog.procyon.org.uk> <CAHk-=wjQ5Fpv0D7rxX0W=obx9xoOAxJ_Cr+pGCYOAi2S9FiCNg@mail.gmail.com>
 <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ray Strode <rstrode@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Whitehouse <swhiteho@redhat.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Ray, Debarshi" <debarshi.ray@gmail.com>, Robbie Harwood <rharwood@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 5, 2019 at 11:33 AM Ray Strode <rstrode@redhat.com> wrote:
>
> Hi,
>
> On Thu, Sep 5, 2019 at 1:20 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > You've at least now answered part of the "Why", but you didn't
> > actually answer the whole "another developer" part.
> It's certainly something we've wanted in the GNOME world for a long time:
>
> See for instance
>
> https://bugzilla.redhat.com/show_bug.cgi?id=991110

That is *way* too specific to make for any kind of generic
notification mechanism.

Also, what is the security model here? Open a special character
device, and you get access to random notifications from random
sources?

That makes no sense. Do they have the same security permissions?

USB error reporting is one thing - and has completely different
security rules than some per-user key thing (or system? or namespace?
Or what?)

And why would you do a broken big-key thing in the kernel in the first
place? Why don't you just have a kernel key to indirectly encrypt
using a key and "additional user space data". The kernel should simply
not take care of insane 1MB keys.

Big keys just don't make sense for a kernel. Just use the backing
store THAT YOU HAVE TO HAVE ANYWAY. Introduce some "indirect key"
instead that is used to encrypt and authenticate the backing store.

And mix in /proc/mounts tracking, which has a namespace component and
completely different events and security model (likely "none" - since
you can always read your own /proc/mounts).

So honestly, this all just makes me go "user interfaces are hard, all
the users seem to have *completely* different requirements, and nobody
has apparently really tested this in practice".

Maybe a generic notification mechanism is sensible. But I don't see
how security issues could *possibly* be unified, and some of the
examples given (particularly "track changes to /proc/mounts") seem to
have obviously better alternatives (as in "just support poll() on
it").

All this discussion has convinced me of is that this whole thing is
half-baked and not ready even on a conceptual level.

So as far as I'm concerned, I think I want things like actual
"Tested-by:" lines from actual users, because it's not clear that this
makes sense. Gnome certainly should work as a regular user, if you
need a system daemon for it with root privileges you might as well
just do any notification entirely inside that daemon in user space.
Same goes for /proc/mounts - which as mentioned has a much more
obvious interface for waiting anyway.

User interfaces need a lot of thought and testing. They shouldn't be
ad-hoc "maybe this could work for X, Y and Z" theories.

                    Linus
