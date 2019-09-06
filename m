From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Fri, 06 Sep 2019 15:43:33 -0400
Message-ID: <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
References: <20190906152455.22757-1-mic@digikod.net>
         <20190906152455.22757-2-mic@digikod.net>
         <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
         <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
         <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
         <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Florian Weimer <fweimer@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe
List-Id: linux-api@vger.kernel.org

On Sat, 2019-09-07 at 03:13 +1000, Aleksa Sarai wrote:
> On 2019-09-06, Jeff Layton <jlayton@kernel.org> wrote:
> > On Fri, 2019-09-06 at 18:06 +0200, Mickaël Salaün wrote:
> > > On 06/09/2019 17:56, Florian Weimer wrote:
> > > > Let's assume I want to add support for this to the glibc dynamic loader,
> > > > while still being able to run on older kernels.
> > > > 
> > > > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > > > with EINVAL, try again without O_MAYEXEC?
> > > 
> > > The kernel ignore unknown open(2) flags, so yes, it is safe even for
> > > older kernel to use O_MAYEXEC.
> > > 
> > 
> > Well...maybe. What about existing programs that are sending down bogus
> > open flags? Once you turn this on, they may break...or provide a way to
> > circumvent the protections this gives.
> 
> It should be noted that this has been a valid concern for every new O_*
> flag introduced (and yet we still introduced new flags, despite the
> concern) -- though to be fair, O_TMPFILE actually does have a
> work-around with the O_DIRECTORY mask setup.
> 
> The openat2() set adds O_EMPTYPATH -- though in fairness it's also
> backwards compatible because empty path strings have always given ENOENT
> (or EINVAL?) while O_EMPTYPATH is a no-op non-empty strings.
> 
> > Maybe this should be a new flag that is only usable in the new openat2()
> > syscall that's still under discussion? That syscall will enforce that
> > all flags are recognized. You presumably wouldn't need the sysctl if you
> > went that route too.
> 
> I'm also interested in whether we could add an UPGRADE_NOEXEC flag to
> how->upgrade_mask for the openat2(2) patchset (I reserved a flag bit for
> it, since I'd heard about this work through the grape-vine).
> 

I rather like the idea of having openat2 fds be non-executable by
default, and having userland request it specifically via O_MAYEXEC (or
some similar openat2 flag) if it's needed. Then you could add an
UPGRADE_EXEC flag instead?

That seems like something reasonable to do with a brand new API, and
might be very helpful for preventing certain classes of attacks.

-- 
Jeff Layton <jlayton@kernel.org>
