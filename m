From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Documentation patch for namespaced file capabilities
Date: Mon, 20 Nov 2017 10:03:39 -0600
Message-ID: <873759ueck.fsf@xmission.com>
References: <CAKgNAkiAeqbD=G6hnExh4cC84nA2mU6xdLzzS0F2x1wviEPgHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkiAeqbD=G6hnExh4cC84nA2mU6xdLzzS0F2x1wviEPgHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Michael Kerrisk's message of "Mon, 20 Nov 2017 10:36:11 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkp-JC7UmRfGjtg@public.gmane.org, xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, christian.brauner-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Serge,
>
> At the moment man-pages lacks documentation of the namespaced file
> capability feature that you added with commit
> 8db6c34f1dbc8e06aa016a9b829b06902c3e1340. Would you be able to send a
> patch describing the feature?
>
> Presumably, the patch would be for the capabilities(7) page (or
> perhaps for the user_namespaces(7) page, if that seems more
> appropriate), As well as documenting the semantics, it would be good
> to include an example or two of the notation that is used for the
> xattr names.
>
> Presumably also there will be some changes in userspace tools
> (setcap/getcap?). Do you know anything about what's happening there?


Just a quick summary.

- The capability name does not change.

- From inside a user namespace the capability works as for ``root'' as
  existing tools expect.  (AKA the capability is mapped into the current
  user namespace).

- From outside a user namespace the version of the capability is
  incremented, and a uid of the root user in a user namespace is added
  at the end in the new version of the capability.

So for the capabilities(7) manpage I would add to the File capablities
section:

Since Kernel v4.14 the kernel supports setting file capabilities inside
a user namespace.  In which case an additional uid is stored indicating
the root user of the user namespace the file capabilitity is active in.

When a file is executed and it has a file capability limited to a user
namespace, the kernel takes the uid from the capability and if that uid
matches the uid of the root user of the user namespace or the root user
of an ancestor namespace the capability is applied.  Otherwise the
capability is ignored.

Eric
