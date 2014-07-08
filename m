From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Tue, 8 Jul 2014 17:54:24 +0100
Message-ID: <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <20140708120331.GA30459@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140708120331.GA30459-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 8, 2014 at 1:03 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Jun 30, 2014 at 11:28:01AM +0100, David Drysdale wrote:
>> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> provided path, rejecting (with -EACCES) paths that are not beneath
>> the provided dfd.  In particular, reject:
>>  - paths that contain .. components
>>  - paths that begin with /
>>  - symlinks that have paths as above.
>
>
> How is this implemented in FreeBSD?  I can't find any references to
> O_BENEATH_ONLY except for your patchset.

FreeBSD have the relative-only behaviour for openat() relative to a
Capsicum capability dfd [1], and for a process in capability-mode [2],
but they don't have the O_BENEATH_ONLY as a separately-accessible
openat() flag.  However, it seemed like a more widely useful idea so
separating it out was suggested.

[1] http://fxr.watson.org/fxr/source/kern/vfs_lookup.c?v=FREEBSD10#L238
[2] http://fxr.watson.org/fxr/source/kern/vfs_lookup.c?v=FREEBSD10#L171
