From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 4/4] samples: Add example of using PTRACE_GETFD in
 conjunction with user trap
Date: Tue, 10 Dec 2019 08:35:55 -0700
Message-ID: <20191210153555.GD22803@cisco>
References: <20191209070646.GA32477@ircssh-2.c.rugged-nimbus-611.internal>
 <20191209192959.GB10721@redhat.com>
 <BE3E056F-0147-4A00-8FF7-6CC9DE02A30C@ubuntu.com>
 <20191209204635.GC10721@redhat.com>
 <20191210111051.j5opodgjalqigx6q@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191210111051.j5opodgjalqigx6q@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, jannh@google.com, cyphar@cyphar.com, luto@amacapital.net, viro@zeniv.linux.org.uk, Jed Davis <jld@mozilla.com>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, Emilio Cobos =?iso-8859-1?Q?=C1lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 10, 2019 at 12:10:52PM +0100, Christian Brauner wrote:
>
> #define SECCOMP_IOCTL_NOTIF_SET_FD	SECCOMP_IOWR(4, <sensible struct>)

There's even some code already for this one:
https://lore.kernel.org/linux-fsdevel/20180927151119.9989-6-tycho@tycho.ws/

Tycho
