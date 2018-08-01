From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Wed, 1 Aug 2018 16:19:15 +0200
Message-ID: <20180801141914.GA21248@redhat.com>
References: <20180730075241.24002-1-j@bitron.ch>
 <20180731070337.61004-1-j@bitron.ch>
 <20180731143949.GA1890@redhat.com>
 <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/31, Jürg Billeter wrote:
>
> > Could you explain your use-case? Why a shell wants to use
> > CLONE_NEWPID?
>
> To guarantee that there won't be any runaway processes, i.e., ensure
> that no descendants (background helper daemons or misbehaving
> processes) survive when the child process is terminated.

We already have PR_SET_CHILD_SUBREAPER.

Perhaps we can finally add PR_KILL_MY_DESCENDANTS_ON_EXIT? This was already
discussed some time ago, but I can't find the previous discussion... Simple
to implement.

> And to prevent
> children from killing their ancestors.

OK, this is the only reason for CLONE_NEWPID which I can understand so far.
Not that I understand why this is that useful ;)

> > >  * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
> > >    itself, it's not possible to implement the stop action in a custom
> > >    SIGTSTP handler.
> >
> > Yes. So may be we actually want to change __isig() paths to use
> > SEND_SIG_FORCED (this is not that simple), or perhaps we can change
> > __send_signal() to not drop SIGSTOP sent to itself, or may be we can even
> > introduce SIG_DFL_EVEN_IF_INIT, I dunno.
>
> In my opinion, my patch is much simpler and also more general as it

Yes, yes, let me repeat that I am not arguing with your patch, I am just trying
to understand what

> > I can't understand this. An application should be changed anyway to do
> > PR_SET_KILLABLE?
>
> PR_SET_KILLABLE can be called (e.g., by the shell) between clone() and
> execve().

OK, this is true.

Oleg.
