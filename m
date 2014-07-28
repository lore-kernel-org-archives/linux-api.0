From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Mon, 28 Jul 2014 14:18:04 -0700
Message-ID: <87vbqhp4hf.fsf@x220.int.ebiederm.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<1406296033-32693-12-git-send-email-drysdale@google.com>
	<CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
	<CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
	<CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Jul 2014 10:18:05 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> [cc: Eric Biederman]
>

> Can we do one better and add a flag to prevent any non-self pid
> lookups?  This might actually be easy on top of the pid namespace work
> (e.g. we could change the way that find_task_by_vpid works).
>
> It's far from just being signals.  There's access_process_vm, ptrace,
> all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
> is ridiculous), and probably some others that I've forgotten about or
> never noticed in the first place.

So here is the practical question.

Are these processes that only can send signals to their thread group
allowed to call fork()?


If fork is allowed and all pid lookups are restricted to their own
thread group that wait, waitpid, and all of the rest of the wait family
will never return the pids of their children, and zombies will
accumulate.  Aka the semantics are fundamentally broken.

If fork is not allowed pid namespaces already solve this problem.

Eric
