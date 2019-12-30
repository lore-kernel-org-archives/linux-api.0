From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 1/2] samples, selftests/seccomp: Zero out seccomp_notif
Date: Mon, 30 Dec 2019 11:33:31 -0800
Message-ID: <201912301132.5C97DD231B@keescook>
References: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
 <20191228181825.GB6746@cisco>
 <CAMp4zn91GoB=1eTbc_ux4eNs2-QFm+JocodgFQYUiiXL7H4m9w@mail.gmail.com>
 <20191229001818.GC6746@cisco>
 <CAMp4zn9s1wJyb9xHj4xYL5HTtM=gA07ZfBGTSW5j4ayUzaoZNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn9s1wJyb9xHj4xYL5HTtM=gA07ZfBGTSW5j4ayUzaoZNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>, Aleksa Sarai <cyphar@cyphar.com>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 30, 2019 at 11:14:44AM -0800, Sargun Dhillon wrote:
> On Sat, Dec 28, 2019 at 4:18 PM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Sat, Dec 28, 2019 at 07:10:29PM -0500, Sargun Dhillon wrote:
> > > On Sat, Dec 28, 2019 at 1:18 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > >
> > > >
> > > > I know it's unrelated, but it's probably worth sending a patch to fix
> > > > this to be sizes.seccomp_notif_resp instead of sizeof(*resp), since if
> > > > the kernel is older this will over-zero things. I can do that, or you
> > > > can add the patch to this series, just let me know which.
> > >
> > > I was thinking about this, and initially, I chose to make the smaller
> > > change. I think it might make more sense to combine the patch,
> > > given that the memset behaviour is "incorrect" if we do it based on
> > > sizeof(*req), or sizeof(*resp).
> > >
> > > I'll go ahead and respin this patch with the change to call memset
> > > based on sizes.
> >
> > I think it would be good to keep it as a separate patch, since it's an
> > unrelated bug fix. That way if we have to revert these because of some
> > breakage, we won't lose the fix.
> >
> > Cheers,
> >
> > Tycho
> 
> As I was doing this, I noticed that the self-tests all use hard-coded struct
> sizes. When I was playing with extending the API, all of a sudden all the
> self-tests started failing (until I recompiled them against newer headers).
> 
> Should we also change the self-tests to operate against the seccomp
> sizes API, or was it intentional for the self-tests hard-coded the struct
> definitions, and locked to the kernel version?

I intend the seccomp selftests to be kernel-version tied, but I'd like
them to fail as gracefully as possible on mismatched kernel versions...

-- 
Kees Cook
