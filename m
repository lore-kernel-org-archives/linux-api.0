From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver #2]
Date: Tue, 4 Jun 2019 13:57:30 -0700
Message-ID: <CALCETrXmjpSvVj_GROhgouNtbzLm5U9B4b364wycMaqApqDVNA@mail.gmail.com>
References: <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com> <1207.1559680778@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1207.1559680778@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 4, 2019 at 1:39 PM David Howells <dhowells@redhat.com> wrote:
>
> Andy Lutomirski <luto@kernel.org> wrote:
>
> > > Here's a set of patches to add a general variable-length notification queue
> > > concept and to add sources of events for:
> >
> > I asked before and didn't see a response, so I'll ask again.  Why are you
> > paying any attention at all to the creds that generate an event?
>
> Casey responded to you.  It's one of his requirements.
>

It being a "requirement" doesn't make it okay.

> However, the LSMs (or at least SELinux) ignore f_cred and use current_cred()
> when checking permissions.  See selinux_revalidate_file_permission() for
> example - it uses current_cred() not file->f_cred to re-evaluate the perms,
> and the fd might be shared between a number of processes with different creds.

That's a bug.  It's arguably a rather severe bug.  If I ever get
around to writing the patch I keep thinking of that will warn if we
use creds from invalid contexts, it will warn.

Let's please not repeat this.
