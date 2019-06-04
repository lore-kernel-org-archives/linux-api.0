From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver #2]
Date: Tue, 04 Jun 2019 21:39:38 +0100
Message-ID: <1207.1559680778@warthog.procyon.org.uk>
References: <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com> <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
Content-ID: <1206.1559680778.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > Here's a set of patches to add a general variable-length notification queue
> > concept and to add sources of events for:
> 
> I asked before and didn't see a response, so I'll ask again.  Why are you
> paying any attention at all to the creds that generate an event?

Casey responded to you.  It's one of his requirements.

I'm not sure of the need, and I particularly don't like trying to make
indirect destruction events (mount destruction keyed on fput, for instance)
carry the creds of the triggerer.  Indeed, the trigger can come from all sorts
of places - including af_unix queue destruction, someone poking around in
procfs, a variety of processes fputting simultaneously.  Only one of them can
win, and the LSM needs to handle *all* the possibilities.

However, the LSMs (or at least SELinux) ignore f_cred and use current_cred()
when checking permissions.  See selinux_revalidate_file_permission() for
example - it uses current_cred() not file->f_cred to re-evaluate the perms,
and the fd might be shared between a number of processes with different creds.

> This seems like the wrong approach.  If an LSM wants to prevent covert
> communication from, say, mount actions, then it shouldn't allow the
> watch to be set up in the first place.

Yeah, I can agree to that.  Casey?

David
