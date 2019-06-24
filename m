From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] samples: make pidfd-metadata fail gracefully on older
 kernels
Date: Mon, 24 Jun 2019 11:52:50 +0200
Message-ID: <20190624095250.wtl5t5cewo7scyby@brauner.io>
References: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
 <20190620110037.GA4998@altlinux.org>
 <20190620111036.asi3mbcv4ax5ekrw@brauner.io>
 <20190621170613.GA26182@altlinux.org>
 <20190621221339.6yj4vg4zexv4y2j7@brauner.io>
 <20190623113230.GC20697@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190623113230.GC20697@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Jun 23, 2019 at 02:32:30PM +0300, Dmitry V. Levin wrote:
> On Sat, Jun 22, 2019 at 12:13:39AM +0200, Christian Brauner wrote:
> [...]
> > Out of curiosity: what makes the new flag different than say
> > CLONE_NEWCGROUP or any new clone flag that got introduced?
> > CLONE_NEWCGROUP too would not be detectable apart from the method I gave
> > you above; same for other clone flags. Why are you so keen on being able
> > to detect this flag when other flags didn't seem to matter that much.
> 
> I wasn't following uapi changes closely enough those days. ;)

(Seriously, you had one job. :) I'm joking of course.)

What you want makes sense to me overall. This way userspace can decide
easier whether to manage a process through a pidfd or needs to fallback
to a pid.

Christian
