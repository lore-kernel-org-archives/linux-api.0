From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Thu, 16 Oct 2014 23:47:10 +0200
Message-ID: <20141016214710.GA4759@mail.hallyn.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
	<20141016211236.GA4308@mail.hallyn.com>
	<CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> >> setns on a cgroup namespace is allowed only if
> >> * task has CAP_SYS_ADMIN in its current user-namespace and
> >>   over the user-namespace associated with target cgroupns.
> >> * task's current cgroup is descendent of the target cgroupns-root
> >>   cgroup.
> >
> > What is the point of this?
> >
> > If I'm a user logged into
> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
> > a container which is in
> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
> > then I will want to be able to enter the container's cgroup.
> > The container's cgroup root is under my own (satisfying the
> > below condition0 but my cgroup is not a descendent of the
> > container's cgroup.
> >
> This condition is there because we don't want to do implicit cgroup
> changes when a process attaches to another cgroupns. cgroupns tries to
> preserve the invariant that at any point, your current cgroup is
> always under the cgroupns-root of your cgroup namespace. But in your
> example, if we allow a process in "session-c12.scope" container to
> attach to cgroupns root'ed at "session-c12.scope/x1" container
> (without implicitly moving its cgroup), then this invariant won't
> hold.

Oh, I see.  Guess that should be workable.  Thanks.

-serge
