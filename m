From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 0/4] clone: add CLONE_PIDFD
Date: Fri, 19 Apr 2019 22:05:22 +0200
Message-ID: <20190419200521.5pr66nsdj3i7liip@brauner.io>
References: <20190419120904.27502-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190419120904.27502-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 19, 2019 at 02:09:00PM +0200, Christian Brauner wrote:
> Hey,
> 
> /* v3 summary */
> After a brief discussion we decided to block CLONE_PIDFD with
> CLONE_THREAD for now.  Not because it is not possible but because we
> don't have a use-case yet and blocking it makes the initial work for
> pidfd polling easier.  However, it is possible to simply flick the
> switch later.

I have moved v3 into my for-next branch which means it should show up in
linux-next for some testing soon. All versions of the CLONE_PIDFD
patches are on top of v5.1-rc4.

Thanks!
Christian
