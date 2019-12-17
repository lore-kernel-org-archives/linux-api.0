From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 0/4] Add pidfd getfd ioctl (Was Add ptrace get_fd
 request)
Date: Tue, 17 Dec 2019 04:02:29 +0100
Message-ID: <20191217030229.2lcfrdbcc6ynumht@wittgenstein>
References: <20191217005842.GA14379@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191217005842.GA14379@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 17, 2019 at 12:58:45AM +0000, Sargun Dhillon wrote:
> This patchset introduces a mechanism to capture file descriptors from other
> processes by pidfd and ioctl. Although this can be achieved using

I like the idea in general as it's quite useful in general. And also for
the seccomp notifier and probably for CRIU too.
A few things that crossed my mind.
A thing I'm worried about is that this will be a stepping stone for
people argue for an fd-replacement feature though I think that
fd-injection not replacement might be sufficient.

I wonder whether we need to worry about special file descriptors, i.e.
anything anon-inode based, or devpts devices but I guess those concerns
already apply to ptrace anyway.

One more thing, with GETFD it seems useful to me that later we can add
a new flag - like I suggested in the previous version - to the seccomp
notifier that would allow a caller to request that with each seccomp
message received via the notifier ioctl() from the kernel a pidfd is
sent along. This would make it quite elegant to get fds for the
supervised task.

Christian
