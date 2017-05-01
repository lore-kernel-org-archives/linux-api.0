From: Jann Horn <jannh@google.com>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Mon, 1 May 2017 19:36:52 +0200
Message-ID: <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170429220414.GT29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux API <linux-api@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Apr 30, 2017 at 12:04 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> New AT_... flag - AT_NO_JUMPS
>
> Semantics: pathname resolution must not involve
>         * traversals of absolute symlinks
>         * traversals of procfs-style symlinks
>         * traversals of mountpoints (including bindings, referrals, etc.)
>         * traversal of .. in the starting point of pathname resolution.
>
> All of those lead to failure with -ELOOP.  Relative symlinks are fine,
> as long as their resolution does not end up stepping into the conditions
> above.
>
> It guarantees that result of successful pathname resolution will be on the
> same filesystem as its starting point and within the subtree rooted at
> the starting point.
>
> Right now I have it hooked only for fstatat() and friends; it could be
> easily extended to any ...at() syscalls.  Objections?

Oh, nice!

It looks like this is somewhat similar to the old O_BENEATH proposal,
but because the intentions behind the proposals are different
(application sandboxing versus permitting an application to restrict its
own filesystem accesses), the semantics differ: AT_NO_JUMPS
doesn't prevent starting the path with "/", but does prevent mountpoint
traversal. Is that correct?

I think that, as Andy mentioned, it might make sense to split out (or
even remove?) the prevention of mountpoint traversal. A user who
can create visible mountpoints needs to have capabilities over the
mount namespace the file descriptor refers to already.

I suspect that if this lands, it would be pretty straightforward to add
another flag AT_NO_ABSOLUTE or so that, combined with
AT_NO_JUMPS, has the same semantics as O_BENEATH?
