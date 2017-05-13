From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v4 resend 2/2] kcmp: Add KCMP_EPOLL_TFD mode to compare
 epoll target files
Date: Sat, 13 May 2017 10:15:10 +0300
Message-ID: <20170513071510.GF1881@uranus.lan>
References: <20170424154423.511592110@gmail.com>
 <CAG48ez33xco_cHeaHYg2TOCquosbrAStnHikBDZ89No6c7E0Kg@mail.gmail.com>
 <20170512225340.GD1881@uranus.lan>
 <20170513014508.GA21900@outlook.office365.com>
 <20170513065514.GE1881@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170513065514.GE1881-ZmlpmtaulQd+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, May 13, 2017 at 09:55:14AM +0300, Cyrill Gorcunov wrote:
> On Fri, May 12, 2017 at 06:45:09PM -0700, Andrei Vagin wrote:
> > On Sat, May 13, 2017 at 01:53:40AM +0300, Cyrill Gorcunov wrote:
> > > On Sat, May 13, 2017 at 12:41:30AM +0200, Jann Horn wrote:
> > > > [resending as plaintext]
> > > > 
> > > > I realize that the existing kcmp code has the same issue, but:
> > > > 
> > > > Why are you not taking a reference to filp or filp_tgt? This can end up
> > > > performing a comparison between a pointer to a freed struct file and a
> > > > pointer to a struct file that was allocated afterwards, right? So it can
> > > > return a false "is equal" result when the two files aren't actually the same
> > > > if one of the target tasks is running? This looks like it unnecessarily
> > > > exposes information about whether an allocation reuses the memory of
> > > > a previously freed allocation.
> > > 
> > > It work with unlocked data on purpose for speed sake. Moreover even
> > > if we grap a reference it is valid _only_ during comparision operation,
> > > next we drop ref and it can be easily freed by os. Thus it's up to
> > > a caller to keep references to files/task and other resources used.
> > 
> > Looks like we can take rcu_read_lock() to guarantee that these objects
> > will not be freed, and rcu_read_lock() should not affect perfomance too much.
> 
> Rather they should be get_file_rcu/fput. Still I'm not convinced we need it,
> but fine will update both: plain KCMP_FILE and KCMP_EPOLL_TFD since it won't
> hurt performance.

>From manpage we wrote:

       Note the kcmp() is not protected against false positives which may occur
       if tasks are running.  One should stop tasks by sending SIGSTOP (see  sig‐
       nal(7)) prior to inspection with this system call to obtain meaningful results.

So no, not going to uglify source code and add get/put files there.

	Cyrill
