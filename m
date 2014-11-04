From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Tue, 4 Nov 2014 16:50:52 +0100
Message-ID: <20141104155052.GA7027@mail.hallyn.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<87y4rvrakn.fsf@x220.int.ebiederm.org>
	<CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
	<20141104134633.GA14014@htj.dyndns.org>
	<CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
> On Tue, Nov 4, 2014 at 5:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Hello, Aditya.
> >
> > On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
> >> I agree that this is effectively bind-mounting, but doing this in kernel
> >> makes it really convenient for the userspace. The process that sets up the
> >> container doesn't need to care whether it should bind-mount cgroupfs inside
> >> the container or not. The tasks inside the container can mount cgroupfs on
> >> as-needed basis. The root container manager can simply unshare cgroupns and
> >> forget about the internal setup. I think this is useful just for the reason
> >> that it makes life much simpler for userspace.
> >
> > If it's okay to require userland to just do bind mounting, I'd be far
> > happier with that.  cgroup mount code is already overcomplicated
> > because of the dynamic matching of supers to mounts when it could just
> > have told userland to use bind mounting.  Doesn't the host side have
> > to set up some of the filesystem layouts anyway?  Does it really
> > matter that we require the host to set up cgroup hierarchy too?
> >
> 
> Sort of, but only sort of.
> 
> You can create a container by unsharing namespaces, mounting
> everything, and then calling pivot_root.  But this is unpleasant
> because of the strange way that pid namespaces work -- you generally
> have to fork first, so this gets tedious.  And it doesn't integrate
> well with things like fstab or other container-side configuration
> mechanisms.
> 
> It's nicer if you can unshare namespaces, mount the bare minimum,
> pivot_root, and let the contained software do as much setup as
> possible.

Also, the bind-mount requires the container manager to know where
the guest distro will want the cgroups mounted.

-serge
