From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Tue, 4 Nov 2014 08:46:33 -0500
Message-ID: <20141104134633.GA14014@htj.dyndns.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com>
 <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Aditya.

On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
> I agree that this is effectively bind-mounting, but doing this in kernel
> makes it really convenient for the userspace. The process that sets up the
> container doesn't need to care whether it should bind-mount cgroupfs inside
> the container or not. The tasks inside the container can mount cgroupfs on
> as-needed basis. The root container manager can simply unshare cgroupns and
> forget about the internal setup. I think this is useful just for the reason
> that it makes life much simpler for userspace.

If it's okay to require userland to just do bind mounting, I'd be far
happier with that.  cgroup mount code is already overcomplicated
because of the dynamic matching of supers to mounts when it could just
have told userland to use bind mounting.  Doesn't the host side have
to set up some of the filesystem layouts anyway?  Does it really
matter that we require the host to set up cgroup hierarchy too?

Thanks.

-- 
tejun
