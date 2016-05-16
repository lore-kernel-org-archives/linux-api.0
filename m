From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] simplified security.nscapability xattr
Date: Mon, 16 May 2016 16:15:23 -0500
Message-ID: <20160516211523.GA5282@mail.hallyn.com>
References: <CAGXu5jKFNQs8oxq+yD6_Q8HcNyf+GouSHFzkxT9u9BkK=ZLQ7Q@mail.gmail.com>
 <20160426222627.GA19307@mail.hallyn.com>
 <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
 <20160502035452.GA31837@mail.hallyn.com>
 <87h9egp2oq.fsf@x220.int.ebiederm.org>
 <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
 <20160503051921.GA31551@mail.hallyn.com>
 <87bn4nhejj.fsf@x220.int.ebiederm.org>
 <20160507231012.GA11076@pc.thejh.net>
 <20160511210221.GA24015@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160511210221.GA24015-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Serge E. Hallyn (serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org):
...
> There's a problem though.  The above suffices to prevent an unprivileged user
> in a user_ns from unsharing a user_ns to write a file capability and exploit
> that capability in the ns where he is unprivileged.  With one exception, which
> is the case where the unprivileged user is mapped to the same kuid which
> created the namespace.  So if uid 1000 on the host creates a namespace
> where uid 1000 maps to 1000 in the namespace, then 1000 in the namespace
> can create a new user_ns, write the xattr, and exploit it from the
> parent namespace.  This is not an uncommon case.  I'm not sure what to do about
> it.

Ok I think I've convinced myself that requiring a kuid 0 in the container
and storing that in the security.nscapability is best solution.  The DAC
objection is imo not really valid - we don't have to give uid 0 in the
container any special privilege, we just require that the ns have a uid 0
mapping.  I have not been able to think of any other reliable way to verify
that the writer of the capability is authorized to grant privilege to the
file when executed by current.

I'm going to proceed with another POC based on the following design:

1. no new syscalls at the moment.  You can choose to set/query
security.nscapability, but can also just set security.capability from
a user_ns and have the kernel transparently set a security.nscapability
entry for you.

2. For now just a single security.nscapability entry, but in a format
that turning it into an array will be a trivial change

3. When running file foo which has a security.nscapability for kuid 100000,
then any namespace where kuid 100000 is root - or which has an ancestor ns where
that is the case - will run the file with the listed capabilities.

4. When doing getxattr of security.capability from a user_ns, if there is a
security.capability entry, that will be returned;  else if there is a valid
security.nscapability for your ns, that will be returned.

5. when doing a setxattr of security.capability from a user_ns, if there is
a security.nscapability entry, you get EBUSY;  else a security.nscapability 
with your root kuid will be written provided that (a) you are privileged
over your namespace, (b) you are privileged over your root uid, (c) the
file owner maps into your namespace.

6. when doing a getxattr of security.nscapability, the entry will be shown
with kuid mapped into your namespace or -1 if the uid does not map into
your ns.

7. when doing a setxattr of security.nscapability, if an entry exists, you
get -EBUSY;  if you are not privileged over your ns, your root uid, and
the file owner, then you get -EPERM;  the xattr includes a uid field, which
must be either 0 or a value valid in your ns.  The value will be converted
to a kuid and stored on disk.  (Seth, I'm not sure offhand how that should
mesh with your patches, we can talk about it after I send the next patch,
which I'm quite certain will handle it wrongly)

8. If a security.capability exists, it will override any security.nscapability
at execve() (so, inverse of my previous two patches).

-serge
