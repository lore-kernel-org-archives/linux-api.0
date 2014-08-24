From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 3/8] namespaces: expose ns instance serial numbers in
	proc
Date: Sun, 24 Aug 2014 16:28:26 -0400
Message-ID: <20140824202826.GH9003@madcap2.tricolour.ca>
References: <cover.1408581429.git.rgb@redhat.com>
	<cd6cd0622ce677b639afae18a69ff79c72490bab.1408581429.git.rgb@redhat.com>
	<CALCETrUnzG1V8w+H9ctAJP+Hvo8LQax=dhLG4bBpBKmVi+C1cQ@mail.gmail.com>
	<20140822015803.GG20529@madcap2.tricolour.ca>
	<CALCETrUkFD0iNi1SV_6ypN5Kf4GYybT5tzjRjRQuLzT9iBnQAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUkFD0iNi1SV_6ypN5Kf4GYybT5tzjRjRQuLzT9iBnQAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14/08/24, Andy Lutomirski wrote:
> On Thu, Aug 21, 2014 at 6:58 PM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 14/08/21, Andy Lutomirski wrote:
> >> On Aug 20, 2014 8:12 PM, "Richard Guy Briggs" <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > Expose the namespace instace serial numbers in the proc filesystem at
> >> > /proc/<pid>/ns/<ns>_snum.  The link text gives the serial number in hex.
> >>
> >> What's the use case?
> >>
> >> I understand the utility of giving unique numbers to the audit code,
> >> but I don't think this part is necessary for that, and I'd like to
> >> understand what else will use this before committing to a duplicative
> >> API like this.
> >
> > How does a container manager get those numbers?  It could provoke a task
> > to cause an audit event that emits a NS_INFO message, or it could run a
> > task in that container to report its namespace serial numbers directly
> > from its /proc mount.
> 
> Why does a container manager need them?  Is there any reason that
> keeping them entirely contained within the audit system would be a
> problem?

The audit system is currently per-kernel.  If a container is migrated
from one kernel to another, the first audit system is no longer able to
monitor or care about it.  It is the container manager's scope that has
the capability to monitor and care about it.

This might be a good argument to augment the audit system as we
currently know it to be able to do this across kernels, but that isn't
currently the case.

> > The discussion in this thread touches on the use cases:
> >         https://lkml.org/lkml/2014/4/22/662
> >
> >> Note that this API is thoroughly incompatible with CRIU.  If we do
> >> this, someone will ask for a namespace number namespace, and that way
> >> lies madness.
> >
> > I had a very brief look at CRIU, but not enough to understand the issue.
> > Others have hinted at this problem.
> >
> > Do you have a suggestion of a different approach that would be
> > compatible with CRIU?
> >
> > I'd originally considered some sort of UUID that would be globally
> > unique, but that would be very hard to devise or guarantee, and besides,
> > namespaces aren't only used by containers and could be shared in other
> > ways.  Tracking the usage and migration of namespaces should be the task
> > of an upper layer.
> 
> CRIU wants to save the complete state of a namespace and then restore
> it.  For that to work, any information exposed to things in the
> namespace *cannot* be globally unique or unique per boot, since CRIU
> needs to arrange for that information to match whatever it was when
> CRIU saved it.

So are you agreeing with Eric Biederman's idea that its proc inode
number should be initially assigned serially, but reserve the right to
be settable on a restore of a namespace from another host?  What if that
inode number collides with an existing one?

Does CRIU have no lattitude at all to be able to track a new namespace
ID?

> Also, I think that code running in a namespace has no business even
> knowing a unique identity of that namespace from the perspective of
> the host.

Too late.  There is already the namespace proc inode numbers.  That
number is almost completely meaningless to the code running inside the
container/namespace.

> Here's a specific use case for *not* exposing this: Tor.  Ideally, Tor
> clients would run in a namespace that does not know about any global
> identity.  That means no IP addresses, but it also means no global
> namespace serial numbers.

Well, it already has an IP address (which might be masqueraded by the
host or another upstream router) and a namespace inode number.

I'm not aware of support for anonymous namespaces, let along anonymous
containers yet.

> --Andy

- RGB

--
Richard Guy Briggs <rbriggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
