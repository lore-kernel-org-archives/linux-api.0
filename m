From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 13:18:53 -0400
Message-ID: <CAEXW_YRXDeJSJaSZBaCk=o+4Dhbq-WWzG=6OW4hDx5ynu7fgwg@mail.gmail.com>
References: <20190326155513.26964-1-christian@brauner.io> <20190326155513.26964-3-christian@brauner.io>
 <20190326170601.GA101741@google.com> <20190326170827.p2wlwsscf5u6f3i7@brauner.io>
 <20190326171525.GA116974@google.com> <20190326171702.smehtebw4e656ehl@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326171702.smehtebw4e656ehl@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Glexiner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 1:17 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Tue, Mar 26, 2019 at 01:15:25PM -0400, Joel Fernandes wrote:
> > On Tue, Mar 26, 2019 at 06:08:28PM +0100, Christian Brauner wrote:
> > [snip]
> > > >
> > > > > +
> > > > > +               if (!result)
> > > > > +                       result = -ENOENT;
> > > > > +
> > > > > +               put_pid(struct_pid);
> > > >
> > > > so on error you would put_pid twice which seems odd..  I would suggest, don't
> > > > release the pid ref from within pidfd_create_fd, release the ref from the
> > > > caller. Speaking of which, I added to my list to convert the pid->count to
> > > > refcount_t at some point :)
> > >
> > > as i said, pidfd_create_fd takes its own reference
> >
> > Oh. That was easy to miss. Fair enough. I take that comment back.
> >
> > Please also reply to the other comments I posted, thanks. Generally on LKML,
> > I have seen there is an expectation to reply to all reviewer's review
> > comments even if you agree with them. This helps keep the review going
> > smoothly. Just my 2 cents.
>
> I tend to do it in multiple mails depending on whether or not I need to
> think about a comment or not.

Ok, that's also fine with me. thanks,

 - Joel
