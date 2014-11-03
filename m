From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon, 3 Nov 2014 17:37:37 +0000
Message-ID: <CAHse=S9AGNF84cLYszPSM2q7-78+KfuTCoap7eYyMEcbx97Zyw@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk>
 <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 3:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>>> Add a new O_BENEATH flag for openat(2) which restricts the
>>> provided path, rejecting (with -EACCES) paths that are not beneath
>>> the provided dfd.  In particular, reject:
>>>  - paths that contain .. components
>>>  - paths that begin with /
>>>  - symlinks that have paths as above.
>>
>> Yecch...  The degree of usefulness aside (and I'm not convinced that it
>> is non-zero),
>
> This is extremely useful in conjunction with seccomp.

Yes, that was my understanding of how the Chrome[OS] folk wanted
to use it.

>> WTF pass one bit out of nameidata->flags in a separate argument?

I'll shift to using nd->flags; not sure what I was thinking of there.

(It *might* have made more sense in the full patchset this was extracted
from but it certainly doesn't look sensible in this narrower context.)

>> Through the mutual recursion, no less...  And then you are not even attempting
>> to detect symlinks that are not followed by interpretation of _any_ pathname.
>
> How many symlinks like that are there?  Is there anything except
> nd_jump_link users?  All of those are in /proc.  Arguably O_BENEATH
> should prevent traversal of all of those links.
>
> --Andy

On a quick search, the 2 users of nd_jump_link (namely proc_pid_follow_link
and proc_ns_follow_link) seem to be the only implementations of
inode_operations->follow_link that don't just call nd_set_link().  So
disallowing that for O_BENEATH might give sensible behaviour.
