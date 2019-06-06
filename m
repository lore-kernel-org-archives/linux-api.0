From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 00/10] Mount, FS, Block and Keyrings notifications [ver #3]
Date: Thu, 06 Jun 2019 22:17:07 +0100
Message-ID: <23611.1559855827@warthog.procyon.org.uk>
References: <CALCETrVuNRPgEzv-XY4M9m6sEsCiRHxPenN_MpcMYc1h26vVwQ@mail.gmail.com> <b91710d8-cd2d-6b93-8619-130b9d15983d@tycho.nsa.gov> <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk> <3813.1559827003@warthog.procyon.org.uk> <8382af23-548c-f162-0e82-11e308049735@tycho.nsa.gov> <0eb007c5-b4a0-9384-d915-37b0e5a158bf@schaufler-ca.com> <c82052e5-ca11-67b5-965e-8f828081f31c@tycho.nsa.gov> <07e92045-2d80-8573-4d36-643deeaff9ec@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVuNRPgEzv-XY4M9m6sEsCiRHxPenN_MpcMYc1h26vVwQ@mail.gmail.com>
Content-ID: <23610.1559855827.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > > You are allowing arbitrary information flow between T and W above.  Who
> > > cares about notifications?
> >
> > I do. If Watched object is /dev/null no data flow is possible.
> > There are many objects on a modern Linux system for which this
> > is true. Even if it's "just a file" the existence of one path
> > for data to flow does not justify ignoring the rules for other
> > data paths.
> 
> Aha!
> 
> Even ignoring security, writes to things like /dev/null should
> probably not trigger notifications to people who are watching
> /dev/null.  (There are probably lots of things like this: /dev/zero,
> /dev/urandom, etc.)

Even writes to /dev/null might generate access notifications; leastways,
vfs_read() will call fsnotify_access() afterwards on success.

Whether or not you can set marks on open device files is another matter.

> David, are there any notification types that have this issue in your
> patchset?  If so, is there a straightforward way to fix it?

I'm not sure what issue you're referring to specifically.  Do you mean whether
writes to device files generate notifications?

> Generically, it seems like maybe writes to device nodes shouldn't trigger
> notifications since, despite the fact that different openers of a device
> node share an inode, there isn't necessarily any connection between them.

With the notification types I have currently implemented, I don't even notice
any accesses to a device file unless:

 (1) Someone mounts over the top of one.

 (2) The access triggers an I/O error or device reset or causes the device to
     be attached or detached.

 (3) Wangling the device causes some other superblock event.

 (4) The driver calls request_key() and that creates a new key.

> Casey, if this is fixed in general, do you have another case where the
> right to write and the right to read do not imply the right to
> communicate?
> 
> > An analogy is that two processes with different UIDs can open a file,
> > but still can't signal each other.
> 
> What do you mean "signal"?  If two processes with different UIDs can
> open the same file for read and write, then they can communicate with
> each other in many ways.  For example, one can write to the file and
> the other can read it.  One can take locks and the other can read the
> lock state.  They can both map it and use any number of memory access
> side channels to communicate.  But, of course, they can't send each
> other signals with kill().
> 
> If, however, one of these processes is using some fancy mechanism
> (inotify, dnotify, kqueue, fanotify, whatever) to watch the file, and
> the other one writes it, then it seems inconsistent to lie to the
> watching process and say that the file wasn't written because some
> security policy has decided to allow the write, allow the read, but
> suppress this particular notification.  Hence my request for a real
> example: when would it make sense to do this?

Note that fanotify requires CAP_SYS_ADMIN, but inotify and dnotify do not.

dnotify is applied to an open file, so it might be usable on a chardev such as
/dev/null, say.

David
