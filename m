From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for
 UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 11:24:24 -0500
Message-ID: <20191105162424.GH30717@redhat.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
 <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
 <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
 <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX=VmSjD6kLT6tuZQ4Efhc_13vZrw1mo4Z2iKqZTT-bzg@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Colascione <dancol@google.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:00:26AM -0800, Andy Lutomirski wrote:
> On Tue, Nov 5, 2019 at 7:55 AM Daniel Colascione <dancol@google.com> wrot=
e:
> >
> > On Tue, Nov 5, 2019 at 7:29 AM Mike Rapoport <rppt@linux.ibm.com> wrote=
:
> > >
> > > Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
> > > descriptor table from the read() implementation of uffd, which may ha=
ve
> > > security implications for unprivileged use of the userfaultfd.
> > >
> > > Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that h=
ave
> > > CAP_SYS_PTRACE.
> >
> > Thanks. But shouldn't we be doing the capability check at
> > userfaultfd(2) time (when we do the other permission checks), not
> > later, in the API ioctl?
>=20
> The ioctl seems reasonable to me.  In particular, if there is anyone
> who creates a userfaultfd as root and then drop permissions, a later
> ioctl could unexpectedly enable FORK.
>=20
> This assumes that the code in question is only reachable through
> ioctl() and not write().

write isn't implemented. Until UFFDIO_API runs, all other implemented
syscalls are disabled (i.e. all other ioctls, poll and read). You can
quickly verify all the 3 blocks by searching for UFFD_STATE_WAIT_API,

UFFDIO_API is the place where the handshake with userland
happens. userland asks for certain features and the kernel
implementation of userlands answers yes or no.

Normally we would only ever return -EINVAL on a request of a feature
that isn't available in the running kernel (equivalent to -ENOSYS if
the syscall is entirely missing on an even older kernel), -EPERM is
more informative as it tells userland the feature is actually in the
kernel just it requires more permissions.

We could have returned -EINVAL too, but it wouldn't have made a
difference to non-privileged CRIU and we're not aware of other users
that could benefit from -EINVAL instead of -EPERM. This the relevant
CRIU userland:

        if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
                pr_perror("Failed to get uffd API");
                goto err;
=09}

Unfortunately this is an ABI break, preferred than the clean removal
of the feature, because it's at least not going to break CRIU
deployments running with the PTRACE privilege. The clean removal while
non-ABI breaking, would have prevented all CRIU users to keep running
after a kernel upgrade.

The long term plan is to introduce UFFD_FEATURE_EVENT_FORK2 feature
flag that uses the ioctl to receive the child uffd, it'll consume more
CPU, but it wouldn't require the PTRACE privilege anymore.

Overall any suid or SCM_RIGHTS fd-receiving app, that isn't checking
the retval of open/socket or whatever fd "installing" syscall, is non
robust and is prone to break over time as more people edit the code or
as any library call internally change behavior, so if there's any
practical issue caused by this, it should be fixed in userland
too for higher robustness.

If you stick your userland to std::fs and std::net robustness against
issues like this is enforced by the language.

Thanks,
Andrea
