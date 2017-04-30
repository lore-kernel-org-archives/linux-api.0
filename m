From: Andy Lutomirski <luto@kernel.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Sat, 29 Apr 2017 18:13:27 -0700
Message-ID: <CALCETrVue8VyJDUSgy9Hsw67mxddirwDr703OBM_fWm9Hzvb4A@mail.gmail.com>
References: <20170429220414.GT29622@ZenIV.linux.org.uk> <CALCETrXhOhG0tRDDOROwT9ghvQvKziM2PBN=CX5Soa2m7=0cFw@mail.gmail.com>
 <20170429232504.GU29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170429232504.GU29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Apr 29, 2017 at 4:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Apr 29, 2017 at 04:17:18PM -0700, Andy Lutomirski wrote:
>> On Sat, Apr 29, 2017 at 3:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > New AT_... flag - AT_NO_JUMPS
>> >
>> > Semantics: pathname resolution must not involve
>> >         * traversals of absolute symlinks
>> >         * traversals of procfs-style symlinks
>> >         * traversals of mountpoints (including bindings, referrals, etc.)
>> >         * traversal of .. in the starting point of pathname resolution.
>>
>> Can you clarify this last one?  I assume that ".." will be rejected,
>> but what about "a/../.."?  How about "b" if b is a symlink to ".."?
>> How about "a/b" if a is a directory and b is a symlink to "../.."?
>
> All of those will be rejected - in each of those cases pathname traversal
> leads back into the starting point with .. being the next component to
> handle.

Sounds good.

Might it make sense to split it into two flags, one to prevent moving
between mounts and one for everything else?  I can imagine webservers
and such that are fine with traversing mount points but don't want to
escape their home directory.

--Andy
