From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Mon, 25 Jun 2018 19:32:04 -0600
Message-ID: <20180626013204.GA7261@cisco.cisco.com>
References: <20180621220416.5412-1-tycho@tycho.ws>
 <20180621220416.5412-2-tycho@tycho.ws>
 <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com>
 <20180622151514.GM3992@cisco>
 <E8029AD7-7009-4CBF-911E-186328237176@amacapital.net>
 <CAGXu5jKWQCDzXPdTz=+bxT9+4enaBvgYfMseUiGti+t1KwZT8g@mail.gmail.com>
 <CAG48ez3gobTL5mUnZKjhLedotZx49nGrxYKKud5_7+512PaOFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3gobTL5mUnZKjhLedotZx49nGrxYKKud5_7+512PaOFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 23, 2018 at 12:27:43AM +0200, Jann Horn wrote:
> On Fri, Jun 22, 2018 at 11:51 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Jun 22, 2018 at 11:09 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > > One possible extra issue: IIRC /proc/.../mem uses FOLL_FORCE, which is not what we want here.
> 
> Uuugh, I forgot about that.
> 
> > > How about just adding an explicit “read/write the seccomp-trapped task’s memory” primitive?  That should be easier than a “open mem fd” primitive.
> >
> > Uuugh. Can we avoid adding another "read/write remote process memory"
> > interface? The point of this series was to provide a lightweight
> > approach to what should normally be possible via the existing
> > seccomp+ptrace interface. I do like Jann's context idea, but I agree
> > with Andy: it can't be a handle to /proc/$pid/mem, since it's
> > FOLL_FORCE. Is there any other kind of process context id we can use
> > for this instead of pid? There was once an idea of pid-fd but it never
> > landed... This would let us get rid of the "id" in the structure too.
> > And if that existed, we could make process_vm_*v() safer too (taking a
> > pid-fd instead of a pid).
> 
> Or make a duplicate of /proc/$pid/mem that only differs in whether it
> sets FOLL_FORCE? The code is basically already there... something like
> this:

But we want more than just memory access, I think. rootfs access, ns
fds, etc. all seem like they might be useful, and racy to open.

I guess I see two options: use the existing id and add something to
seccomp() to ask if it's still valid or independent of this patchset
add some kind of pid id :\

Tycho
