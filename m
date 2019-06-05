From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC][PATCH 0/8] Mount, FS, Block and Keyrings notifications [ver
 #2]
Date: Wed, 5 Jun 2019 09:47:56 -0400
Message-ID: <5a3353d3-3b88-6c0f-147b-6b9e2ac17773@tycho.nsa.gov>
References: <155966609977.17449.5624614375035334363.stgit@warthog.procyon.org.uk>
 <CALCETrWzDR=Ap8NQ5-YrVhXCEBgr+hwpjw9fBn0m2NkZzZ7XLQ@mail.gmail.com>
 <1207.1559680778@warthog.procyon.org.uk>
 <CALCETrXmjpSvVj_GROhgouNtbzLm5U9B4b364wycMaqApqDVNA@mail.gmail.com>
 <CAB9W1A0AgMYOwGx9c-TmAt=1O6Bjsr2P3Nhd=2+QV39dgw0CrA@mail.gmail.com>
 <CALCETrU_5djawkwW-GRyHZXHwOUjaei1Cp7NEJaVFDm_bK6G3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU_5djawkwW-GRyHZXHwOUjaei1Cp7NEJaVFDm_bK6G3w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Stephen Smalley <stephen.smalley@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

On 6/5/19 12:19 AM, Andy Lutomirski wrote:
> On Tue, Jun 4, 2019 at 6:18 PM Stephen Smalley
> <stephen.smalley@gmail.com> wrote:
>>
>> On Tue, Jun 4, 2019 at 4:58 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>
>>> On Tue, Jun 4, 2019 at 1:39 PM David Howells <dhowells@redhat.com> wrote:
>>>>
>>>> Andy Lutomirski <luto@kernel.org> wrote:
>>>>
>>>>>> Here's a set of patches to add a general variable-length notification queue
>>>>>> concept and to add sources of events for:
>>>>>
>>>>> I asked before and didn't see a response, so I'll ask again.  Why are you
>>>>> paying any attention at all to the creds that generate an event?
>>>>
>>>> Casey responded to you.  It's one of his requirements.
>>>>
>>>
>>> It being a "requirement" doesn't make it okay.
>>>
>>>> However, the LSMs (or at least SELinux) ignore f_cred and use current_cred()
>>>> when checking permissions.  See selinux_revalidate_file_permission() for
>>>> example - it uses current_cred() not file->f_cred to re-evaluate the perms,
>>>> and the fd might be shared between a number of processes with different creds.
>>>
>>> That's a bug.  It's arguably a rather severe bug.  If I ever get
>>> around to writing the patch I keep thinking of that will warn if we
>>> use creds from invalid contexts, it will warn.
>>
>>
>> No, not a bug.  Working as designed. Initial validation on open, but revalidation upon read/write if something has changed since open (process SID differs from opener, inode SID has changed, policy has changed). Current subject SID should be used for the revalidation. It's a MAC vs DAC difference.
>>
> 
> Can you explain how the design is valid, then?  Consider nasty cases like this:
> 
> $ sudo -u lotsofgarbage 2>/dev/whatever

(sorry for the previous html email; gmail or my inability to properly 
use it strikes again!)

Here we have four (or more) opportunities to say no:
1) Upon selinux_inode_permission(), when checking write access to 
/dev/whatever in the context of the shell process,
2) Upon selinux_file_open(), when checking and caching the open and 
write access for shell to /dev/whatever in the file security struct,
3) Upon selinux_bprm_committing_creds() -> flush_unauthorized_files(), 
when revalidating write access to /dev/whatever in the context of sudo,
4) Upon selinux_file_permission() -> 
selinux_revalidate_file_permission(), when revalidating write access to 
/dev/whatever in the context of sudo.

If any of those fail, then access is denied, so unless both the shell 
and sudo are authorized to write to /dev/whatever, it is a no-go.  NB 
Only the shell context requires open permission here; the sudo context 
only needs write.

> It is certainly the case that drivers, fs code, and other core code
> MUST NOT look at current_cred() in the context of syscalls like
> open().  Jann, I, and others have found quite a few rootable bugs of
> this sort.  What makes MAC special here?

Do you mean syscalls like write(), not open()?  I think your concern is 
that they apply some check only during write() and not open() and 
therefore are susceptible to confused deputy scenario above.  In 
contrast we are validating access at open, transfer/inherit, and use. If 
we use file->f_cred instead of current_cred() in 
selinux_revalidate_file_permission() and the current process SID differs 
from that of the opener, we'll never apply a check for the actual 
security context performing the write(), so information can flow in 
violation of the MAC policy.

> I would believe there are cases where auditing write() callers makes
> some sense, but anyone reading those logs needs to understand that the
> creds are dubious at best.
