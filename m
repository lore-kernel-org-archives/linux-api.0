From: Andy Lutomirski <luto@kernel.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Mon, 1 May 2017 12:37:49 -0700
Message-ID: <CALCETrW1uyDa7++T_SXOYUd745dB+xyqzd=61PU+iNeUzCSdAQ@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 1, 2017 at 10:36 AM, Jann Horn <jannh@google.com> wrote:
> On Sun, Apr 30, 2017 at 12:04 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> New AT_... flag - AT_NO_JUMPS
>>
>> Semantics: pathname resolution must not involve
>>         * traversals of absolute symlinks
>>         * traversals of procfs-style symlinks
>>         * traversals of mountpoints (including bindings, referrals, etc.)
>>         * traversal of .. in the starting point of pathname resolution.
>>
>> All of those lead to failure with -ELOOP.  Relative symlinks are fine,
>> as long as their resolution does not end up stepping into the conditions
>> above.
>>
>> It guarantees that result of successful pathname resolution will be on the
>> same filesystem as its starting point and within the subtree rooted at
>> the starting point.
>>
>> Right now I have it hooked only for fstatat() and friends; it could be
>> easily extended to any ...at() syscalls.  Objections?
>
> Oh, nice!
>
> It looks like this is somewhat similar to the old O_BENEATH proposal,
> but because the intentions behind the proposals are different
> (application sandboxing versus permitting an application to restrict its
> own filesystem accesses), the semantics differ: AT_NO_JUMPS
> doesn't prevent starting the path with "/", but does prevent mountpoint
> traversal. Is that correct?
>

I missed that.  I think that AT_HOTEL_CALIFORNIA or whatever we call
it should disallow even explicit absolute paths.  If I do:

openat([fd to /var/www], "possibly untrusted path here",
AT_HOTEL_CALIFORNIA, O_WHATEVER);

I should not have to separately verify that the path doesn't start
with "/" to make sure that I don't escape.  There's a big added
advantage of this approach, too: I could write a seccomp rule that
only lets me call openat() with this new flag set, and now I can't
escape.


> I think that, as Andy mentioned, it might make sense to split out (or
> even remove?) the prevention of mountpoint traversal. A user who
> can create visible mountpoints needs to have capabilities over the
> mount namespace the file descriptor refers to already.

Agreed.  There's a big difference between the admin bind-mounting /etc
into /var/www and some web app putting a symlink to /etc into
/var/www.
