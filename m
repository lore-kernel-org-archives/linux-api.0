From: David Howells <dhowells@redhat.com>
Subject: Rational model for UID based controls
Date: Wed, 05 Jun 2019 17:56:47 +0100
Message-ID: <18357.1559753807@warthog.procyon.org.uk>
References: <e4c19d1b-9827-5949-ecb8-6c3cb4648f58@schaufler-ca.com> <50c2ea19-6ae8-1f42-97ef-ba5c95e40475@schaufler-ca.com> <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk> <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com> <20192.1559724094@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e4c19d1b-9827-5949-ecb8-6c3cb4648f58@schaufler-ca.com>
Content-ID: <18356.1559753807.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> YES!

I'm trying to decide if that's fervour or irritation at this point ;-)

> And it would be really great if you put some thought into what
> a rational model would be for UID based controls, too.

I have put some thought into it, but I don't see a single rational model.  It
depends very much on the situation.

In any case, that's what I was referring to when I said I might need to call
inode_permission().  But UIDs don't exist for all filesystems, for example,
and there are no UIDs on superblocks, mount objects or hardware events.

Now, I could see that you ignore UIDs on things like keys and
hardware-triggered events, but how does this interact with things like mount
watches that see directories that have UIDs?

Are you advocating making it such that process B can only see events triggered
by process A if they have the same UID, for example?

David
