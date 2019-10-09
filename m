From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH RFC 3/3] openat2.2: document new openat2(2) syscall
Date: Wed, 9 Oct 2019 12:32:19 +0200
Message-ID: <3bc4295a-45c3-53d4-a10a-44c56018f151@gmail.com>
References: <20191003145542.17490-1-cyphar@cyphar.com>
 <20191003145542.17490-4-cyphar@cyphar.com>
 <b52e4a93-a3de-dcbf-3684-bb2c355f3f24@gmail.com>
 <20191009101733.kgbg2aekjguykddu@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191009101733.kgbg2aekjguykddu@yavin>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: mtk.manpages@gmail.com, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Aleksa,

On 10/9/19 12:17 PM, Aleksa Sarai wrote:
> On 2019-10-09, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
>> Hello Aleksa,
>>
>> Thanks for this. It's a great piece of documentation work!
>>
>> I would prefer the path_resolution(7) piece as a separate patch.
> 
> Thanks, and will do.
> 
>> On 10/3/19 4:55 PM, Aleksa Sarai wrote:
>>> Rather than trying to merge the new syscall documentation into open.2
>>> (which would probably result in the man-page being incomprehensible),
>>> instead the new syscall gets its own dedicated page with links between
>>> open(2) and openat2(2) to avoid duplicating information such as the list
>>> of O_* flags or common errors.
>>
>> Yes, looking at the size of the proposed openat2(2) page,
>> this seems best.
>>>
>>> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
>>> ---

[...]

>>> diff --git a/man2/openat2.2 b/man2/openat2.2
>>> new file mode 100644
>>> index 000000000000..c43c76046243
>>> --- /dev/null
>>> +++ b/man2/openat2.2

[...]

>>> +.TP
>>> +.B RESOLVE_NO_SYMLINKS
>>> +Disallow all symlink resolution during path resolution. If the trailing
>>
>> Disallow resolution of symbolic links during path resolution
>>
>>> +component is a symlink, and
>>
>> symbolic link (throughout the page)
>>
>>> +.I flags
>>> +contains both
>>> +.BR O_PATH " and " O_NOFOLLOW ","
>>> +then an
>>> +.B O_PATH
>>> +file descriptor referencing the symlink will be returned. This option implies
>>> +.BR RESOLVE_NO_MAGICLINKS .
>>> +
>>> +Users of this flag are encouraged to make its use configurable (unless it is
>>> +used for a specific security purpose), as symlinks are very widely used by
>>> +end-users and thus enabling this flag globally may result in spurious errors on
>>> +some systems.
>>
>> It's not really clear what you mean by "enabling this flag globally".
>> Could you reword, or explain in a bit more detail?
> 
> A better word might be "indiscriminately" -- the point being that if
> a program uses it for every openat2() call (and users cannot disable
> it), then the program will break on all sorts of systems.

Okay -- could you please amend the text to say something more like what
you just clarified.

> 
>>> +.TP
>>> +.B RESOLVE_NO_MAGICLINKS
>>> +Disallow all magic-link resolution during path resolution. If the trailing
>>> +component is a magic-link, and
>>> +.I flags
>>> +contains both
>>> +.BR O_PATH " and " O_NOFOLLOW ","
>>> +then an
>>> +.B O_PATH
>>> +file descriptor referencing the magic-link will be returned.
>>> +
>>> +Magic-links are symlink-like objects that are most notably found in
>>> +.BR proc (5)
>>> +(examples include
>>> +.IR /proc/[pid]/exe " and " /proc/[pid]/fd/* .)
>>> +Due to the potential danger of unknowingly opening these magic-links, it may be
>>> +preferable for users to disable their resolution entirely (see
>>> +.BR symlink (7)
>>> +for more details.)
>>> +.TP
>>> +.B RESOLVE_BENEATH
>>> +Do not permit the path resolution to succeed if any component of the resolution
>>> +is not a descendant of the directory indicated by
>>> +.IR dirfd .
>>> +This results in absolute symlinks (and absolute values of
>>> +.IR pathname )
>>> +to be rejected. Magic-link resolution is also not permitted.
>>
>> So, this flag implies RESOLVE_NO_MAGICLINKS? If yes,
>> it would be good to state that more explicitly,
> 
> It does, though this might change in the future (some magic-link
> resolutions might be safe -- but it's unclear what the semantics should
> be). Users should explicitly set RESOLVE_NO_MAGICLINKS if they really
> don't want to resolve them.

Okay -- I understand. Perhaps you could then at least say something like:

Currently, this flag also disable magic-link resolution. However, this
may change in the future. The caller should explicitly specify
RESOLVE_NO_MAGICLINKS to ensure that magic links are not resolved.

>>> +
>>> +.TP
>>> +.B RESOLVE_IN_ROOT
>>> +Temporarily treat
>>> +.I dirfd
>>> +as the root of the filesystem (as though the user called
>>
>> Perhaps better:
>>
>> Treat
>> .I dirfd
>> as the root directory while resolving
>> .I pathname
>> (as though...)
> 
> Yeah that sounds better.
> 
>>> +.BR chroot (2)
>>> +with
>>> +.IR dirfd
>>> +as the argument.) Absolute symlinks and ".." path components will be scoped to
>>> +.IR dirfd . Magic-link resolution is also not permitted.
>>
>> Insert a newline before "Magic" to fix a formatting problem.
>>
>> So, this flag implies RESOLVE_NO_MAGICLINKS? If yes,
>> it would be good to state that more explicitly,
> 
> Same reply as above.

See above :-)

[...]

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
