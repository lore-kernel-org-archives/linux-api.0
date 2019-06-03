From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Mon, 03 Jun 2019 17:30:26 +0100
Message-ID: <19414.1559579426@warthog.procyon.org.uk>
References: <c95dd6cd-5530-6b70-68f6-4038edd72352@schaufler-ca.com> <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk> <14347.1559127657@warthog.procyon.org.uk> <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com> <CAG48ez2KMrTBFzO9p8GvduXruz+FNLPyhc2YivHePsgViEoT1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c95dd6cd-5530-6b70-68f6-4038edd72352@schaufler-ca.com>
Content-ID: <19413.1559579426.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> >> should be used. Someone or something caused the event. It can
> >> be important who it was.
> > The kernel's normal security model means that you should be able to
> > e.g. accept FDs that random processes send you and perform
> > read()/write() calls on them without acting as a subject in any
> > security checks; let alone close().
> 
> Passed file descriptors are an anomaly in the security model
> that (in this developer's opinion) should have never been
> included. More than one of the "B" level UNIX systems disabled
> them outright. 

Considering further on this, I think the only way to implement what you're
suggesting is to add a field to struct file to record the last fputter's creds
as the procedure of fputting is offloaded to a workqueue.

Note that's last fputter, not the last closer, as we don't track the number of
open fds linked to a file struct.

In the case of AF_UNIX sockets that contain in-the-process-of-being-passed fds
at the time of closure, this is further complicated by the socket fput being
achieved in the work item - thereby adding layers of indirection.

It might be possible to replace f_cred rather than adding a new field, but
that might get used somewhere after that point.

Note also that fsnotify_close() doesn't appear to use the last fputter's path
since it's not available if called from deferred fput.

David
