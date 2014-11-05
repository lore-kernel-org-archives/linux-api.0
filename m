From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Wed, 5 Nov 2014 17:21:48 +0000
Message-ID: <CAHse=S8ZmYLkOb9hmOMPkvHabqXH1sCUBTJWVO-++PMJXES=sg@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
 <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk>
 <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
 <d0973f4d-e8a4-4c5c-8bd1-1b1cb1f080b5@email.android.com> <CAHse=S-d3beytm2AKyBjZORdJPffmjfa2Ua1VCU8VjoRE9RiYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHse=S-d3beytm2AKyBjZORdJPffmjfa2Ua1VCU8VjoRE9RiYQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W.Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 4, 2014 at 9:40 AM, David Drysdale <drysdale@google.com> wrote:
> On Mon, Nov 3, 2014 at 5:22 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
>> On November 3, 2014 7:42:58 AM PST, Andy Lutomirski <luto@amacapital.net> wrote:
>>>On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro@zeniv.linux.org.uk>
>>>wrote:
>>>> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>>>>> Add a new O_BENEATH flag for openat(2) which restricts the
>>>>> provided path, rejecting (with -EACCES) paths that are not beneath
>>>>> the provided dfd.  In particular, reject:
>>>>>  - paths that contain .. components
>>>>>  - paths that begin with /
>>>>>  - symlinks that have paths as above.
>>>>
>>>> Yecch...  The degree of usefulness aside (and I'm not convinced that
>>>it
>>>> is non-zero),
>>>
>>>This is extremely useful in conjunction with seccomp.
>>>
>>>> WTF pass one bit out of nameidata->flags in a separate argument?
>>>> Through the mutual recursion, no less...  And then you are not even
>>>attempting
>>>> to detect symlinks that are not followed by interpretation of _any_
>>>pathname.
>>>
>>>How many symlinks like that are there?  Is there anything except
>>>nd_jump_link users?  All of those are in /proc.  Arguably O_BENEATH
>>>should prevent traversal of all of those links.
>>
>> Not commenting on the sanity of this one way or another, and I haven't read the patch.  There is an absolutely trivial implementation of this.
>>
>> After the path is resolved, walk backwards along d_parent and the mount tree, and see if you come to the file or directory dfd refers to.
>>
>> That can handle magic proc symlinks, and does not need to disallow .. or / explicitly so it should be much simpler code.
>>
>> My gut says that if Al says blech when looking at your code it is too complex to give you a security guarantee.
>>
>> Eric
>
> Well, the 'yecch' was deserved for the unnecessary duplication of the
> flags.  Without that, the patch looks much simpler -- I'll send out a v2
> with those changes for discussion, and think about your alternative
> implementation suggestion (thanks!) separately.

One concern with the "walk upwards and see if you get back where you
started" approach -- it will allow use of a symlink that lives outside the
original directory, but which points back inside it.  That's going to be
slightly surprising behaviour for users, and I worry that there's the
potential for unexpected information leakage from it.

(BTW, size-wise my initial naive implementation of the walk-upward
approach is only marginally smaller than the v2 patch.)
