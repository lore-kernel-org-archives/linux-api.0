From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 04/14] pipe: Add O_NOTIFICATION_PIPE [ver #2]
Date: Fri, 08 Nov 2019 06:42:50 +0000
Message-ID: <7772.1573195370@warthog.procyon.org.uk>
References: <CALCETrWeN9CGJHz0dzG1uH5Qjbr+xG3OKZuEd33eBY_rAzVkqQ@mail.gmail.com> <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk> <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk> <CALCETrUka9KaOKFbNKUXcA6XvoFxiXPftctSHtN4DL35Cay61w@mail.gmail.com> <6964.1573152517@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWeN9CGJHz0dzG1uH5Qjbr+xG3OKZuEd33eBY_rAzVkqQ@mail.gmail.com>
Content-ID: <7771.1573195370.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> I can open a normal pipe from userspace (with pipe() or pipe2()), and
> I can have two threads.  One thread writes to the pipe with write().
> The other thread writes with splice().  Everything works fine.

Yes.  Every operation you do on a pipe from userspace is serialised with th=
e
pipe mutex - and both ends share the same pipe.

> What's special about notifications?

The post_notification() cannot take the pipe mutex.  It has to be callable
from softirq context.  Linus's idea is that when you're actually altering t=
he
ring pointers you should hold the wake-queue spinlock, and post_notificatio=
n()
holds the wake queue spinlock for the duration of the operation.

This means that post_notification() can be writing to the pipe whilst a
userspace-invoked operation is holding the pipe mutex and is also doing
something to the ring.

David
