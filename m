From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 5 Aug 2019 12:21:24 -0700
Message-ID: <20190805192122.laxcaz75k4vxdspn@ast-mbp>
References: <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 05, 2019 at 10:23:10AM -0700, Andy Lutomirski wrote:
> 
> I refreshed the branch again.  I had a giant hole in my previous idea
> that we could deprivilege program loading: some BPF functions need
> privilege.  Now I have a changelog comment to that effect and a patch
> that sketches out a way to addressing this.
> 
> I don't think I'm going to have time soon to actually get any of this
> stuff mergeable, and it would be fantastic if you or someone else who
> likes working of bpf were to take this code and run with it.  Feel
> free to add my Signed-off-by, and I'd be happy to help review.

Thanks a lot for working on patches and helping us with the design!

Can you resend the patches to the mailing list?
It's kinda hard to reply/review to patches that are somewhere in the web.
I'm still trying to understand the main idea.
If I'm reading things correctly:
patch 1 "add access permissions to bpf fds"
  just passes the flags ?
patch 2 "Don't require mknod() permission to pin an object" 
 makes sense in isolation.
patch 3 "Allow creating all program types without privilege"
  is not right.
patch 4 "Add a way to mark functions as requiring privilege"
 is an interesting idea, but I don't think it helps that much.

So the main thing we're trying to solve with augmented bpf syscall
and/or /dev/bpf is to be able to use root-only features of bpf when
trused process already dropped root permissions.
These features include bpf2bpf calls, bounded loops, special maps (like LPM), etc.

Attaching to a cgroup already has file based permission checks.
The user needs to open cgroup directory to attach.
acls on cgroup dir can already be used to prevent attaching to
certain parts of cgroup hierarchy.

It seems this discussion is centered around making /dev/bpf to
let unpriv (and not trusted) users (humans) to do bpf.
That's not quite the case.
It's a good use case, but not the one we're after at the moment.
In our enviroment bpftrace, bpftool, all bcc tools are pre-installed
and the users (humans) can simply 'sudo' to run them.
Adding suid bit to installed bpftool binary is doable, but there is no need.
'sudo' works just fine.
What we need is to drop privileges sooner in daemons like systemd.
Container management daemon runs in the nested containers.
These trusted daemons need to have access to full bpf, but they
don't want to be root all the time.
They cannot flip back and forth via seteuid to root every time they
need to do bpf.
Hence the idea is to have a file that this daemon can open,
then drop privileges and still keep doing bpf things because FD is held.
Outer container daemon can pass this /dev/bpf's FD to inner daemon, etc.
This /dev/bpf would be accessible to root only.
There is no desire to open it up to non-root.

It seems there is concern that /dev/bpf is unnecessary special.
How about we combine bpffs and /dev/bpf ideas?
Like we can have a special file name in bpffs.
The root would do 'touch /sys/fs/bpf/privileges' and it would behave
just like /dev/bpf, but now it can be in any bpffs directory and acls
to bpffs mount would work as-is.

CAP_BPF is also good idea. I think for the enviroment where untrusted
and unprivileged users want to run 'bpftrace' that would be perfect mechanism.
getcap /bin/bpftrace would have cap_bpf, cap_kprobe and whatever else.
Sort of like /bin/ping.
But I don't see how cap_bpf helps to solve our trusted root daemon problem.
imo open ("/sys/fs/bpf/privileges") and pass that FD into bpf syscall
is the only viable mechanism.

Note the verifier does very different amount of work for unpriv vs root.
It does speculative execution analysis, pointer leak checks for unpriv.
So we gotta pass special flag to the verifier to make it act like it's
loading a program for root.
