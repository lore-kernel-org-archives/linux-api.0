From: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
 bind mounts (take 2)
Date: Thu, 28 May 2015 13:12:04 -0700
Message-ID: <CAOP=4wieEaR_wESNyba7EKPAhi6kf+ujxhoMAFKVRozqWtXHvQ@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail> <87lhg8pwvz.fsf@x220.int.ebiederm.org>
 <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
 <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com> <87fv6gikfn.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87fv6gikfn.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 28, 2015 at 12:14 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> But please someone test sandstorm with this patchset and tell me if it
> bites you.  The impetus to find a way to avoid breaking slightly buggy
> userspace is higher if it is more than unprivileged lxc that is broken.

One of these days I'm going to learn how to compile and test kernels
again (last time I did it was 1999). Unfortunately I don't think I
have time at the moment, but hopefully Andy can do it.

I note, though, that we only have two mount() calls in the sandstorm
codebase that seem like they could be affected:

run-bundle.c++:1264: KJ_SYSCALL(mount("proc", "proc", "proc",
MS_NOSUID | MS_NODEV | MS_NOEXEC, ""));
minibox.c++:251: KJ_SYSCALL(mount("proc", vpath.cStr(), "proc",
MS_NOSUID | MS_NODEV | MS_NOEXEC, ""),
supervisor.c++:921: KJ_SYSCALL(mount("/proc", "proc", nullptr, MS_BIND
| MS_REC, nullptr));

The first two seem like they should be fine since they set all the
flags (except readonly, which would be inappropriate for proc). I
guess my habit of setting every security flag I see came in handy. The
third case looks like it will be broken, BUT this line is in a
debug-only code path, so I don't care. Also we have the ability to
push any needed update within 24 hours, so we're generally in good
shape.

We never mount sysfs in Sandstorm.

> If I mount proc read-write I likely want to be able to write to proc
> files, and I will be much happier if the mount fails than if a bazillion
> syscalls later something else fails when it tries to write to proc.

I'm not sure that's true. Consider the broader context:
1) Your system's /proc is mounted read-only.
2) Now you're trying to mount a new proc in a new pid namespace, and
you do *not* specify MS_READONLY.

What should we expect here? Let's back off a bit and state user intent:
1) The system administrator has set a system-wide policy that /proc
may only be read, not written.
2) You made a PID namespace and it needed its own proc.

It seems intuitive here that the administrator's policy should apply
in the namespace. Certainly everyone using the system and/or all
software on the system already needs to be aware of this policy, since
it's unusual and will break things. Running software on this system
outside of any container already has the problem that syscalls
randomly break, so why should it be surprising when this happens
inside the container as well? Why do we need to go out of our way to
break at mount() time?

-Kenton
