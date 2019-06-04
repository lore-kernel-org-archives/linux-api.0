From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver
 #2]
Date: Tue, 4 Jun 2019 14:11:45 -0700
Message-ID: <3ca991d1-4056-c45b-dbae-9976fb5d81e0@schaufler-ca.com>
References: <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
 <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <1207.1559680778@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1207.1559680778@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, casey@schaufler-ca.com
List-Id: linux-api@vger.kernel.org

On 6/4/2019 1:39 PM, David Howells wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>>> Here's a set of patches to add a general variable-length notification=
 queue
>>> concept and to add sources of events for:
>> I asked before and didn't see a response, so I'll ask again.  Why are =
you
>> paying any attention at all to the creds that generate an event?
> Casey responded to you.  It's one of his requirements.

Process A takes an action. As a result of that action,
an event is written to Process B's event buffer. This isn't
a covert channel, it's a direct access, just like sending
a signal. Process A is the subject and the event buffer,
which is part of Process B, is the object.


> I'm not sure of the need, and I particularly don't like trying to make
> indirect destruction events (mount destruction keyed on fput, for insta=
nce)
> carry the creds of the triggerer.  Indeed, the trigger can come from al=
l sorts
> of places - including af_unix queue destruction, someone poking around =
in
> procfs, a variety of processes fputting simultaneously.  Only one of th=
em can
> win, and the LSM needs to handle *all* the possibilities.

Yes, it's a hairy problem. It was a significant factor in the
demise of kdbus.

> However, the LSMs (or at least SELinux) ignore f_cred and use current_c=
red()
> when checking permissions.  See selinux_revalidate_file_permission() fo=
r
> example - it uses current_cred() not file->f_cred to re-evaluate the pe=
rms,
> and the fd might be shared between a number of processes with different=
 creds.
>
>> This seems like the wrong approach.  If an LSM wants to prevent covert=

>> communication from, say, mount actions, then it shouldn't allow the
>> watch to be set up in the first place.
> Yeah, I can agree to that.  Casey?

Back to your earlier point, you don't know where the
event is coming from when you create the event watch.
If you enforce a watch time, what are you going to check?
Isn't this going to be considered too restrictive?
