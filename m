From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Mon, 29 Apr 2019 19:31:43 +0200
Message-ID: <c95fbdbb-a62b-4ad1-f4be-7d1a8f96f508@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415155034.GA25351@mail.hallyn.com>
 <000a64d6-1e22-21bf-f232-15f141092e44@metux.net>
 <20190429154949.GA23456@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429154949.GA23456@mail.hallyn.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <christian@brauner.io>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 29.04.19 17:49, Serge E. Hallyn wrote:

>> * all users are equal - no root at all. the only exception is the>>   initial process, which gets the kernel devices mounted into his>>
 namespace.> > This does not match my understanding, but I'm most likely
wrong.  (I thought> there was an actual 'host owner' uid, which mostly
is only used for initial> process, but is basically root with a
different name, and used far less.  No> uid transitions without factotem
so that it *looked* like no root user).
Not quite (IIRC). The hostowner is just the user who booted the machine,
the initial process runs under this uname and gets the kernel devices
bound into his namespace, so he can start fileservers on them.

Also the caphash device (the one you can create capabilities, eg. for
user change, which then can be used via capuse device) can only be
opened once - usually by the host factotum.

There really is no such thing like root user.

>> What I'd like to achieve on Linux:>>>> * unprivileged users can have their own mount namespace, where
they>>   can mount at will (maybe just 9P).> > No problem, you can do
that now.
But only within separate userns, IMHO. (and, when I last tried, plain
users couldn't directly create their userns).

>> * but they still appear as the same normal users to the rest of the
>>   system
> 
> No problem, you can do that now.

How exactly ? Did I miss something vital ?

>> * 9p programs (compiled for Linux ABI) can run parallel to traditional
>>   linux programs within the same user and sessions (eg. from a terminal,
>>   i can call both the same way)
>> * namespace modifications affect both equally (eg. I could run ff in
>>   an own ns)
> 
> affect both of what equally?

mount / bind.

> That's exactly what user namespaces are for.  You can create a new
> user namespace, using no privilege at all, with your current uid (i.e.
> 1000) mapped to whatever uid you like; if you pick 0, then you can unshare all
> the namespaces you like.  

But I don't like to appear as 'root' in here. I just wanna have my own
filesystem namespace, nothing more.

> Once you unshare mnt_ns, you can mount to your
> heart's content.  To other processes on the host, your process is
> uid 1000.

Is that the uid, I'm appearing to filesystems ?

> Regarding factotem, I agree that with the pidfd work going on etc, it's getting
> more and more tempting to attempt a switch to that.  Looking back at my folder,
> I see you posted a kernel patch for it.  I had done the same long ago.  Happy to
> work with you again on that, and put a simple daemon into shadow package, if
> util-linux isn't deemed the far better place.

Yeah :)


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
