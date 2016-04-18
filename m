From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Mon, 18 Apr 2016 03:04:02 -0700
Message-ID: <78D99256-B41A-4A3A-85BC-7BE6BF2568F8@zytor.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com> <1460562105.353100.577697153.013DF466@webmail.messagingengine.com> <57143B74.3070302@zytor.com> <20160418015736.GA16600@x> <20160418091412.GD11600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160418091412.GD11600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>, Josh Triplett <josh@joshtriplett.org>
Cc: Colin Walters <walters@verbum.org>, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

On April 18, 2016 2:14:12 AM PDT, "Richard W.M. Jones" <rjones@redhat.com> wrote:
>On Sun, Apr 17, 2016 at 06:57:36PM -0700, Josh Triplett wrote:
>> O_NOUMASK seems potentially useful to support implementation of umask
>> entirely in userspace, which also addresses thread-safety.  A program
>> could read its process umask out at startup, handle umask entirely in
>> userspace (including for threads), and only interact with the system
>> umask after fork and before exec.
>
>I had a look at O_NOUMASK and there are a few problems:
>
>It's relatively easy to implement for open(2).  A few filesystems
>implement their own open so I had to go into those filesystems and
>modify how they handle current_umask too.  And FUSE support is tricky
>so I passed on that.
>
>The real problem is that mkdir/mkdirat/mknod/mknodat are affected by
>umask, but there is no convenient flags parameter to pass the
>O_NOUMASK flag.  So I think the patch only half-solves the problem.
>
>I have a patch which needs a bit more testing, which I can post if you
>think that's helpful, but I don't think it would be acceptable in its
>current state.
>
>Rich.

Ironically this illustrates one of the limitations with flags arguments: this really belongs in the S_-flags, but we can't assume userspace is clean there... anymore than we can repurpose umask(-1).
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
