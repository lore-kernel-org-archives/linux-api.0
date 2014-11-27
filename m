From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] lsm: namespace hooks
Date: Thu, 27 Nov 2014 18:38:31 +0100
Message-ID: <1417109911.1805.27.camel@samsung.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
	<CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
	<1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
	<1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
	<1417101060.1805.21.camel@samsung.com>
	<87d288zm3a.fsf@x220.int.ebiederm.org>
	<1417104439.1805.25.camel@samsung.com>
	<871tooy4nc.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-reply-to: <871tooy4nc.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Dempsky <mdempsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nikolay Aleksandrov <nikolay-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore@redh>
List-Id: linux-api@vger.kernel.org

On czw, 2014-11-27 at 10:44 -0600, Eric W. Biederman wrote:
> Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> writes:
> 
> > On czw, 2014-11-27 at 09:42 -0600, Eric W. Biederman wrote:

> >> We are probably going to need to go a couple rounds with this but at
> >> first approximation I think this functionality needs to be tied to the
> >> user namespace.  This functionality already looks half tied to it.

Actually it's not. You can create LSM/Smack namespace without user
namespace and it works properly.

> >> When mounting filesystems with user namespaces priveleges matures a
> >> little more you should be able to use unmapped labels.  In the near term
> >> we are looking at filesystems such as tmpfs, fuse and posibly extN.

Ok, I get the idea now. But still  think it wouldn't do well with the
Smack namespace. It would basically allow you to operate on something
that the administrator did not allowed you to (by filling the labels'
map).

If the user namespace allows such a thing now I was not aware. I'll have
a look.

> I had two points.
> a) Tie the label mapping to the user namespace, then we don't need any
>    new namespaces.
> 
>    Is there a reason not to tie the label mapping to the user namespace?

I remember that I entertained the idea when I started the work on that
and for some reason went against it.

Right now the major issue I see is that LSM by itself is not defined how
it's going to behave. It's up to a specific LSM module.

E.g. within the Smack namespace filling the map is a privileged
operation. So by tying them up you cripple the ability to create a fully
working user namespace as an unprivileged process.

I want to have Smack namespace be able to map its own label without
privileges (as user namespace can do with its own UID) but for now it's
not the case and I'm not sure it will ever be.

With other LSM implementation other limitations might apply.

Besides a use case (with other LSM modules) when someone might not want
to create an LSM namespace might be valid as well.

> 
>    Needing to modify every userspace that create containers to know
>    about every different lsm looks like a maintenance difficulty I would
>    prefer to avoid.

The LSM namespace is only one, it's not like every LSM modules creates a
different namespace. The LSM namespace is created for the LSM module
that is active at the moment. And user space might need to be aware of
them anyway as e.g. Smack requires you to create labels' map. Other
modules might require something different.


BTW: have you read the Smack-namespace readme I pasted in the cover
letter? It describes the idea behind namespace implementation in that
particular module.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
