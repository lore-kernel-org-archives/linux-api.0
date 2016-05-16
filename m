From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Mon, 16 May 2016 16:48:04 -0500
Message-ID: <20160516214804.GA5926@mail.hallyn.com>
References: <20160426222627.GA19307@mail.hallyn.com>
	<CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
	<20160502035452.GA31837@mail.hallyn.com>
	<87h9egp2oq.fsf@x220.int.ebiederm.org>
	<CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	<20160503051921.GA31551@mail.hallyn.com>
	<87bn4nhejj.fsf@x220.int.ebiederm.org>
	<20160507231012.GA11076@pc.thejh.net>
	<20160511210221.GA24015@mail.hallyn.com>
	<20160516211523.GA5282@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160516211523.GA5282-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 16, 2016 at 04:15:23PM -0500, Serge E. Hallyn wrote:
> Quoting Serge E. Hallyn (serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org):
> ...
> > There's a problem though.  The above suffices to prevent an unprivilege=
d user
> > in a user_ns from unsharing a user_ns to write a file capability and ex=
ploit
> > that capability in the ns where he is unprivileged.  With one exception=
, which
> > is the case where the unprivileged user is mapped to the same kuid which
> > created the namespace.  So if uid 1000 on the host creates a namespace
> > where uid 1000 maps to 1000 in the namespace, then 1000 in the namespace
> > can create a new user_ns, write the xattr, and exploit it from the
> > parent namespace.  This is not an uncommon case.  I'm not sure what to =
do about
> > it.
> =

> Ok I think I've convinced myself that requiring a kuid 0 in the container
> and storing that in the security.nscapability is best solution.  The DAC
> objection is imo not really valid - we don't have to give uid 0 in the
> container any special privilege, we just require that the ns have a uid 0
> mapping.  I have not been able to think of any other reliable way to veri=
fy
> that the writer of the capability is authorized to grant privilege to the
> file when executed by current.
> =

> I'm going to proceed with another POC based on the following design:
> =

> 1. no new syscalls at the moment.  You can choose to set/query
> security.nscapability, but can also just set security.capability from
> a user_ns and have the kernel transparently set a security.nscapability
> entry for you.
> =

> 2. For now just a single security.nscapability entry, but in a format
> that turning it into an array will be a trivial change
> =

> 3. When running file foo which has a security.nscapability for kuid 10000=
0,
> then any namespace where kuid 100000 is root - or which has an ancestor n=
s where
> that is the case - will run the file with the listed capabilities.
> =

> 4. When doing getxattr of security.capability from a user_ns, if there is=
 a
> security.capability entry, that will be returned;  else if there is a val=
id
> security.nscapability for your ns, that will be returned.
> =

> 5. when doing a setxattr of security.capability from a user_ns, if there =
is
> a security.nscapability entry, you get EBUSY;  else a security.nscapabili=
ty =

> with your root kuid will be written provided that (a) you are privileged
> over your namespace, (b) you are privileged over your root uid, (c) the
> file owner maps into your namespace.

St=E9phane pointed out this isn't quite right.  The EBUSY will happen if
a security.nscapability is defined with a kuid over which the writer is
not privileged - else it will overwrite.  It will also happen if
security.capbility is set.

> 6. when doing a getxattr of security.nscapability, the entry will be shown
> with kuid mapped into your namespace or -1 if the uid does not map into
> your ns.
> =

> 7. when doing a setxattr of security.nscapability, if an entry exists, you
> get -EBUSY;  if you are not privileged over your ns, your root uid, and
> the file owner, then you get -EPERM;  the xattr includes a uid field, whi=
ch
> must be either 0 or a value valid in your ns.  The value will be converted
> to a kuid and stored on disk.  (Seth, I'm not sure offhand how that should
> mesh with your patches, we can talk about it after I send the next patch,
> which I'm quite certain will handle it wrongly)
> =

> 8. If a security.capability exists, it will override any security.nscapab=
ility
> at execve() (so, inverse of my previous two patches).
> =

> -serge
