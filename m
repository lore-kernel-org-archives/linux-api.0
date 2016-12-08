From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even more magic
Date: Thu, 08 Dec 2016 17:43:09 +1300
Message-ID: <87inqvav4y.fsf@xmission.com>
References: <20161119151739.GA16398@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161119151739.GA16398-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
        message of "Sat, 19 Nov 2016 09:17:39 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Root in a user ns cannot be trusted to write a traditional
> security.capability xattr.  If it were allowed to do so, then any
> unprivileged user on the host could map his own uid to root in a
> namespace, write the xattr, and execute the file with privilege on the
> host.
>
> This patch introduces v3 of the security.capability xattr.  It builds a
> vfs_ns_cap_data struct by appending a uid_t rootid to struct
> vfs_cap_data.  This is the absolute uid_t (i.e. the uid_t in
> init_user_ns) of the root id (uid 0 in a namespace) in whose namespaces
> the file capabilities may take effect.
>
> When a task in a user ns (which is privileged with CAP_SETFCAP toward
> that user_ns) asks to write v2 security.capability, the kernel will
> transparently rewrite the xattr as a v3 with the appropriate rootid.
> Subsequently, any task executing the file which has the noted kuid as
> its root uid, or which is in a descendent user_ns of such a user_ns,
> will run the file with capabilities.
>
> If a task writes a v3 security.capability, then it can provide a
> uid (valid within its own user namespace, over which it has CAP_SETFCAP)
> for the xattr.  The kernel will translate that to the absolute uid, and
> write that to disk.  After this, a task in the writer's namespace will
> not be able to use those capabilities, but a task in a namespace where
> the given uid is root will.
>
> Only a single security.capability xattr may be written.  A task may
> overwrite the existing one so long as it was written by a user mapped
> into his own user_ns over which he has CAP_SETFCAP.
>
> This allows a simple setxattr to work, allows tar/untar to work, and
> allows us to tar in one namespace and untar in another while preserving
> the capability, without risking leaking privilege into a parent
> namespace.

Any chance of a singed-off-by?

Eric
