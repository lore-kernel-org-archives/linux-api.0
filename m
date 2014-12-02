From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] lsm: namespace hooks
Date: Tue, 02 Dec 2014 13:43:13 +0100
Message-ID: <1417524193.1899.2.camel@samsung.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
	<CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
	<1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
	<1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
	<1417101060.1805.21.camel@samsung.com>
	<87d288zm3a.fsf@x220.int.ebiederm.org>
	<1417104439.1805.25.camel@samsung.com>
	<871tooy4nc.fsf@x220.int.ebiederm.org>
	<1417109911.1805.27.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-reply-to: <1417109911.1805.27.camel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
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
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matthew Dempsky <mdempsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nikolay Aleksandrov <nikolay-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Moore <pmoore@redha>
List-Id: linux-api@vger.kernel.org

On czw, 2014-11-27 at 18:38 +0100, Lukasz Pawelczyk wrote:
> Right now the major issue I see is that LSM by itself is not defined how
> it's going to behave. It's up to a specific LSM module.
> 
> E.g. within the Smack namespace filling the map is a privileged
> operation. So by tying them up you cripple the ability to create a fully
> working user namespace as an unprivileged process.

Entertaining the idea that LSM namespace would be tied to user namespace
(as you suggested) how do you see the limitation I described above?


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
