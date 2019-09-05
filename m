From: David Howells <dhowells@redhat.com>
Subject: Re: Why add the general notification queue and its sources
Date: Thu, 05 Sep 2019 22:32:44 +0100
Message-ID: <5396.1567719164@warthog.procyon.org.uk>
References: <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com> <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk> <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com> <17703.1567702907@warthog.procyon.org.uk> <CAHk-=wjQ5Fpv0D7rxX0W=obx9xoOAxJ_Cr+pGCYOAi2S9FiCNg@mail.gmail.com> <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com>
Content-ID: <5395.1567719164.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Ray Strode <rstrode@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Whitehouse <swhiteho@redhat.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Ray, Debarshi" <debarshi.ray@gmail.com>, Robbie Harwood <rharwood@redhat.com>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Also, what is the security model here? Open a special character
> device, and you get access to random notifications from random
> sources?
>
> That makes no sense. Do they have the same security permissions?

Sigh.  It doesn't work like that.  I tried to describe this in the manpages I
referred to in the cover note.  Obviously I didn't do a good enough job.  Let
me try and explain the general workings and the security model here.

 (1) /dev/watch_queue just implements locked-in-memory buffers.  It gets you
     no events by simply opening it.

     Each time you open it you get your own private buffer.  Buffers are not
     shares.  Creation of buffers is limited by ENFILE, EMFILE and
     RLIMIT_MEMLOCK.

 (2) A buffer is implemented as a pollable ring buffer, with the head pointer
     belonging to the kernel and the tail pointer belonging to userspace.
     Userspace mmaps the buffer.

     The kernel *only ever* reads the head and tail pointer from a buffer; it
     never reads anything else.

     When it wants to post a message to a buffer, the kernel reads the
     pointers and then does one of three things:

	(a) If the pointers were incoherent it drops the message.

	(b) If the buffer was full the kernel writes a flag to indicate this
	    and drops the message.

	(c) Otherwise, the kernel writes a message and maybe padding at the
     	    place(s) it expects and writes the head pointer.  If userspace was
     	    busy trashing the place, that should not cause a problem for the
     	    kernel.

     The buffer pointers are expected to run to the end and wrap naturally;
     they're only masked off at the point of actually accessing the buffer.

 (3) You connect event sources to your buffer, e.g.:

	fd = open("/dev/watch_queue", ...);
	keyctl_watch_key(KEY_SPEC_SESSION_KEYRING, fd, ...);

     or:

	watch_mount(AT_FDCWD, "/net", 0, fd, ...);

     Security is checked at the point of connection to make sure you have
     permission to access that source.  You have to have View permission on a
     key/keyring for key events, for example, and you have to have execute
     permission on a directory for mount events.

     The LSM gets a look-in too: Smack checks you have read permission on a
     key for example.

 (4) You can connect multiple sources of different types to your buffer and a
     source can be connected to multiple buffers at a time.

 (5) Security is checked when an event is delivered to make sure the triggerer
     of the event has permission to give you that event.  Smack requires that
     the triggerer has write permission on the opener of the buffer for
     example.

 (6) poll() signals POLLIN|POLLRDNORM if there is stuff in the buffer and
     POLLERR if the pointers are incoherent.

David
