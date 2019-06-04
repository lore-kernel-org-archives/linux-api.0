From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 1/8] security: Override creds in __fput() with last
 fputter's creds [ver #2]
Date: Tue, 4 Jun 2019 11:15:14 -0700
Message-ID: <CALCETrXLoowmrHHWWr3OqsOGBkyGsV_x0nADaEyv+_ysGQdM3g@mail.gmail.com>
References: <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <155966611030.17449.1411028213562548153.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155966611030.17449.1411028213562548153.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 4, 2019 at 9:35 AM David Howells <dhowells@redhat.com> wrote:
>
> So that the LSM can see the credentials of the last process to do an fput()
> on a file object when the file object is being dismantled, do the following
> steps:
>
>  (1) Cache the current credentials in file->f_fput_cred at the point the
>      file object's reference count reaches zero.

I don't think it's valid to capture credentials in close().  This
sounds very easy to spoof, especially when you consider that you can
stick an fd in unix socket and aim it at a service that's just going
to ignore it and close it.

IOW I think this is at least as invalid as looking at current_cred()
in write(), which is a classic bug that gets repeated regularly.

--Andy
