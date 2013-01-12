From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
	format (v2)
Date: Sat, 12 Jan 2013 19:55:24 +0100
Message-ID: <20130112185524.GA26170@redhat.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org> <1356690181-1796-3-git-send-email-avagin@openvz.org> <20121228161436.GA30459@redhat.com> <CANaxB-xupOxkyd3-tdJSeW7y+1DQzMr-3Pxnmx17Y=ocDU1VTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANaxB-xupOxkyd3-tdJSeW7y+1DQzMr-3Pxnmx17Y=ocDU1VTA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Wagin <avagin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On 01/10, Andrey Wagin wrote:
>
> 2012/12/28 Oleg Nesterov <oleg@redhat.com>:
> >>
> >> This functionality is required for checkpointing pending signals.
> >
> > And this should be used along with pread().
> >
> > I won't argue, but perhaps we should simply postulate that pread()
> > always dumps siginfo in raw format and avoid the new flag?
>
> I won't argue too:), but I think the flag is more flexiable. The flag
> allows to get raw siginfo from read(), it may be useful not only for
> checkpoint/restore. pread with offset = 0 is equal to read(), so the
> interface with the flag is more clear.

OK, I agree.

Oleg.

