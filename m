From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Tue, 16 Apr 2019 20:32:50 +0200
Message-ID: <000a64d6-1e22-21bf-f232-15f141092e44@metux.net>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415155034.GA25351@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190415155034.GA25351@mail.hallyn.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <christian@brauner.io>, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 15.04.19 17:50, Serge E. Hallyn wrote:

Hi,

>> I'm working on implementing plan9-like fs namespaces, where unprivileged>> processes can change their own namespace at will. For that, certain>
> Is there any place where we can see previous discussion about this?
Yes, lkml and constainers list.
It's stalled since few month, as I'm too busy w/ other things.

> If you have to disable suid anyway, then is there any reason why the> existing ability to do this in a private user namespace, with only>
your own uid mapped (which you can do without any privilege) does> not
suffice?  That was actually one of the main design goals of user>
namespaces, to be able to clone(CLONE_NEWUSER), map your current uid,>
then clone(CLONE_NEWNS) and bind mount at will.
Well, it's not that easy ... maybe I should explain a bit more about how
Plan9 works, and how I intent to map it into Linux:

* on plan9, anybody can alter his own fs namespace (bind and mount), as
  well as spawning new ones
* basically anything is coming from some fileserver - even devices
  (eg. there is no such thing like device nodes)
* access control is done by the individual fileservers, based on the
  initial authentication (on connecting to the server, before mounting)
* all users are equal - no root at all. the only exception is the
  initial process, which gets the kernel devices mounted into his
  namespace.

What I'd like to achieve on Linux:

* unprivileged users can have their own mount namespace, where they
  can mount at will (maybe just 9P).
* but they still appear as the same normal users to the rest of the
  system
* 9p programs (compiled for Linux ABI) can run parallel to traditional
  linux programs within the same user and sessions (eg. from a terminal,
  i can call both the same way)
* namespace modifications affect both equally (eg. I could run ff in
  an own ns)
* these namespaces exist as long as there's one process alive in here
* creating a new ns can be done by unprivileged user
 One of the things to make this work (w/o introducing a massive security
hole) is disable suid for those processes (actually, one day i'd like to
get rid of it completely, but that's another story).


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
