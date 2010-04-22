From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Thu, 22 Apr 2010 09:36:09 -0500
Message-ID: <20100422143609.GA3269@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
 <20100421133917.GB16326@us.ibm.com>
 <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
 <20100421150900.GB31880@us.ibm.com>
 <m11ve81usw.fsf@fess.ebiederm.org>
 <w2wf73f7ab81004212157o371c5738o10c8b6ff807ba36a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <w2wf73f7ab81004212157o371c5738o10c8b6ff807ba36a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Moffett <kyle-hoO6YkzgTuCM0SS3m2neIg@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ashwin Ganti <ashwin.ganti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, rsc-kPPrOchjzlEAvxtiuMwx3w@public.gmane.org, ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jt.beard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, oleg-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Kyle Moffett (kyle-hoO6YkzgTuCM0SS3m2neIg@public.gmane.org):
> On Wed, Apr 21, 2010 at 15:15, Eric W. Biederman <ebiederm@xmission.c=
om> wrote:
> > "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> writes:
> >
> >> Ignoring namespaces for a moment, I guess we could do something li=
ke
> >>
> >> struct credentials_pass {
> >> =A0 =A0 =A0 pid_t global_pid;
> >> =A0 =A0 =A0 unsigned long unique_id;
> >> =A0 =A0 =A0 uid_t new_uid;
> >> =A0 =A0 =A0 gid_t new_gid;
> >> =A0 =A0 =A0 int num_aux_gids;
> >> =A0 =A0 =A0 gid_t aux_gids[];
> >> }
> >
> > This looks surprising like what I am doing in passing uids and pids
> > through unix domain sockets.
> >
> > So if this looks like a direction we want to go it shouldn't be too
> > difficult.
>=20
> Hmm... for an alternative idea:
>=20
> We have this nice "kernel keyring" infrastructure that lets us stuff
> arbitrary things into "keys" and grant/revoke them between processes.
> What if we created a relatively generic way for processes to package
> up privileges (of whatever form) into a "key" that could be granted t=
o
> another process (via UNIX-domain socket)?  Then the other process
> would use a setuid()-ish syscall which would instead apply a specific
> key as your credentials, possibly including the audit context and/or
> namespaces it came from.
>=20
> By using the keyring system, such tokens could be kept around across
> multiple processes easily (as opposed to FDs), in the same style as a
> "sudo" ticket file, for example (even with an expiration time).
>=20
> Types of credentials you could pass around:
>   * Capabilities
>   * Filesystem UID/GID in a particular UID namespace (for FS operatio=
ns)
>   * Process UID/GID in a particular UID namespace (for kill(), etc)
>   * Audit contexts
>   * SELinux/etc security labels
>=20
> All of the above could be optionally limited to effectively require a
> bprm-secure-style exec() with specific args.  So for example, instead
> of making "/usr/sbin/passwd" a setuid program, you could make it be a=
n
> unprivileged helper.  It would connect to a privileged daemon and ask
> for a password-change cookie for that particular user.  The daemon
> would create what is essentially a "delayed exec" key which grants a
> specific UID and capabilities when that process performs an execkey()=
=2E

Hi Kyle,

it's a neat idea in terms of flexibility - but in this case the
flexibility really scares me :)

In particular I don't like the ability to keep these tokens around
for later use, and your example of passing around capabilities is
something we've specifically rejected in the past.

That doesn't mean that it wouldn't be a good idea to take your
general approach, use it very inflexibly, and then slowly, as we
gain experience, add flexibility.

I think we are best off starting with two options:

	1. pass audit credentials only
	2. pass full credentials

credentials meaning uid/gid, though - and let capabilities be
sorted out by the setuid rules.

> So as an example, you could rewrite "sudo" as a partially-privileged
> daemon and an unprivileged helper.  The unpriv helper would send
> across a request (optionally including the command and environment)
> which would be checked by the daemon.  It would then issue a key to
> allow the unpriv helper to perform a limited exec.
>=20
> Another option would be to rewrite network login programs (eg OpenSSH=
)
> to use this for privilege separation.  The listening process would ge=
t
> a non-expiring key to allow it to exec a partially-privileged
> password-checking program.  If the password-checking program likes th=
e
> password it generates a single-use key to pass back to the forked
> network process that allows it to exec a program as that user.

Note that the last two examples are possible with with the simple
p9auth driver, and are really their motivation.  In fact, we only
need a single privileged back-end (factotum) server to server a bunch
of unprivileged front-end servers.

So over the next few days I will incorporate a bunch of the feedback
on the p9auth driver itself, turn it into a filesystem, and resend
it.  That's not to say that I don't like the other suggestions - I
want to pursue those as well and we can see where we end up and which
approach we prefer.  For a first step I look forward to Eric pushing
the patches to do uid and pid translation for unix sock credentials.

thanks,
-serge
