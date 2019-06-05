From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver #2]
Date: Tue, 4 Jun 2019 21:19:22 -0700
Message-ID: <CALCETrU_5djawkwW-GRyHZXHwOUjaei1Cp7NEJaVFDm_bK6G3w@mail.gmail.com>
References: <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
 <1207.1559680778@warthog.procyon.org.uk> <CALCETrXmjpSvVj_GROhgouNtbzLm5U9B4b364wycMaqApqDVNA@mail.gmail.com>
 <CAB9W1A0AgMYOwGx9c-TmAt=1O6Bjsr2P3Nhd=2+QV39dgw0CrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAB9W1A0AgMYOwGx9c-TmAt=1O6Bjsr2P3Nhd=2+QV39dgw0CrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <stephen.smalley@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 4, 2019 at 6:18 PM Stephen Smalley
<stephen.smalley@gmail.com> wrote:
>
> On Tue, Jun 4, 2019 at 4:58 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On Tue, Jun 4, 2019 at 1:39 PM David Howells <dhowells@redhat.com> wrote=
:
>> >
>> > Andy Lutomirski <luto@kernel.org> wrote:
>> >
>> > > > Here's a set of patches to add a general variable-length notificat=
ion queue
>> > > > concept and to add sources of events for:
>> > >
>> > > I asked before and didn't see a response, so I'll ask again.  Why ar=
e you
>> > > paying any attention at all to the creds that generate an event?
>> >
>> > Casey responded to you.  It's one of his requirements.
>> >
>>
>> It being a "requirement" doesn't make it okay.
>>
>> > However, the LSMs (or at least SELinux) ignore f_cred and use current_=
cred()
>> > when checking permissions.  See selinux_revalidate_file_permission() f=
or
>> > example - it uses current_cred() not file->f_cred to re-evaluate the p=
erms,
>> > and the fd might be shared between a number of processes with differen=
t creds.
>>
>> That's a bug.  It's arguably a rather severe bug.  If I ever get
>> around to writing the patch I keep thinking of that will warn if we
>> use creds from invalid contexts, it will warn.
>
>
> No, not a bug.  Working as designed. Initial validation on open, but reva=
lidation upon read/write if something has changed since open (process SID d=
iffers from opener, inode SID has changed, policy has changed). Current sub=
ject SID should be used for the revalidation. It's a MAC vs DAC difference.
>

Can you explain how the design is valid, then?  Consider nasty cases like t=
his:

$ sudo -u lotsofgarbage 2>/dev/whatever

It is certainly the case that drivers, fs code, and other core code
MUST NOT look at current_cred() in the context of syscalls like
open().  Jann, I, and others have found quite a few rootable bugs of
this sort.  What makes MAC special here?

I would believe there are cases where auditing write() callers makes
some sense, but anyone reading those logs needs to understand that the
creds are dubious at best.
