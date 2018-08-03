From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Fri, 3 Aug 2018 14:14:07 +0200
Message-ID: <20180803121406.GB13794@redhat.com>
References: <20180730075241.24002-1-j@bitron.ch>
 <20180731070337.61004-1-j@bitron.ch>
 <20180731143949.GA1890@redhat.com>
 <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
 <20180801141914.GA21248@redhat.com>
 <7f7c57230e0279f4599bf13ae1d1d449d76ac232.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7f7c57230e0279f4599bf13ae1d1d449d76ac232.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/03, Jürg Billeter wrote:
>
> On Wed, 2018-08-01 at 16:19 +0200, Oleg Nesterov wrote:
> > On 07/31, Jürg Billeter wrote:
> > >
> > > > Could you explain your use-case? Why a shell wants to use
> > > > CLONE_NEWPID?
> > >
> > > To guarantee that there won't be any runaway processes, i.e., ensure
> > > that no descendants (background helper daemons or misbehaving
> > > processes) survive when the child process is terminated.
> >
> > We already have PR_SET_CHILD_SUBREAPER.
> >
> > Perhaps we can finally add PR_KILL_MY_DESCENDANTS_ON_EXIT? This was already
> > discussed some time ago, but I can't find the previous discussion... Simple
> > to implement.
>
> This would definitely be an option. You mentioned it last October in
> the PR_SET_PDEATHSIG_PROC discussion¹. However, as PID namespaces
> already exist and appear to be a good fit for the most part,

Sure, if CLONE_NEWPID fits your needs you can use it,

> I think it
> makes sense to just add the missing pieces to PID namespaces instead of
> duplicating part of the PID namespace functionality.

Again, I am not arguing with your change.

PR_KILL_MY_DESCENDANTS_ON_EXIT can make sense just like PR_SET_CHILD_SUBREAPER
even if PID namespace functionality implies both. Simply because CLONE_NEWPID
is not necessarily the best tool, if nothing else you do not necessarily want
the pid isolation.

> Also, based on Eric's comment in that other discussion about
> no_new_privs not being allowed to increase the attack surface,
> PR_KILL_MY_DESCENDANTS_ON_EXIT might require CAP_SYS_ADMIN as well (due
> to setuid children).

No, no, the exiting parent should simply do group_send_sig_info(SIGKILL)
for every descendant and rely on check_kill_permission().

OK, lets forget it for now.

Oleg.
