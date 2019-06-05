From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver #2]
Date: Wed, 05 Jun 2019 09:41:34 +0100
Message-ID: <20192.1559724094@warthog.procyon.org.uk>
References: <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com> <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk> <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com>
Content-ID: <20191.1559724094.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> I will try to explain the problem once again. If process A
> sends a signal (writes information) to process B the kernel
> checks that either process A has the same UID as process B
> or that process A has privilege to override that policy.
> Process B is passive in this access control decision, while
> process A is active. In the event delivery case, process A
> does something (e.g. modifies a keyring) that generates an
> event, which is then sent to process B's event buffer.

I think this might be the core sticking point here.  It looks like two
different situations:

 (1) A explicitly sends event to B (eg. signalling, sendmsg, etc.)

 (2) A implicitly and unknowingly sends event to B as a side effect of some
     other action (eg. B has a watch for the event A did).

The LSM treats them as the same: that is B must have MAC authorisation to send
a message to A.

But there are problems with not sending the event:

 (1) B's internal state is then corrupt (or, at least, unknowingly invalid).

 (2) B can potentially figure out that the event happened by other means.


I've implemented four event sources so far:

 (1) Keys/keyrings.  You can only get events on a key you have View permission
     on and the other process has to have write access to it, so I think this
     is good enough.

 (2) Block layer.  Currently this will only get you hardware error events,
     which is probably safe.  I'm not sure you can manipulate those without
     permission to directly access the device files.

 (3) Superblock.  This is trickier since it can see events that can be
     manufactured (R/W <-> R/O remounting, EDQUOT) as well as events that
     can't without hardware control (EIO, network link loss, RF kill).

 (4) Mount topology.  This is the trickiest since it allows you to see events
     beyond the point at which you placed your watch (in essence, you place a
     subtree watch).

     The question is what permission checking should I do?  Ideally, I'd
     emulate a pathwalk between the watchpoint and the eventing object to see
     if the owner of the watchpoint could reach it.

     I'd need to do a reverse walk, calling inode_permission(MAY_NOT_BLOCK)
     for each directory between the eventing object and the watchpoint to see
     if one rejects it - but some filesystems have a permission check that
     can't be called in this state.

     It would also be necessary to do this separately for each watchpoint in
     the parental chain.

     Further, each permissions check would generate an audit event and could
     generate FAN_ACCESS and/or FAN_ACCESS_PERM fanotify events - which could
     be a problem if fanotify is also trying to post those events to the same
     watch queue.

David
