From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 5/6] seccomp: add a way to pass FDs via a notification
 fd
Date: Thu, 27 Sep 2018 16:14:08 -0600
Message-ID: <20180927221408.GD15491@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-6-tycho@tycho.ws>
 <CAG48ez0JY=_fvgy+t92-08kBFgTAZ-3hgAp+OOAwmSd73MJ-QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0JY=_fvgy+t92-08kBFgTAZ-3hgAp+OOAwmSd73MJ-QA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 09:28:07PM +0200, Jann Horn wrote:
> On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > This patch adds a way to insert FDs into the tracee's process (also
> > close/overwrite fds for the tracee). This functionality is necessary to
> > mock things like socketpair() or dup2() or similar, but since it depends on
> > external (vfs) patches, I've left it as a separate patch as before so the
> > core functionality can still be merged while we argue about this. Except
> > this time it doesn't add any ugliness to the API :)
> [...]
> > +static long seccomp_notify_put_fd(struct seccomp_filter *filter,
> > +                                 unsigned long arg)
> > +{
> > +       struct seccomp_notif_put_fd req;
> > +       void __user *buf = (void __user *)arg;
> > +       struct seccomp_knotif *knotif = NULL;
> > +       long ret;
> > +
> > +       if (copy_from_user(&req, buf, sizeof(req)))
> > +               return -EFAULT;
> > +
> > +       if (req.fd < 0 && req.to_replace < 0)
> > +               return -EINVAL;
> > +
> > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = -ENOENT;
> > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > +               struct file *file = NULL;
> > +
> > +               if (knotif->id != req.id)
> > +                       continue;
> 
> Are you intentionally permitting non-SENT states here? It shouldn't
> make a big difference, but I think it'd be nice to at least block the
> use of notifications in SECCOMP_NOTIFY_REPLIED state.

Agreed, I'll block everything besides REPLIED.

Tycho
