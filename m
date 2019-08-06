From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 5 Aug 2019 18:11:36 -0700
Message-ID: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 05, 2019 at 02:25:35PM -0700, Andy Lutomirski wrote:
> It tries to make the kernel respect the access modes for fds.  Without
> this patch, there seem to be some holes: nothing looked at program fds
> and, unless I missed something, you could take a readonly fd for a
> program, pin the program, and reopen it RW.

I think it's by design. iirc Daniel had a use case for something like this.

The key to understand is that bpf is not about security. It's about safety.
All features are geared to safety.
The users are trusted most of the time.
The number of unprivileged bpf use cases is tiny compared to trusted.
Hence unprivileged bpf is actually something that can be deprecated.

> Other than the issue that this patch partially fixes, can you see any
> reason that loading a program should require privilege?  Obviously the
> verifier is weakened a bit when called by privileged users, but a lot
> of that is about excessive resource usage and various less-well-tested
> features.  It seems to me that most of the value of bpf() should be
> available to programs that should not need privilege to load.  Are
> there things I'm missing?

see below.

> LPM: I don't see why this requires privilege at all.  It indeed checks
> capable(CAP_SYS_ADMIN), but I don't see why.

see below.

> 
> >
> > Attaching to a cgroup already has file based permission checks.
> > The user needs to open cgroup directory to attach.
> > acls on cgroup dir can already be used to prevent attaching to
> > certain parts of cgroup hierarchy.
> 
> The current checks seem inadequate.
> 
> $ echo 'yay' </sys/fs/cgroup/systemd/system.slice/
> 
> The ability to obtain an fd to a cgroup does *not* imply any right to
> modify that cgroup.  The ability to write to a cgroup directory
> already means something else -- it's the ability to create cgroups
> under the group in question.  I'm suggesting that a new API be added
> that allows attaching a bpf program to a cgroup without capabilities
> and that instead requires write access to a new file in the cgroup
> directory.  (It could be a single file for all bpf types or one file
> per type.  I prefer the latter -- it gives the admin finer-grained
> control.)

This is something to discuss. I don't mind something like this,
but in general bpf is not for untrusted users.
Hence I don't want to overdesign.

> 
> > What we need is to drop privileges sooner in daemons like systemd.
> 
> This is doable right now: systemd could fork off a subprocess and
> delegate its cgroup operations to it.  It would be maybe a couple
> hundred lines of code.  As an added benefit, that subprocess could
> verify that the bpf operations in question are reasonable.
> Alternatively, if there was a CAP_BPF_ADMIN, systemd could retain that
> capability and flip it on and off as needed.

See https://github.com/systemd/systemd/blob/01234e1fe777602265ffd25ab6e73823c62b0efe/src/core/bpf-firewall.c#L671-L674
bpf based IP sandboxing doesn't work in 'systemd --user'.
That is just one of the problems that people complained about.

Note that systemd bpf usage is basic. There is ongoing work to
adopt libbpf in systemd, so more features and more use cases will open up.

Inside containers and inside nested containers we need to start processes
that will use bpf. All of the processes are trusted.
We need to drop root not to be secure, but to be safe.
Consider a bug in a code that accidently did sys_kill(-1).
Dropping root is a mitigation for bugs like this.

> 
> > Container management daemon runs in the nested containers.
> > These trusted daemons need to have access to full bpf, but they
> > don't want to be root all the time.
> > They cannot flip back and forth via seteuid to root every time they
> > need to do bpf.
> > Hence the idea is to have a file that this daemon can open,
> > then drop privileges and still keep doing bpf things because FD is held.
> > Outer container daemon can pass this /dev/bpf's FD to inner daemon, etc.
> > This /dev/bpf would be accessible to root only.
> > There is no desire to open it up to non-root.
> 
> This seems extremely dangerous right now.  A program that can bypass
> *all* of the capable() checks in bpf() can do a whole lot.  Among
> other things, it can read all of kernel memory. 

It's 'dangerous' only if you think about it from security point of view.
The tracing (and sometimes networking) bpf progs need to read all of kernel
memory without being root.
That is the whole point of the /dev/bpf.

> This seems to have most of the same problems.  My main point is that
> it conflates a whole lot of different permissions, and I really don't
> think it's that much work to mostly disentangle the permissions in
> question.  My little series (if completed) plus a patch to allow
> unprivileged cgroup attach operations if you have an FMODE_WRITE fd to
> an appropriate file should get most of the way there.

I think I understand your concern. One /dev/bpf magic to by-pass
all of capable() checks in bpf doesn't look nice indeed.

Now to answer your question about capable(sys_admin) in the verifier.

See this bugfix:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=7c2e988f400e83501e0a3568250780609b7c8263

It's a bug in the JIT that was there pretty much forever,
but it got exposed due to two new bpf features.
Initially syzbot complained that bounded loops allow jmp to 1st insn.
syzbot reproducer contained 'never taken' branch, so buggy JIT
wouldn't have caused a kernel panic for this reproducer though
JITed x86 code is broken.
It took me few days to realize that with bpf2bpf calls _and_
bounded loops I can craft a test that will expose this JIT bug
and will crash the kernel.
So a combination of two recent verifier features exposed old JIT bug
that would have been a security issue if we didn't gate these verifier
features for root only.
Now it's simply a kernel bugfix.

Such subtle bugs happen all the time when new verifier features are
introduced. Hence we always start them with root only.
bpf2bpf calls, bounded loops, precision tracking, dead code elimination,
LPM maps, many programs type are root only.
We don't want cve-s to be filed for every bug like this.

Even if we start relaxing features (like dropping root from LPM map)
at any given time there will be a lot of useful verifier features,
maps and program types that are root only.
For root == for trusted users only.
Unfortunately this approach creates adoption problem.
The trusted users don't want to be root to use bpf.
Hence this /dev/bpf.

To solve your concern of bypassing all capable checks...
How about we do /dev/bpf/full_verifier first?
It will replace capable() checks in the verifier only.

How to delegate cgroup attach permission is a follow up discussion.
Could be special files in cgroup dir as you proposed or something else.
Let's table that and focus on the verifier first.
