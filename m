From: Loganaden Velvindron <loganaden@gmail.com>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Tue, 1 Jul 2014 22:58:16 +0400
Message-ID: <CAOp4FwR3Wn0=8ZdButz6QquaDO5RABTcfB3+TVjjZ1aYV7X8wQ@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<1404124096-21445-2-git-send-email-drysdale@google.com>
	<87mwcuw2pj.fsf@tassilo.jf.intel.com>
	<20140701095356.GC2242@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140701095356.GC2242@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 1, 2014 at 1:53 PM, David Drysdale <drysdale@google.com> wrote:
> On Mon, Jun 30, 2014 at 01:40:40PM -0700, Andi Kleen wrote:
>> David Drysdale <drysdale@google.com> writes:
>>
>> > Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> > provided path, rejecting (with -EACCES) paths that are not beneath
>> > the provided dfd.  In particular, reject:
>> >  - paths that contain .. components
>> >  - paths that begin with /
>> >  - symlinks that have paths as above.
>>
>> How about bind mounts?
>>
>> -Andi
>>
>> --
>> ak@linux.intel.com -- Speaking for myself only
>
> Bind mounts won't get rejected because they just look like normal
> path components.  In other words, if dir/subdir is a bind mount to
> /root/dir then:
>   fd = openat(AT_FDCWD, "dir/subdir", O_RDONLY|O_BENEATH_ONLY);
> will work fine.

Talking about David's efforts at porting Capsicum to Linux, I've
already implemented
support for Capsicum in OpenSSH. It shouldn't be complicated to enable
it on Linux
systems that support it.

I would very like to see capsicum integrated into mainline, as it's a
high quality sandbox
solution, that will benefit a lot of server software that implement
privilege separation.




> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
This message is strictly personal and the opinions expressed do not
represent those of my employers, either past or present.
